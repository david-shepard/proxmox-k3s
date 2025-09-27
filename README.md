## k3s on proxmox 

1. Follow these steps https://gist.github.com/triangletodd/02f595cd4c0dc9aac5f7763ca2264185
   - Example config in [config](./config)

2. See instructions https://github.com/alexellis/k3sup
   - `k3sup install --ip 192.168.1.206 --user root`

## mDNS configuration

1. `sudo apt-get install avahi-daemon`

2. See [line 14 @ /etc/nsswitch.conf](./config/etc/nsswitch.conf)
