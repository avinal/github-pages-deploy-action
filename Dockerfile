FROM ubuntu:latest

# Add files to docker
ADD entrypoint.sh /

# Run update and install packages
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y git make python3-pip

# Install gp-import 
RUN pip3 install ghp-import

# grant permissions
RUN chmod +x entrypoint.sh

# Run final Script
CMD /entrypoint.sh