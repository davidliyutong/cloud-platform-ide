# Introduction to Cloud IDE

## Change Password

Its recommand to modify your password immediately.

Modify `/root/.config/code-server/config.yaml`, save it:

```yaml=
bind-addr: 0.0.0.0:8080 # DO NOT EDIT
auth: password # DO NOT EDIT
password: speit # CHANGEME
cert: false # DO NOT EDIT
```

> If using pure digit password, use `'` to turn it into string
> ```yaml
> bind-addr: 0.0.0.0:8080 # DO NOT EDIT
> auth: password # DO NOT EDIT
> password: '31415926535' # CHANGEME
> cert: false # DO NOT EDIT
> ```
> using pure digit password is **strongly opposed**

execute `restart-container` in WebIDE's terminal to trigger a restart

> rebooting container will reset all files except those stored under `/root`

## Quata

Only the `/root` will be persisted during the course. All files will be wiped at the end of the course. Do not store precious data and run backups routinely.
