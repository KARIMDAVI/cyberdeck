# CYBERDECK Blueprint - Single Source of Truth
Last updated: 2026-04-15
Owner: K!MO
Project: Portable cyberdeck v1 (Orange Pi 5B + Waveshare 5in + BBQ20 keyboard)

---

## 1) Mission
Build a portable, safe, learnable cyberdeck that:
- Boots reliably.
- Is secure by default.
- Works with SSH first, then keyboard/screen integration.
- Keeps wiring understandable and maintainable for years.

This document is the master blueprint. If another note conflicts with this file, this file wins.

---

## 2) Current Verified Status (Truth Snapshot)

| Area | State | Verified Notes |
|---|---|---|
| Orange Pi 5B hardware | DONE | Board powers and boots |
| OS | DONE | Armbian (Ubuntu 24.04 Noble), kernel `6.1.115-vendor-rk35xx` |
| User setup | DONE | `kimo` user created |
| System updates | DONE | `apt update && apt upgrade` completed |
| SSH access | DONE | Working via key-based login |
| SSH hardening | DONE | Password login disabled, root SSH login disabled |
| Firewall | DONE | UFW enabled with OpenSSH allowed |
| Ethernet | DONE | Works, IP seen as `192.168.1.199` during setup |
| Wi-Fi | DONE | Connected to `Ruby's Kingdom`, IP seen as `192.168.1.200` |
| Screen | PARTIAL | Hardware arrived, not fully validated end-to-end with touch in final build flow |
| BBQ20 keyboard PCB | PENDING ARRIVAL | JLCPCB order ETA around Apr 16 |
| Case design | IN PROGRESS | Needs final routing lock and post-arrival fit check |
| Qualia S3 | DEFERRED | Not needed for v1 |

---

## 3) Why Wi-Fi Looked "Broken" Before
Wi-Fi was not actually broken at the end.

What happened:
- NetworkManager policy prompts blocked/timeout happened in one flow.
- Hostname discovery (`orangepi5b.local` style) was inconsistent.
- LAN unplug made SSH fail because the session target changed and hostname did not resolve.

What proved Wi-Fi works:
- `nmcli` showed `wlan0 connected` to `Ruby's Kingdom`.
- `ip -br a` showed Wi-Fi IP.
- `ping 1.1.1.1` and `ping google.com` succeeded.

Rule going forward:
- Use direct IP for SSH when needed: `ssh kimo@192.168.1.200`
- Do not depend only on hostname resolution.

---

## 4) Security Baseline (Already Applied)

Completed hardening:
1. Created normal user `kimo`.
2. Added SSH key login.
3. Disabled password SSH login.
4. Disabled root SSH login.
5. Enabled UFW firewall with OpenSSH allowed.
6. Updated package base.

Expected secure SSH config behavior:
- Key-based access works.
- Password-only SSH attempts fail.
- Root SSH login is denied.

---

## 5) Hardware Inventory and Decisions

### Confirmed hardware
- Orange Pi 5B (8GB RAM, 64GB eMMC)
- Waveshare 5in HDMI display (native portrait 720x1280)
- OLED modules (0.96in, I2C)
- Power bank (external)
- Screws/standoffs and wiring parts partly in hand

### Pending hardware
- BBQ20 keyboard PCBs (order in progress)
- A few final internal cables and cooling items as needed

### Deferred
- Qualia S3 is saved for v2 experiments only.

---

## 6) Cable and Port Routing (Clear Version)

The biggest confusion was "internal vs external ports".

Important truth:
- Orange Pi has only external physical connectors.
- "Internal" means you plug short cables into those connectors *inside the case* before closing it.

### v1 planned internal cable map
1. OPi HDMI OUT -> Waveshare HDMI IN (flat ribbon HDMI, ~15cm)
2. Waveshare USB-C -> OPi USB3.0 Type-C (power + touch over one cable, ~10cm)
3. OPi USB2.0 Type-A -> BBQ20 keyboard USB-C (internal keyboard link, ~10cm)
4. GPIO -> OLED wires (Dupont)

### v1 planned external-access map
- Keep USB3.0 Type-A exposed for tools.
- Keep Ethernet exposed.
- Keep USB-C power input exposed.
- Keep microSD access exposed.

Port availability lock (v1):
- USB3.0 Type-A: exposed (free)
- USB2.0 Type-A: reserved internally for BBQ20 keyboard
- USB3.0 Type-C: reserved internally for screen power + touch
- HDMI OUT: reserved internally for screen video
- Ethernet: exposed (free)
- Audio 3.5mm: exposed (free)
- MicroSD: exposed (free)

Final cutout placement will be frozen after keyboard PCB arrives and dry-fit is complete.

---

## 7) OS Choice: Ubuntu Base vs Kali
Short answer: current OS choice is correct.

Why this is good for your use case:
- Ubuntu/Armbian base is more stable on this board.
- Better driver behavior for day-to-day bring-up.
- You can install the exact security tools you need on top.

You are not losing capability by avoiding pure Kali image first.
You are gaining stability for hardware integration.

---

## 8) Case Geometry Baseline (Latest Known)
Reference source for dimensions: `MEASUREMENTS.md`

Current key values to use:
- Outer case: 138mm (W) x 195mm (H) x 65mm (D)
- Display window (portrait): 69mm x 128mm
- Keyboard window: 69mm x 44mm
- OPi mount strategy: right-side port alignment focused

Execution geometry lock (must match fabrication):
- OPi X position: flush right (left edge X=71mm, right edge X=133mm in 133mm cavity)
- OPi Z offset: 47.5mm from case bottom
- Left wall ports: Power button Z~112mm, MIC Z~58mm
- Right wall ports: USB3 Z~123mm, USB2 Z~113mm, Ethernet Z~93mm

Do not use old 86x175x47 values. Those are obsolete.

---

## 9) Step-by-Step Plan (Kid Mode + Adult Mode)

### Kid Mode (very simple)
1. Board turns on.
2. We can talk to it over SSH.
3. We made login safe.
4. Next we test screen and touch.
5. Then keyboard arrives.
6. Then we close everything inside the case.

### Adult Mode (technical order)
1. Keep secure SSH as primary control path.
2. Confirm persistent Wi-Fi autoconnect after reboot.
3. Validate display output and touch input with stable user session.
4. Integrate BBQ20 keyboard when PCB arrives.
5. Freeze internal cable routing and external port priorities.
6. Finalize OpenSCAD cutouts from real hardware fit.
7. Print test shell, then final PETG print.

---

## 10) Immediate Next 7 Actions
1. Reboot once and confirm SSH key login still works.
2. Confirm Wi-Fi reconnects automatically after reboot.
3. Save current Wi-Fi IP in router DHCP reservation (recommended).
4. Validate screen signal path using known-good HDMI cable.
5. Validate touch device appears in Linux input devices.
6. Wait for BBQ20 PCB arrival and run keyboard HID test.
7. Lock final routing and update case model once, then print.

---

## 11) Commands You Already Used (Recorded)

System identity and network:
```bash
cat /etc/os-release
uname -r
ip -br a
```

Network checks:
```bash
nmcli dev status
nmcli -f SSID,SECURITY,SIGNAL dev wifi list ifname wlan0
nmcli dev wifi connect "Ruby's Kingdom" password "<your-password>" ifname wlan0
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Security setup highlights:
```bash
# key login setup was completed
# ssh hardening file added and ssh reloaded
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable
```

---

## 12) Troubleshooting Rules
- If SSH fails, test network first (`ip -br a`, `ping`).
- If hostname fails, SSH by IP.
- If Wi-Fi seems unstable, reconnect with `nmcli` and verify `wlan0` state.
- Keep one known-good Ethernet path for rescue.
- Never disable both password auth and key auth at the same time without testing a second session.

---

## 13) Open Questions (To Resolve After PCB Arrival)
1. Final USB port budget: which USB-A remains fully free externally.
2. Final screen touch/power cable route to avoid blocking desired external ports.
3. Final backplate and side cutout exact Z/X coordinates after dry-fit.
4. Whether to expose USB-C data externally in v1 or reserve it internally.

---

## 14) Change Log
- 2026-04-15: Consolidated blueprint into single clean status file.
- 2026-04-15: Recorded successful Armbian bring-up and hardened SSH baseline.
- 2026-04-15: Clarified Wi-Fi issue as discovery/policy flow, not final connectivity failure.
- 2026-04-15: Clarified internal vs external routing language to remove port confusion.


**Updates:
-audit current security state

sudo sshd -T | egrep 'passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication'
sudo ufw status verbose

permitrootlogin no
pubkeyauthentication yes
passwordauthentication no
kbdinteractiveauthentication no
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere                  
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)       

That is the right secure baseline.

What it means:

PermitRootLogin no = root cannot log in over SSH.
PubkeyAuthentication yes = your key is allowed.
PasswordAuthentication no and KbdInteractiveAuthentication no = password login is off.
UFW allows only SSH in, and blocks other incoming traffic by default.
So the board is now secure enough for normal cyberdeck use




fresh SSH test from your Mac
ssh kimo@192.168.1.200

If that logs in with your key, we are done with the safety lock

reboot once and verify the lock still holds.

On the OPi, run:
sudo reboot

ssh kimo@192.168.1.200
