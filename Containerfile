FROM quay.io/centos-bootc/fedora-bootc:eln

# Chris containers
COPY workloads/chbox.kube/etc/containers/systemd/chbox.kube
COPY workloads/chbox.yaml /etc/containers/systemd/chbox.yaml
COPY workloads/chbox.image /etc/containers/systemd/chbox.image

RUN echo "root:secure" | chpasswd
COPY wheel-passwordless-sudo /etc/sudoers.d/wheel-passwordless-sudo

RUN podman pull --root=/usr/lib/containers/storage quay.io/rbrhssa/chbox
RUN dnf install -y vim && dnf clean all
RUN mkdir /usr/etc-system && \
    echo 'AuthorizedKeysFile /usr/etc-system/%u.keys' >> /etc/ssh/sshd_config.d/30-auth-system.conf && \
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmDZ4wVgaz2jV/QoRPtk0n+rBaDwozyl9aMmRB7dFbW/uSU+Ltimxc70x2/DtvVvLuX23BBX5M2RfCwPo7YRz9HF2iqFZ4zVXHELHf+fSTz0KejMkmvJh2uu+uubTppEOLJcQip6GamyoQIJ2C3cFYiHDaSDIE/Q6IgOJkBdh5oOQYNeva7kSr8aNIg1G3hHE7sZmCbasImcZqnMsBpYLQ7TXc0H115ZSweiRsBqPtx7uJ9XcVw7i6XtarbeZgUzlHlVP1QtyeX6Oz44VFHGw8cbnqhN78RBHodZcocKxIYlMgayRTUVOn5o8fujkLf6lTE8COKgM06vAhWGCCKfLn3DmjoQNQgSEwmciHaq5DpY04sv0iPaMLjhbRyI/a1Jw/ugrEtG1Y4sDJx9hLBukvHX1xFitOLqBhJwiySy20/AuktOQRYbRazjXTjLAJxz1niATWkp6N+c/r8P91aLzORSdm5LB9dIMfADwVGHrA1TIxsSpbKLtqIaVILwnuEOUvbkDd+/XOstL1rI03ok9DbydM4eCUVv6aePPRtHWezh18E+Me/sk6PMmFV5WrCKJ3QzCu2MssXyYm/+EIi6YKEJcdRcVMsb+ASHVFeqAPoTHrf1uSenw0opU4jaXJij+JEs6ZvmJa2gBIxbRhUSfw+2t/C9ua8dkdQfF1CaPOWw== raghurambanda@raghurambanda-mac' > /usr/etc-system/root.keys && chmod 0600 /usr/etc-system/root.keys

ENTRYPOINT ["/sbin/init"]
