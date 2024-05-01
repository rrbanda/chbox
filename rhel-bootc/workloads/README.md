### Run chbox as a systemd service

```bash
cp chbox.yaml /etc/containers/systemd/chbox.yaml
cp chbox.kube /etc/containers/chbox.kube
cp chbox.image /etc/containers/chbox.image
/usr/libexec/podman/quadlet --dryrun (optional)
systemctl daemon-reload
systemctl start chbox
```
