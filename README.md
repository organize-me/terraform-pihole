# terraform-pihole

Pi-hole is a local DNS server and ad-blocker for my network. This is a terraform configuration to deploy the Pi-hole
docker container.

## Notes
 - This isn't a general purpose setup. It makes assumptions about my system.

 - The Web-Admin is made unsecure. It's assumed that the reverse proxy is handling the security.

 - The Web-Admin port isn't exposed. Again, it's assumed that the reverse proxy is handling this.


## DNS

Pi-hole as a docker container doesn't work out of the box. I make use of docker networks and cannot set the network to
host. This implies that the rules for the DNS server needs to be loosened up a bit. It needs to allow all requests from
the docker network.

#### DNS Settings
```
Settings -> DNS -> Interface Settings -> Respond only on interface eth0
```

## Backup and Restore

Part of this terraform are the scripts to aid in the backup and restore process.

### Backup
The backup script will create a teleported backup of the Pi-hole configuration and upload it to a remote server.

### Restore
Unfortunately, there isn't a way to programmatically restore the backup. Restores are done manually through the Web-Admin
interface. A script is provided to download the backup from the remote server. The user will need to apply the backup.

#### Import
```
Settings -> Teleporter -> Import
```
