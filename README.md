### Minecraft Server Startup
My sons like to play minecraft with their aunt, my always-on $5/month Digital Ocean VM is too small to support it (not enough RAM). So I wrote this to help be bring up a Minecraft server and take it down.  The up part is done, but not abstracted, the down part shouldn't be too bad, just haven't gotten to it yet.

Requirements:
* `s3cmd`
* AWS S3 credentials in `.s3cmd` file. Create with `s3cmd --configure`
* Digital Ocean api client `tugboat` configured for your account
* Ansible


### Getting Started
This basically works, there is still one step in the ansible playbook that is failing unless run interactively...have to investigate further. But it gets me 95% of the way to a functional minecraft server.
```
mv config.sample config
# Edit with your digital ocean API keys
./up
## Will fail at SSH step, wait a few minutes then
./up
## Play minecradt
./down
```

