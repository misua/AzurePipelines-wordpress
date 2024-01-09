FROM ubuntu:22.04

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu70 wget unzip
RUN wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip && \
    unzip terraform_1.6.6_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_1.6.6_linux_amd64.zip

# Install kubectl
ENV TARGETARCH="linux-x64"
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${TARGETARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl


# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN useradd agent
RUN chown agent ./
USER agent
# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh
