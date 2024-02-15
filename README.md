# ChBox

### Customize the chbox image

To build a custom chbox image derived from quay.io/centos-bootc/centos-bootc:stream9, use the Containerfile in this repo, then run

` podman build -t quay.io/your-repo/your-os:tag . `

` podman push quay.io/your-repo/your-os:tag `

` ssh -i ~/.ssh/your-key centos@vm-ipaddress `

` sudo bootc switch quay.io/your-repo/your-os:tag `

` sudo reboot `
