FROM php:7.4-cli

#Accept input argument
ARG SSH_PRIVATE_KEY
ARG GIT_BRANCH

# Install Git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# Make ssh dir
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add github key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Install Deployer
RUN curl -LO https://deployer.org/deployer.phar && \
	mv deployer.phar /usr/local/bin/dep && \
	chmod +x /usr/local/bin/dep

# Clone project
RUN cd /opt && \
    git clone --single-branch --branch ${GIT_BRANCH} git@github.com:huongnx-0984/autodeploy_example.git clone_app

# Run deployer
RUN cd /opt/clone_app && dep deploy staging

# feat A change
WORKDIR /opt/clone_app

CMD [ "php" ]
