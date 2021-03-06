#!/bin/sh
set -eu

if [ -z "$INPUT_REMOTE_HOST" ]; then
    echo "Input remote_host is required!"
    exit 1
fi

# Extra handling for SSH-based connections.
if [ ${INPUT_REMOTE_HOST#"ssh://"} != "$INPUT_REMOTE_HOST" ]; then
    SSH_HOST=${INPUT_REMOTE_HOST#"ssh://"}
    SSH_HOST=${SSH_HOST#*@}

    if [ -z "$INPUT_SSH_PRIVATE_KEY" ]; then
        echo "Input ssh_private_key is required for SSH hosts!"
        exit 1
    fi


    echo "Registering SSH keys..."

    # Save private key to a file and register it with the agent.

    mkdir -p "/root/.ssh"
    printf '%s' "$INPUT_SSH_PRIVATE_KEY" > "/root/.ssh/docker"

    ssh-keyscan -H "$SSH_HOST" > "/root/.ssh/known_hosts"
    chmod -R 600 "/root/.ssh"

    eval $(ssh-agent)
    ssh-add "/root/.ssh/docker"

fi

echo "Connecting to $INPUT_REMOTE_HOST..."
docker --log-level debug --host "$INPUT_REMOTE_HOST" "$@" 2>&1
