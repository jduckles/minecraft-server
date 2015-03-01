### Minecraft Server Startup
My sons like to play minecraft with their aunt, my always-on $5/month Digital Ocean VM is too small to support it (not enough RAM). So I wrote this to help be bring up a Minecraft server and take it down.  `up` will set up the VM, download a tarball of saved server info, `down` backs up the server info and shuts the vm down. Still not 100%, there are a few hiccups in the playbook, but it saves me a lot of time getting things pretty damn close.

Requirements:
* `s3cmd`
  * AWS S3 credentials in `.s3cmd` file. Create with `s3cmd --configure` once installed
  * Mac: `brew install s3cmd`
  * Unix: `apt-get install s3cmd`
* Ansible
* [Digital Ocean v1 API keys](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-deprecated)
* AWS account for S3


### Getting Started
This basically works, there is still one step in the ansible playbook that is failing unless run interactively...have to investigate further. But it gets me 95% of the way to a functional minecraft server.
1. `mv config.sample config`
2. tweak variables.yml for your needs, this assumes you already have server backups, so you may need to manually `msm server create ...` your server and get it in an appropriate s3 bucket first.


```
# Edit with your digital ocean API keys
./up
## Will fail at SSH step as server doesn't come up instantly, wait a few minutes then (gotta fix that)
./up
## Play minecraft for as long as you're willing to pay for the VM
./down
```

