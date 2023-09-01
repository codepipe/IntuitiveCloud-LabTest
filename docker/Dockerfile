FROM ubuntu:22.04

### Install the following dependenices in the docker image
# 
# curl iproute2 sshfs unzip less groff 
# Install kubectl from https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
#
# Install AWS CLI from https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
# 
# Install the above tools, unpack and make it available in the PATH executable
###

# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    iproute2 \
    sshfs \
    unzip \
    less \
    groff \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip

# Set the PATH to include kubectl and AWS CLI
ENV PATH="/usr/local/bin:$PATH"

# Specify the default command to run when the container starts
CMD ["/bin/bash"]


