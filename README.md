# terraform-pihole
Pi-hole Configuration

Local DNS server and ad-blocker for my network.

### Notes
 - Web-Admin isn't secured. In this setup it's assumed that the reverse proxy is handling security.
 - The Web-Admin port isn't exposed. Again, it's assumed that the reverse proxy is handling this.
   
 - Pi-hole dosen't seem to work out of the box with docker using the bridge network. You need to relax the DNS setting. This implies, though, that extra care need to be taken to not expose port 53 outside of the local network.

DNS Settings:
```
Settings -> DNS -> Interface Settings -> Respond only on interface eth0
```
