# chbox

To build image run below commands

` podman build -t quay.io/your-repo/your-os:tag . `

` podman push quay.io/your-repo/your-os:tag `

` ssh -i ~/.ssh/your-key centos@vm-ipaddress `

` sudo bootc switch quay.io/your-repo/your-os:tag `

` sudo reboot `
