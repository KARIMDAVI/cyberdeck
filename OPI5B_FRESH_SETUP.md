# OPi5B Fresh Setup

This is the clean bring-up path for a replacement Orange Pi 5B in this cyberdeck project.

Assumptions:
- Board: Orange Pi 5B
- Goal: recover the previously verified Armbian-based cyberdeck baseline
- Host machine: macOS or Linux with SSH available
- Strategy: boot from microSD first, then move to eMMC only after the board is stable

## 1. Choose the base OS

Use Armbian as the base OS for first bring-up.

Why this path:
- Armbian officially recommends Armbian Imager for selecting and flashing supported boards.
- Armbian recommends an Ubuntu-based image if you do not have a special reason to pick something else.
- For Rockchip boards, Armbian documents a normal SD-card bring-up flow and a separate Maskrom flow for direct recovery flashing.

For this project:
- Start with an Armbian Ubuntu image.
- Prefer `vendor` if you want the best odds for board-specific hardware support.
- Use `current` if `vendor` is not available for the exact image you want.

The `vendor` recommendation here is an inference from Armbian's general kernel guidance plus this repo's previously verified RK35xx vendor-kernel setup.

## 2. Flash microSD

1. Install and open Armbian Imager.
2. Select the Orange Pi 5 family entry that matches your board in the current Armbian catalog.
3. Pick an Ubuntu `minimal` or `server` image.
4. Flash the microSD card and let verification finish.

Do not start with direct eMMC flashing unless you specifically need recovery-mode flashing.

## 3. First boot

Recommended first boot:
- Insert the microSD card
- Connect Ethernet
- Connect a known-good 5V/4A USB-C power supply
- Wait up to a couple of minutes for first boot

Armbian's documented first-login behavior:
- SSH login starts as `root`
- Default password is `1234`
- First login forces a password change
- You are then prompted to create a normal sudo user

From your Mac or Linux host:

```bash
ssh root@<opi-ip>
```

If you do not know the IP yet:

```bash
arp -a
```

Create your normal user during the first-login flow. Use `kimo` if you want to preserve the previous repo notes as-is.

## 4. Update the base system

On the OPi:

```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

Log back in as your normal user after the reboot.

## 5. Install your SSH key before hardening

From your host machine:

```bash
ssh-copy-id kimo@<opi-ip>
```

Confirm key login works in a fresh session before changing SSH policy:

```bash
ssh kimo@<opi-ip>
```

## 6. Run the repo post-install script

This repo now includes a board-side script that handles:
- package updates
- useful baseline packages
- UFW setup
- I2C enablement for later OLED work
- SSH hardening, but only if your user already has `~/.ssh/authorized_keys`

Copy it to the OPi:

```bash
scp scripts/opi5b_postinstall.sh kimo@<opi-ip>:~/
```

Run it on the OPi:

```bash
chmod +x ~/opi5b_postinstall.sh
sudo ~/opi5b_postinstall.sh
```

## 7. Connect Wi-Fi

If you want Wi-Fi after the wired bring-up:

```bash
nmcli dev status
nmcli dev wifi list ifname wlan0
nmcli dev wifi connect "YOUR_SSID" password "YOUR_PASSWORD" ifname wlan0
nmcli con modify "YOUR_SSID" connection.autoconnect yes
```

If `nmcli` is unavailable on the image you chose, install NetworkManager first:

```bash
sudo apt install -y network-manager
```

Then retry the commands above.

## 8. Verify the security baseline

On the OPi:

```bash
sudo sshd -T | egrep 'passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication'
sudo ufw status verbose
```

Expected state:
- `permitrootlogin no`
- `pubkeyauthentication yes`
- `passwordauthentication no`
- `kbdinteractiveauthentication no`
- UFW active with OpenSSH allowed

## 9. Move the system to eMMC only after the board is stable

Armbian documents `armbian-install` as the normal path for moving a working system from SD to internal storage.

Run this only after:
- the board boots cleanly
- networking works
- SSH key login works
- you have one known-good reboot

Command:

```bash
sudo armbian-install
```

Pick the option that installs the system to eMMC when prompted.

Use Rockchip Maskrom plus `rkdeveloptool` only if you need low-level recovery or direct flashing. That is a separate path.

## 10. Cyberdeck-specific hardware checks

Once the OS baseline is stable:

Display:

```bash
xrandr --query
```

Touch/input tools:

```bash
sudo libinput debug-events
sudo evtest
```

I2C scan for later OLED work:

```bash
i2cdetect -l
i2cdetect -y 1
i2cdetect -y 4
```

Keyboard detection:

```bash
grep -A 5 -B 2 -i bbq20 /proc/bus/input/devices
```

## 11. Recommended bring-up order

1. Boot Armbian from microSD.
2. Create the normal user.
3. Update and reboot.
4. Install SSH key.
5. Run `scripts/opi5b_postinstall.sh`.
6. Verify SSH hardening and UFW.
7. Connect Wi-Fi and confirm autoconnect.
8. Reboot once more.
9. Only then move to eMMC with `armbian-install`.
10. After that, test screen, touch, keyboard, and OLED buses.
