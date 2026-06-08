# Kali on OPi5B via LXC

Last reviewed: 2026-05-26

This is the exact setup path for an Orange Pi 5B that keeps the board stable and still gives you a full Kali userland.

Architecture:
- Host OS: Armbian Debian 13 Minimal (CLI), `vendor` kernel `6.1.115`
- Kali OS: arm64 Kali Linux inside an unprivileged LXC container

Why this layout:
- OPi5B is currently a community rolling target in Armbian.
- Kali does not currently publish a dedicated prebuilt OPi5B image page.
- Kali officially recommends containers for running Kali inside other Linux distributions, and prefers LXC/LXD for entire systems.
- Debian warns against mixing cross-distro repositories directly on the host.

## 1. Flash the host OS

Pick this exact image in Armbian Imager:
- `Debian 13`
- `trixie`
- `Minimal (CLI)`
- `vendor`
- `6.1.115`

Boot order:
1. Flash microSD.
2. Insert microSD into the OPi5B.
3. Connect Ethernet.
4. Connect a 5V/4A USB-C power supply.
5. Wait 1-2 minutes.

## 2. First login

From your Mac:

```bash
ssh root@<opi-ip>
```

On first boot:
1. Accept the SSH host key.
2. Use the default password `1234`.
3. Choose `bash`.
4. Set a new root password.
5. Create your normal user `kimo`.

## 3. Update the host and install your key

Log in as `kimo`, then run:

```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

From your Mac:

```bash
ssh-copy-id kimo@<opi-ip>
ssh kimo@<opi-ip>
```

## 4. Harden the host

Copy the repo script to the board:

```bash
scp scripts/opi5b_postinstall.sh kimo@<opi-ip>:~/
```

Run it:

```bash
ssh kimo@<opi-ip>
chmod +x ~/opi5b_postinstall.sh
sudo ~/opi5b_postinstall.sh
```

Verify:

```bash
sudo sshd -T | egrep 'passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication'
sudo ufw status verbose
```

## 5. Move the host to eMMC

Only do this after:
- SSH key login works
- one reboot succeeds
- networking is stable

Run:

```bash
sudo armbian-install
```

Choose the option that installs the current system to eMMC.

After the install finishes:
1. Power the board off.
2. Remove the microSD.
3. Power it back on.
4. SSH in again and confirm you are now booting from eMMC.

## 6. Install LXC on the host

On the OPi5B host:

```bash
sudo apt update
sudo apt install -y lxc libvirt0 libpam-cgfs bridge-utils libvirt-clients libvirt-daemon-system iptables ebtables dnsmasq-base
```

## 7. Configure the host for unprivileged LXC

Still on the OPi5B host, run these commands exactly:

```bash
echo "$USER veth virbr0 10" | sudo tee /etc/lxc/lxc-usernet
sudo sh -c 'echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/80-lxc-userns.conf'
sudo sysctl --system
sudo chmod u+s /usr/libexec/lxc/lxc-user-nic
mkdir -p ~/.config/lxc
cp /etc/lxc/default.conf ~/.config/lxc/default.conf
sed -i 's/lxc.apparmor.profile = generated/lxc.apparmor.profile = unconfined/g' ~/.config/lxc/default.conf
grep "$USER" /etc/subuid
grep "$USER" /etc/subgid
```

Expected `subuid` and `subgid` output will look like:

```text
kimo:100000:65536
kimo:100000:65536
```

Now append the ID maps. If your numbers match the example above, run:

```bash
echo 'lxc.idmap = u 0 100000 65536' >> ~/.config/lxc/default.conf
echo 'lxc.idmap = g 0 100000 65536' >> ~/.config/lxc/default.conf
```

If your numbers differ, replace `100000` and `65536` with your actual values.

## 8. Enable the default libvirt network

Run:

```bash
sudo virsh net-start default
sudo virsh net-autostart default
```

Check:

```bash
sudo virsh net-list --all
```

You want `default` to show `active` and `autostart`.

If `default` does not exist, run:

```bash
sudo virsh net-define /usr/share/libvirt/networks/default.xml
sudo virsh net-start default
sudo virsh net-autostart default
```

## 9. Create the Kali container

Run:

```bash
lxc-create -t download -n kali-arm64
```

When prompted, answer:
- `Distribution:` `kali`
- `Release:` `current`
- `Architecture:` `arm64`

## 10. Start the Kali container

Run:

```bash
lxc-start -n kali-arm64 -d
lxc-ls -f
```

You want to see the container in the list with state `RUNNING`.

## 11. Update Kali inside the container

Run:

```bash
lxc-attach -n kali-arm64 -- apt update
lxc-attach -n kali-arm64 -- apt full-upgrade -y
```

## 12. Install Kali metapackages

Pick one of these paths.

Recommended balanced install:

```bash
lxc-attach -n kali-arm64 -- apt install -y kali-linux-default kali-linux-arm
```

If you want a bigger toolkit without literally everything:

```bash
lxc-attach -n kali-arm64 -- apt install -y kali-linux-large kali-linux-arm
```

If you truly want almost everything and have enough storage:

```bash
lxc-attach -n kali-arm64 -- apt install -y kali-linux-everything
```

Storage guide from Kali:
- `kali-linux-default`: about 13G
- `kali-linux-large`: about 19G to 21G
- `kali-linux-everything`: about 34G to 36G

## 13. Add a normal user inside Kali

Run:

```bash
lxc-attach -n kali-arm64 --clear-env -- adduser kali
lxc-attach -n kali-arm64 -- usermod -aG sudo kali
lxc-attach -n kali-arm64 -- sh -c "echo 'Set disable_coredump false' > /etc/sudo.conf"
lxc-attach -n kali-arm64 -- sh -c "echo 'TERM=xterm-256color' | cat - /home/kali/.bashrc > /tmp/.bashrc && mv /tmp/.bashrc /home/kali/.bashrc && chown kali:kali /home/kali/.bashrc"
```

## 14. Enter Kali

Run:

```bash
lxc-console -n kali-arm64
```

Log in as:
- user: `kali`
- password: whatever you set in the previous step

## 15. Verify Kali is healthy

Inside the Kali container:

```bash
cat /etc/os-release
uname -m
apt policy | head
which nmap
which msfconsole
which aircrack-ng
```

You want:
- Kali release information in `/etc/os-release`
- `aarch64` or `arm64` architecture
- tools present in the path

## 16. Daily commands

From the host:

```bash
lxc-start -n kali-arm64 -d
lxc-console -n kali-arm64
lxc-stop -n kali-arm64
lxc-ls -f
```

## 17. Optional category installs

Inside the container, if you want only selected tool groups:

```bash
sudo apt install -y kali-tools-wireless
sudo apt install -y kali-tools-bluetooth
sudo apt install -y kali-tools-hardware
sudo apt install -y kali-tools-sdr
sudo apt install -y kali-tools-web
sudo apt install -y kali-tools-post-exploitation
```

## 18. Important cyberdeck notes

1. Do not add the Kali repository to the Armbian host.
2. Keep the host for board support, networking, storage, and display.
3. Keep Kali inside the container for the offensive/security toolchain.
4. For serious Wi-Fi work, use a known-good external USB adapter rather than assuming the onboard radio supports monitor mode and injection.
5. Snapshot or back up the container before large tool installs.

## References

- Armbian Orange Pi 5B board page: https://armbian.com/boards/orangepi5b
- Armbian getting started: https://docs.armbian.com/User-Guide_Getting-Started/
- Kali containers overview: https://www.kali.org/docs/containers/
- Kali LXC/LXD images: https://www.kali.org/docs/containers/kalilinux-lxc-images/
- Kali metapackages: https://www.kali.org/docs/general-use/metapackages/
- Kali installation sizes: https://www.kali.org/docs/installation/installation-sizes/
- Debian repository-mixing warning: https://wiki.debian.org/DontBreakDebian
