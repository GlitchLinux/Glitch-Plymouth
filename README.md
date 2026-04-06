# Glitch Linux Plymouth Boot Animations

Custom Plymouth boot themes for [gLiTcH Linux](https://glitchlinux.com) - a KDE-based Debian Trixie derivative.

Three cinematic boot animations featuring the gLiTcH mascot emerging from darkness with CRT scanlines, RGB-split, and glitch effects.

---

## Themes

### 1. Emergence
Elegant, minimalist. The Elegant mascot slowly materializes out of pure darkness with subtle CRT scan lines.
**81 frames** — ~4 seconds

![Emergence](preview-emergence.gif)

### 2. Awakening  
Chaotic energy. Micro-flickers in the dark, then RGB-split and horizontal tears as the mascot fights its way into existence.

**80 frames** — ~4 seconds

![Awakening](preview-awakening.gif)

### 3. Convergence *(recommended)*
The full cinematic experience in four acts:
- **Act 1 — Emergence:** Pure darkness, a face barely perceptible
- **Act 2 — Escalation:** Growing scanlines, RGB-split creeps in, glitches build
- **Act 3 — Climax:** Full intensity, dramatic horizontal tears, flickers
- **Act 4 — Blackout:** Power cut. Ghost scanlines linger and fade into silence

**320 frames** — ~16 seconds

![Convergence](preview-convergence.gif)

---

## Installation

### Quick install

```bash
git clone https://github.com/GlitchLinux/Glitch-Plymouth.git
cd Glitch-Plymouth
sudo ./install.sh
```

The installer will:
1. Check and install dependencies (`plymouth`, `plymouth-themes`)
2. Verify kernel parameters (`splash` in GRUB, no `nomodeset`)
3. Prompt you to choose a theme
4. Copy frames, set as default, and rebuild initramfs
  
### Manual install

```bash
sudo mkdir -p /usr/share/plymouth/themes/glitch-convergence
sudo cp theme3-glitch-convergence/* /usr/share/plymouth/themes/glitch-convergence/
sudo plymouth-set-default-theme -R glitch-convergence
sudo update-initramfs -u
```

### Test without reboot

```bash
sudo plymouthd ; sudo plymouth show-splash ; sleep 8 ; sudo plymouth quit
```

---

## Requirements

- Debian 12+ / Ubuntu 22.04+ (or any distro with Plymouth)
- `plymouth` and `plymouth-themes` packages
- `splash` in kernel boot parameters
- KMS enabled (no `nomodeset`)

---

## License

MIT

