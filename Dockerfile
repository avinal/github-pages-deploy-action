FROM ubuntu:latest

# Add files to docker
ADD entrypoint.sh /

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Run update and install packages
RUN apt-get update && apt-get install -y git make python3-pip

# Install gp-import 
RUN pip3 install ghp-import

# grant permissions
RUN chmod +x entrypoint.sh

# Run final Script
CMD /entrypoint.sh