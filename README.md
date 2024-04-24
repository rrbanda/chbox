## ChRIS using Image based Linux Operating System

### Containerfile to build a bootc image embedded with ChRIS application quadlets

```
# Specifies the base image that this container will be built upon.
# It's pulling from the image quay.io/centos-bootc/fedora-bootc:eln with the tag eln.
FROM quay.io/centos-bootc/centos-bootc-dev:stream9

# Copies a file named chbox.kube from the host into the container, 
# specifically into the path /etc/containers/systemd/chbox.kube.
COPY workloads/chbox.kube /etc/containers/systemd/chbox.kube

# Copies a file named chatbot.yaml from the host into the container, specifically into the path /etc/containers/systemd/chbox.yaml.
COPY workloads/chbox.yaml /etc/containers/systemd/chbox.yaml

# Copies a file named chbox.image from the host into the container, specifically into the path /etc/containers/systemd/chbox.image.
COPY workloads/chbox.image /etc/containers/systemd/chbox.image

# Runs a command inside the container. 
# It's using echo to create a string (root:secure) and then piping it to chpasswd, which updates the password for the root user.
# RUN echo "root:secure" | chpasswd

# Copies a file named wheel-passwordless-sudo from the host into the container, specifically into the path /etc/sudoers.d/wheel-passwordless-sudo. 
# This file is likely configuring sudo to allow members of the wheel group to execute commands without a password.
# COPY wheel-passwordless-sudo /etc/sudoers.d/wheel-passwordless-sudo

# Runs two commands inside the container. First, it installs the vim package using dnf (the package manager for Fedora-based systems), then it cleans up any cached package data.
RUN dnf install -y vim && dnf clean all

# Creates a directory /usr/etc-system and then echoes the SSH configuration into a file 30-auth-system.conf. It also adds an SSH public key into another file root.keys.
RUN mkdir /usr/etc-system && \
    echo 'AuthorizedKeysFile /usr/etc-system/%u.keys' >> /etc/ssh/sshd_config.d/30-auth-system.conf && \
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmDZ4wVgaz2jV/QoRPtk0n+rBaDwozyl9aMmRB7dFbW/uSU+Ltimxc70x2/DtvVvLuX23BBX5M2RfCwPo7YRz9HF2iqFZ4zVXHELHf+fSTz0KejMkmvJh2uu+uubTppEOLJcQip6GamyoQIJ2C3cFYiHDaSDIE/Q6IgOJkBdh5oOQYNeva7kSr8aNIg1G3hHE7sZmCbasImcZqnMsBpYLQ7TXc0H115ZSweiRsBqPtx7uJ9XcVw7i6XtarbeZgUzlHlVP1QtyeX6Oz44VFHGw8cbnqhN78RBHodZcocKxIYlMgayRTUVOn5o8fujkLf6lTE8COKgM06vAhWGCCKfLn3DmjoQNQgSEwmciHaq5DpY04sv0iPaMLjhbRyI/a1Jw/ugrEtG1Y4sDJx9hLBukvHX1xFitOLqBhJwiySy20/AuktOQRYbRazjXTjLAJxz1niATWkp6N+c/r8P91aLzORSdm5LB9dIMfADwVGHrA1TIxsSpbKLtqIaVILwnuEOUvbkDd+/XOstL1rI03ok9DbydM4eCUVv6aePPRtHWezh18E+Me/sk6PMmFV5WrCKJ3QzCu2MssXyYm/+EIi6YKEJcdRcVMsb+ASHVFeqAPoTHrf1uSenw0opU4jaXJij+JEs6ZvmJa2gBIxbRhUSfw+2t/C9ua8dkdQfF1CaPOWw== raghurambanda@raghurambanda-mac' > /usr/etc-system/root.keys && chmod 0600 /usr/etc-system/root.keys

# Specifies the command that will be run when the container starts. In this case, it's /sbin/init, which is the initialization process for the container.
CMD ["/sbin/init"]


# Start the Podman socket service
CMD ["systemctl", "start", "podman.socket"]

# Enable the Podman socket service to start on boot
RUN systemctl enable podman.socket

```

### Build a bootc image for ChRIS using bootc 

`
podman build -t quay.io/rbrhssa/chbox:1.5 .
`

### Push the image to  quay.io repository 

`
podman push quay.io/rbrhssa/chbox:1.5
`

### Create bootc image for ChRIS using Podman Desktop

<img width="1512" alt="Screenshot 2024-04-22 at 6 20 05 PM" src="https://github.com/veniceofcode/chbox/assets/93591339/4b7699aa-0b9c-49b3-9424-10f385343d92">



### Build bootc image using Podman Desktop for ChRIS 

<img width="1510" alt="Screenshot 2024-04-22 at 6 16 49 PM" src="https://github.com/veniceofcode/chbox/assets/93591339/c93dd001-b1d4-46fd-983c-6877edd1a404">


### Run bootc on an existing RHEL 9.X machine 

` 
sudo podman run --rm --privileged --pid=host -v /:/target -v /var/lib/containers:/var/lib/containers --security-opt label=type:unconfined_t quay.io/rbrhssa/chbox:1.5 bootc install to-filesystem --karg=console=ttyS0,115200n8 --replace=alongside /target 
`
### Output

```
Trying to pull quay.io/rbrhssa/chbox:1.5...
Getting image source signatures
Copying blob 86ff997c30cd done  
Copying blob c3f4f8980e29 done  
Copying blob cb70cdc95b0d done  
Copying blob 930c4135dd1c done  
Copying blob 86ff997c30cd done  
Copying blob c3f4f8980e29 done  
Copying blob cb70cdc95b0d done  
Copying blob 86ff997c30cd done  
Copying blob c3f4f8980e29 done  
Copying blob 1312c953f350 done  
Copying blob 5163072832fc done  
Copying config 5c8ae7dc5a done  
Writing manifest to image destination
Storing signatures
Installing image: docker://quay.io/rbrhssa/chbox:1.5
Digest: sha256:f136a78a314067d56a80fed35341072cb8b8ab124437627701274b1149e72762
Initializing ostree layout
Initializing sysroot
ostree/deploy/default initialized as OSTree stateroot
Deploying container image
Deployment complete
Running bootupctl to install bootloader
Installed: grub.cfg
Installation complete!

```

### Perform reboot to access the bootc machine

`
[root@dhcp-10-26-67-18]# systemctl reboot 
`

### Access the machine once reboot is completed

`
 ➜  ~ ssh root@3.133.184.191   
`

`
The authenticity of host '3.133.184.191 (3.133.184.191)' can't be established.
ED25519 key fingerprint is SHA256:bKQlNXzRNC/S/SBmTGq9Aqz7Sp01AQVLYf/jp9iID1U.
This key is not known by any other names.
`

`
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '3.133.184.191' (ED25519) to the list of known hosts.
`

`
[root@ip-192-168-0-74 ~]#  
`

### Check Status of a bootc system that is running ChRIS


 `
 bootc status
 `
 
```
apiVersion: org.containers.bootc/v1alpha1
kind: BootcHost
metadata:
  name: host
spec:
  image:
    image: quay.io/rbrhssa/chbox:1.5
    transport: registry
  bootOrder: default
status:
  staged: null
  booted:
    image:
      image:
        image: quay.io/rbrhssa/chbox:1.5
        transport: registry
      version: stream9.20240411.0
      timestamp: null
      imageDigest: sha256:f136a78a314067d56a80fed35341072cb8b8ab124437627701274b1149e72762
    cachedUpdate: null
    incompatible: false
    pinned: false
    ostree:
      checksum: 7597d123bb7ca67a0000da5689c80ab5a14aa9eb4540c9fca6734b19e479ed61
      deploySerial: 0
  rollback:
    image:
      image:
        image: quay.io/rbrhssa/chbox:1.5
        transport: registry
      version: stream9.20240411.0
      timestamp: null
      imageDigest: sha256:88aa2ff479e3b93b522e1aee9d246ac1d83511b180e3ebc9253b168fc2bb01cb
    cachedUpdate:
      image:
        image: quay.io/rbrhssa/chbox:1.5
        transport: registry
      version: stream9.20240411.0
      timestamp: null
      imageDigest: sha256:f136a78a314067d56a80fed35341072cb8b8ab124437627701274b1149e72762
    incompatible: false
    pinned: false
    ostree:
      checksum: dc8e3a7e6d4a3c6d94aed5a9eae7e0e03aa0e1caece2835d1b8ce48ea5756bcf
      deploySerial: 0
  rollbackQueued: false
  type: bootcHost
  
```

### Get host info
`
hostnamectl
`

``` 
   Static hostname: (unset)                         
Transient hostname: dhcp-10-26-67-18
         Icon name: computer-desktop
           Chassis: desktop 🖥️
        Machine ID: 669a3114eb9b417dba42c7b6948f2013
           Boot ID: 580cbd7c1df44008910c39a1dc6028b2
  Operating System: CentOS Stream 9                 
       CPE OS Name: cpe:/o:centos:centos:9
            Kernel: Linux 5.14.0-435.el9.x86_64
      Architecture: x86-64
   Hardware Vendor: OnLogic
    Hardware Model: HX500
  Firmware Version: Z01-0002A034

```
### Get  ChRIS containers info that are running on image based Linux

`
podman ps -a
`

```
CONTAINER ID  IMAGE                                          COMMAND               CREATED        STATUS                  PORTS                   NAMES
96c799b72e72  localhost/podman-pause:4.9.4-dev-1710930166                          6 minutes ago  Up 6 minutes                                    1bf5e4561f80-service
c453a4dac0f2  localhost/podman-pause:4.9.4-dev-1710930166                          6 minutes ago  Up 6 minutes                                    229308b4cf91-infra
3335eb7a1125  docker.io/library/postgres:16                  postgres              6 minutes ago  Up 6 minutes                                    minichris-postgres-pod-postgres
6c02c404c0e0  localhost/podman-pause:4.9.4-dev-1710930166                          6 minutes ago  Up 6 minutes                                    bdc1b8ef7a61-infra
48ce0c77c039  docker.io/library/rabbitmq:3                   rabbitmq-server       6 minutes ago  Up 6 minutes                                    minichris-rabbitmq-pod-rabbitmq
95d6dd12fdf9  localhost/podman-pause:4.9.4-dev-1710930166                          6 minutes ago  Up 6 minutes            0.0.0.0:8000->8000/tcp  8542d9b11ad4-infra
b1c4b9415890  ghcr.io/fnndsc/cube:5.0.0                      gunicorn -b 0.0.0...  6 minutes ago  Up 6 minutes (healthy)  0.0.0.0:8000->8000/tcp  minichris-cube-pod-server
2b9b6c1d1290  ghcr.io/fnndsc/cube:5.0.0                                            6 minutes ago  Up 6 minutes (healthy)  0.0.0.0:8000->8000/tcp  minichris-cube-pod-cube-worker
7d04c669be68  ghcr.io/fnndsc/cube:5.0.0                                            6 minutes ago  Up 6 minutes (healthy)  0.0.0.0:8000->8000/tcp  minichris-cube-pod-cube-worker-periodic
627d5a0407e7  ghcr.io/fnndsc/cube:5.0.0                                            6 minutes ago  Up 6 minutes (healthy)  0.0.0.0:8000->8000/tcp  minichris-cube-pod-cube-celery-beat
8402a963d316  localhost/podman-pause:4.9.4-dev-1710930166                          6 minutes ago  Up 6 minutes            0.0.0.0:8020->3000/tcp  6962c7b33b10-infra
cb065dff1de2  ghcr.io/fnndsc/chris_ui:20231003.270-01f1a863  sirv --host --sin...  6 minutes ago  Up 6 minutes            0.0.0.0:8020->3000/tcp  minichris-chrisui-pod-chrisui
1c954beb1e56  localhost/podman-pause:4.9.4-dev-1710930166                          6 minutes ago  Up 6 minutes                                    90142358b529-infra
a022fa0208fc  ghcr.io/fnndsc/pfcon:5.2.2                     gunicorn --bind 0...  6 minutes ago  Up 6 minutes                                    minichris-pfcon-pod-pfcon
1df63e093333  ghcr.io/fnndsc/pman:6.0.1                      gunicorn --bind 0...  6 minutes ago  Up 6 minutes                                    minichris-pfcon-pod-pman

```
