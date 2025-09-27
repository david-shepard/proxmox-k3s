## k3s on proxmox 
![healthchecks.io](https://healthchecks.io/badge/b217edc2-9e77-4082-b44c-925c27/ASe4QgWU-2.svg)

Assorted scripts and configuration used to set up a kubernetes (k3s) homelab with 
1. Follow these steps https://gist.github.com/triangletodd/02f595cd4c0dc9aac5f7763ca2264185
   - Example [config](./config)

2. Refer to instructions: https://github.com/alexellis/k3sup
   - `k3sup install --ip 192.168.0.5 --user root`

## mDNS configuration
Using mDNS for node dns resolution as to avoid another LXC and associated with setting up a real DNS server (although it shouldn't be too difficult with [PiHole](https://community-scripts.github.io/ProxmoxVE/scripts?id=pihole)/[dnsmasq](https://pve.proxmox.com/wiki/Setup_Simple_Zone_With_SNAT_and_DHCP))

1. `sudo apt-get install avahi-daemon`

2. See [line 12 @ /etc/nsswitch.conf](./config/etc/nsswitch.conf#L12)
