# Specifies the base image that this container will be built upon.
FROM quay.io/centos-bootc/centos-bootc-dev:stream9

# Copies a file named chbox.kube from the host into the container, 
# specifically into the path /etc/containers/systemd/chbox.kube.
COPY workloads/chbox.kube /etc/containers/systemd/chbox.kube

# Copies a file named chatbot.yaml from the host into the container, specifically into the path /etc/containers/systemd/chbox.yaml.
COPY workloads/chbox.yaml /etc/containers/systemd/chbox.yaml

# Copies a file named chbox.image from the host into the container, specifically into the path /etc/containers/systemd/chbox.image.
COPY workloads/chbox.image /etc/containers/systemd/chbox.image

# Runs two commands inside the container. First, it installs the vim package using dnf (the package manager for Fedora-based systems), then it cleans up any cached package data.
RUN dnf install -y vim && \
    dnf install -y skopeo && \
    dnf clean all

# Creates a directory /usr/etc-system and then echoes the SSH configuration into a file 30-auth-system.conf. It also adds SSH public keys into the files authorized_keys.
ARG SSH_KEYS
RUN mkdir -p /usr/etc-system && \
    echo 'AuthorizedKeysFile /usr/etc-system/authorized_keys' >> /etc/ssh/sshd_config.d/30-auth-system.conf && \
    echo "${SSH_KEYS}" > /usr/etc-system/authorized_keys && \
    chmod 0600 /usr/etc-system/authorized_keys

# Specifies the command that will be run when the container starts. In this case, it's /sbin/init, which is the initialization process for the container.
CMD ["/sbin/init"]

# Start the Podman socket service
CMD ["systemctl", "start", "podman.socket"]

# Enable the Podman socket service to start on boot
RUN systemctl enable podman.socket

