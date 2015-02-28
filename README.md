### Minecraft Server Startup
My sons like to play minecraft with their aunt, my always-on $5/month Digital Ocean VM is too small to support it (not enough RAM). So I wrote this to help be bring up a Minecraft server and take it down.

Requirements:
* `s3cmd`
* AWS S3 credentials in `.s3cmd` file. Create with `s3cmd --configure`
* Digital Ocean api client `tugboat` configured for your account
* Ansible


