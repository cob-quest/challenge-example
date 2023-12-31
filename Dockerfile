FROM ubuntu:jammy

# Avoid interactive prompt when apt-get installing tzdata dependency
ARG DEBIAN_FRONTEND=noninteractive

# Unminimize the ubuntu image
RUN yes | unminimize

# Update pkg cache & Install SSH server & Restore manpages
RUN apt-get update ; \ 
  apt-get -y upgrade;

# Install required dependencies
RUN apt-get install -y openssh-server git-all build-essential htop netcat net-tools iputils-ping sysstat sudo;

# Install other packages
RUN apt-get -y install curl unzip man-db nano vim dnsutils tree;

# Setup user and permissions
RUN addgroup --gid 1337 workshop; \
  adduser --gid 1337 --uid 1337 --disabled-password --gecos "" workshop; \
  echo "workshop:aceCLI!" | chpasswd;

RUN addgroup --gid 1414 pastaman; \
  adduser --gid 1414 --uid 1414 --disabled-password --gecos "" pastaman; \
  echo "pastaman:pasta" | chpasswd;

# Create privilege separation directory
RUN mkdir -p /run/sshd

# Add user to sudoers
RUN usermod -aG sudo workshop

COPY ex/ /bin/

RUN chmod 705 /bin/ex* && chmod 705 /bin/submit

USER workshop

WORKDIR /home/workshop

# Put in the copypasta files
COPY --chown=workshop:workshop pasta/* pasta/

USER root

# Set all secret files to no RWX
RUN chmod 000 pasta/secret*.txt

# Change ownership of files
RUN chown pastaman:pastaman pasta/secret2.txt; \
  chown root:root pasta/secret3.txt;

USER workshop

# Create directory structure to play with
RUN mkdir -p folder_a/folder_b/folder_c; \
  mkdir -p folder_a/folder_b/folder_d/folder_e; \
  mkdir -p folder_a/folder_b/folder_d/folder_f; \
  touch folder_a/folder_b/folder_c/file1.txt; \
  touch folder_a/folder_b/folder_d/folder_e/file2.txt; \
  touch folder_a/folder_b/folder_d/folder_e/file3.txt; \
  echo "This is a hidden file!" > folder_a/folder_b/folder_d/folder_f/.file4.txt;

COPY instructions.txt /etc/homework/.hidden.txt
COPY instructions /home/workshop/instructions

COPY --chown=workshop:workshop ex/mark.py pasta/mark.py
RUN chmod 777 pasta/mark.py

# Start SSH
EXPOSE 22

USER root

CMD ["/usr/sbin/sshd", "-E", "/var/log/secure", "-D"]
