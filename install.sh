#!/bin/bash
# ═══════════════════════════════════════════════
#  gLiTcH Linux Plymouth Theme Installer
#  https://github.com/GlitchLinux/Glitch-Plymouth
# ═══════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
    echo ""
    echo -e "${GREEN}  ██████╗ ██╗     ██╗████████╗ ██████╗██╗  ██╗${NC}"
    echo -e "${GREEN}  ██╔════╝ ██║     ██║╚══██╔══╝██╔════╝██║  ██║${NC}"
    echo -e "${GREEN}  ██║  ███╗██║     ██║   ██║   ██║     ███████║${NC}"
    echo -e "${GREEN}  ██║   ██║██║     ██║   ██║   ██║     ██╔══██║${NC}"
    echo -e "${GREEN}  ╚██████╔╝███████╗██║   ██║   ╚██████╗██║  ██║${NC}"
    echo -e "${GREEN}   ╚═════╝ ╚══════╝╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝${NC}"
    echo -e "${CYAN}        Plymouth Boot Animation Installer${NC}"
    echo ""
}

# ── Root check ──
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Kör som root: sudo $0${NC}"
    exit 1
fi

banner

# ── Dependency check & install ──
echo -e "${BOLD}[1/4] Kontrollerar beroenden...${NC}"

DEPS_MISSING=0
DEPS_LIST=""

check_dep() {
    if ! dpkg -l "$1" &>/dev/null; then
        DEPS_MISSING=1
        DEPS_LIST="$DEPS_LIST $1"
        echo -e "  ${RED}✗${NC} $1"
    else
        echo -e "  ${GREEN}✓${NC} $1"
    fi
}

check_dep "plymouth"
check_dep "plymouth-themes"

# plymouth-drm is recommended but might have different names
if ! dpkg -l plymouth-drm &>/dev/null 2>&1; then
    if dpkg -l plymouth-theme-spinner &>/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} plymouth-drm (via plymouth-theme-spinner)"
    else
        echo -e "  ${YELLOW}?${NC} plymouth-drm (rekommenderas men ej kritiskt)"
    fi
else
    echo -e "  ${GREEN}✓${NC} plymouth-drm"
fi

if [ "$DEPS_MISSING" -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}Saknade paket:${DEPS_LIST}${NC}"
    read -p "Vill du installera dem nu? [J/n] " install_deps
    install_deps=${install_deps:-J}
    if [[ "$install_deps" =~ ^[JjYy]$ ]]; then
        apt update -qq
        apt install -y $DEPS_LIST
        echo -e "${GREEN}Beroenden installerade!${NC}"
    else
        echo -e "${RED}Avbryter — plymouth krävs.${NC}"
        exit 1
    fi
fi

# ── Check kernel params ──
echo ""
echo -e "${BOLD}[2/4] Kontrollerar kernel-parametrar...${NC}"

GRUB_OK=1
if [ -f /etc/default/grub ]; then
    CMDLINE=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
    if echo "$CMDLINE" | grep -q "splash"; then
        echo -e "  ${GREEN}✓${NC} 'splash' finns i GRUB_CMDLINE_LINUX_DEFAULT"
    else
        echo -e "  ${YELLOW}!${NC} 'splash' saknas i GRUB_CMDLINE_LINUX_DEFAULT"
        GRUB_OK=0
    fi
    if echo "$CMDLINE" | grep -q "nomodeset"; then
        echo -e "  ${RED}✗${NC} 'nomodeset' detekterad — Plymouth kräver KMS"
        echo -e "    Ta bort 'nomodeset' från /etc/default/grub"
    else
        echo -e "  ${GREEN}✓${NC} Ingen 'nomodeset' (KMS aktiv)"
    fi
else
    echo -e "  ${YELLOW}?${NC} /etc/default/grub hittades inte (systemd-boot?)"
fi

if [ "$GRUB_OK" -eq 0 ]; then
    read -p "Vill du lägga till 'quiet splash' automatiskt? [J/n] " fix_grub
    fix_grub=${fix_grub:-J}
    if [[ "$fix_grub" =~ ^[JjYy]$ ]]; then
        sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 quiet splash"/' /etc/default/grub
        # Remove duplicate quiet/splash
        sed -i 's/quiet quiet/quiet/g; s/splash splash/splash/g' /etc/default/grub
        update-grub
        echo -e "${GREEN}GRUB uppdaterad med 'quiet splash'${NC}"
    fi
fi

# ── Theme selection ──
echo ""
echo -e "${BOLD}[3/4] Välj Plymouth-tema:${NC}"
echo ""
echo -e "  ${CYAN}1)${NC} ${BOLD}Emergence${NC}"
echo -e "     Elegant fade-in från mörker med subtila scanlines"
echo -e "     81 frames — minimalistiskt och stilrent"
echo ""
echo -e "  ${CYAN}2)${NC} ${BOLD}Awakening${NC}"
echo -e "     Glitch-effekter med RGB-split och horisontella tears"
echo -e "     80 frames — kaotiskt och energiskt"
echo ""
echo -e "  ${CYAN}3)${NC} ${BOLD}Convergence${NC} ${GREEN}(rekommenderad)${NC}"
echo -e "     Cinematisk 4-akt animation: emergence → escalation → climax → blackout"
echo -e "     320 frames — den kompletta gLiTcH-upplevelsen"
echo ""

while true; do
    read -p "Välj tema [1/2/3]: " choice
    case "$choice" in
        1)
            THEME_NAME="glitch-emergence"
            THEME_DIR="theme1-glitch-emergence"
            THEME_DISPLAY="gLiTcH Emergence"
            break ;;
        2)
            THEME_NAME="glitch-awakening"
            THEME_DIR="theme2-glitch-awakening"
            THEME_DISPLAY="gLiTcH Awakening"
            break ;;
        3)
            THEME_NAME="glitch-convergence"
            THEME_DIR="theme3-glitch-convergence"
            THEME_DISPLAY="gLiTcH Convergence"
            break ;;
        *)
            echo -e "${RED}Ogiltigt val — ange 1, 2 eller 3${NC}" ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${SCRIPT_DIR}/${THEME_DIR}"
DEST="/usr/share/plymouth/themes/${THEME_NAME}"

if [ ! -d "$SRC" ]; then
    echo -e "${RED}Tema-katalog saknas: ${SRC}${NC}"
    echo -e "Se till att alla tema-kataloger finns i samma mapp som detta script."
    exit 1
fi

# ── Install theme ──
echo ""
echo -e "${BOLD}[4/4] Installerar ${THEME_DISPLAY}...${NC}"

CURRENT_THEME=$(plymouth-set-default-theme 2>/dev/null || echo "inget")
echo -e "  Nuvarande tema: ${CURRENT_THEME}"

echo -e "  Kopierar filer till ${DEST}..."
mkdir -p "$DEST"
cp "${SRC}/"*.png "$DEST/"
cp "${SRC}/${THEME_NAME}.plymouth" "$DEST/"
cp "${SRC}/${THEME_NAME}.script" "$DEST/"

echo -e "  Sätter ${THEME_NAME} som standard..."
plymouth-set-default-theme "${THEME_NAME}"

echo -e "  Uppdaterar initramfs (kan ta en stund)..."
update-initramfs -u 2>&1 | tail -2

echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ ${THEME_DISPLAY} installerat!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo -e "Starta om för att se animationen vid boot."
echo ""
echo -e "${CYAN}Testa utan omstart:${NC}"
echo -e "  sudo plymouthd ; sudo plymouth show-splash ; sleep 8 ; sudo plymouth quit"
echo ""
