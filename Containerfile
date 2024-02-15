# This line specifies the base image that this container will be built upon.
# It's pulling from the image quay.io/centos-bootc/fedora-bootc:eln with the tag eln.
FROM quay.io/centos-bootc/fedora-bootc:eln

# This line copies a file named chbox.kube from the host into the container, 
# specifically into the path /etc/containers/systemd/chbox.kube.
COPY workloads/chbox.kube/etc/containers/systemd/chbox.kube

# This line copies a file named chatbot.yaml from the host into the container, specifically into the path /etc/containers/systemd/chbox.yaml.
COPY workloads/chbox.yaml /etc/containers/systemd/chbox.yaml

# This line copies a file named chbox.image from the host into the container, specifically into the path /etc/containers/systemd/chbox.image.
COPY workloads/chbox.image /etc/containers/systemd/chbox.image

# This line runs a command inside the container. 
# It's using echo to create a string (root:secure) and then piping it to chpasswd, which updates the password for the root user.
RUN echo "root:secure" | chpasswd

# This line copies a file named wheel-passwordless-sudo from the host into the container, specifically into the path /etc/sudoers.d/wheel-passwordless-sudo. 
# This file is likely configuring sudo to allow members of the wheel group to execute commands without a password.
COPY wheel-passwordless-sudo /etc/sudoers.d/wheel-passwordless-sudo


# This line runs a command inside the container to pull another container image (quay.io/rbrhssa/chbox) using Podman and stores it in a specific root directory (/usr/lib/containers/storage). 
# This likely preloads an image needed for later usage.
RUN podman pull --root=/usr/lib/containers/storage quay.io/rbrhssa/chbox

# This line runs two commands inside the container. First, it installs the vim package using dnf (the package manager for Fedora-based systems), then it cleans up any cached package data.
RUN dnf install -y vim && dnf clean all

# This line creates a directory /usr/etc-system and then echoes some SSH configuration into a file 30-auth-system.conf. It also adds an SSH public key into another file root.keys.
RUN mkdir /usr/etc-system && \
    echo 'AuthorizedKeysFile /usr/etc-system/%u.keys' >> /etc/ssh/sshd_config.d/30-auth-system.conf && \
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmDZ4wVgaz2jV/QoRPtk0n+rBaDwozyl9aMmRB7dFbW/uSU+Ltimxc70x2/DtvVvLuX23BBX5M2RfCwPo7YRz9HF2iqFZ4zVXHELHf+fSTz0KejMkmvJh2uu+uubTppEOLJcQip6GamyoQIJ2C3cFYiHDaSDIE/Q6IgOJkBdh5oOQYNeva7kSr8aNIg1G3hHE7sZmCbasImcZqnMsBpYLQ7TXc0H115ZSweiRsBqPtx7uJ9XcVw7i6XtarbeZgUzlHlVP1QtyeX6Oz44VFHGw8cbnqhN78RBHodZcocKxIYlMgayRTUVOn5o8fujkLf6lTE8COKgM06vAhWGCCKfLn3DmjoQNQgSEwmciHaq5DpY04sv0iPaMLjhbRyI/a1Jw/ugrEtG1Y4sDJx9hLBukvHX1xFitOLqBhJwiySy20/AuktOQRYbRazjXTjLAJxz1niATWkp6N+c/r8P91aLzORSdm5LB9dIMfADwVGHrA1TIxsSpbKLtqIaVILwnuEOUvbkDd+/XOstL1rI03ok9DbydM4eCUVv6aePPRtHWezh18E+Me/sk6PMmFV5WrCKJ3QzCu2MssXyYm/+EIi6YKEJcdRcVMsb+ASHVFeqAPoTHrf1uSenw0opU4jaXJij+JEs6ZvmJa2gBIxbRhUSfw+2t/C9ua8dkdQfF1CaPOWw== raghurambanda@raghurambanda-mac' > /usr/etc-system/root.keys && chmod 0600 /usr/etc-system/root.keys

# This line specifies the command that will be run when the container starts. In this case, it's /sbin/init, which is the initialization process for the container.
ENTRYPOINT ["/sbin/init"]
