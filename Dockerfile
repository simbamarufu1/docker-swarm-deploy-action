FROM docker:stable

LABEL "name"="Docker Swarm Deploy Action"

LABEL "com.github.actions.name"="Docker Swarm Deploy"
LABEL "com.github.actions.description"="Deploy a stack to a remote Docker swarm."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

RUN apk --no-cache add openssh-client

COPY config /root/.ssh/config
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
