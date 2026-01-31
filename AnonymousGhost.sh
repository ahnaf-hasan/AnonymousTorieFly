#!/bin/bash

# ==================================================
# ANONYMOUSTORIEFLY GHOST v26 - Version26 PRO VERSION
# Author: Ahnaf Tahmid Hasan
# Description: AnonymousTorieFly Tor Ghost with auto IP rotation.Its easy to use.Its totally free and safe.
# SAFE VERSION
# ==================================================

clear

# ================= Banner =================
echo -e "\e[1;35m"
cat << "EOF"

 █████╗ ███╗   ██╗ ██████╗ ███╗   ██╗██╗   ██╗███╗   ███╗ ██████╗ ██╗   ██╗███████╗
██╔══██╗████╗  ██║██╔═══██╗████╗  ██║╚██╗ ██╔╝████╗ ████║██╔═══██╗██║   ██║██╔════╝
███████║██╔██╗ ██║██║   ██║██╔██╗ ██║ ╚████╔╝ ██╔████╔██║██║   ██║██║   ██║███████╗
██╔══██║██║╚██╗██║██║   ██║██║╚██╗██║  ╚██╔╝  ██║╚██╔╝██║██║   ██║██║   ██║╚════██║
██║  ██║██║ ╚████║╚██████╔╝██║ ╚████║   ██║   ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝

                    G H O S T. AnonoymousTorieFly
              Privacy • Anonymity • Research

                    Version : 26 PRO
                    Author  : Ahnaf Tahmid Hasan

══════════════════════════════════════════════════════════════════════════════════

EOF
echo -e "\e[0m"

# ================= 1) Update & Install =================
echo "[+] Updating system..."
sudo apt update

echo "[+] Installing Tor & dependencies..."
sudo apt install -y tor python3-stem python3-requests python3-socks python3-colorama

# ================= 2) Configure Tor Control Port =================
TORRC="/etc/tor/torrc"
TOR_PASS="ghostpro"

echo "[+] Configuring Tor control port..."
HASHED_PASS=$(tor --hash-password "$TOR_PASS" | tail -n 1)

sudo sed -i '/ControlPort/d;/CookieAuthentication/d;/HashedControlPassword/d;/ExitNodes/d;/StrictNodes/d' $TORRC

echo "ControlPort 9051" | sudo tee -a $TORRC
echo "CookieAuthentication 0" | sudo tee -a $TORRC
echo "HashedControlPassword $HASHED_PASS" | sudo tee -a $TORRC

echo "[+] Restarting Tor..."
sudo systemctl restart tor
sleep 5

# ================= 3) Create Python Pro Script =================
cat << 'EOF' > anonymous_ghost_pro.py
#!/usr/bin/env python3

import time, random, logging, requests
from stem import Signal
from stem.control import Controller
from colorama import Fore, init

init(autoreset=True)

TOR_PROXY = "socks5h://127.0.0.1:9050"
CONTROL_PORT = 9051
CONTROL_PASS = "ghostpro"

CHECK_URL = "https://check.torproject.org/api/ip"
ROTATE_INTERVAL = 60
TOR_BUILD_TIME = 8

COUNTRIES = {
    # ===== Europe (Most Stable Tor Exit Nodes) =====
    "de":"Germany",
    "nl":"Netherlands",
    "fr":"France",
    "se":"Sweden",
    "no":"Norway",
    "fi":"Finland",
    "dk":"Denmark",
    "ch":"Switzerland",
    "at":"Austria",
    "it":"Italy",
    "es":"Spain",
    "pt":"Portugal",
    "ie":"Ireland",
    "be":"Belgium",
    "pl":"Poland",
    "cz":"Czech Republic",
    "ro":"Romania",
    "bg":"Bulgaria",
    "lt":"Lithuania",
    "lv":"Latvia",
    "ee":"Estonia",
    "is":"Iceland",
    "gr":"Greece",

    # ===== North America =====
    "us":"United States",
    "ca":"Canada",

    # ===== Asia (Common) =====
    "jp":"Japan",
    "sg":"Singapore",
    "hk":"Hong Kong",
    "tw":"Taiwan",

    # ===== South America =====
    "br":"Brazil",

    # ===== Oceania =====
    "au":"Australia",
    "nz":"New Zealand",

    # ===== Africa =====
    "za":"South Africa"
}


proxies = {"http": TOR_PROXY, "https": TOR_PROXY}

logging.basicConfig(
    filename="anonymous_ghost_logs.txt",
    level=logging.INFO,
    format="%(asctime)s | %(message)s"
)

def banner():
    print(Fore.CYAN + "="*50)
    print(Fore.MAGENTA + "        ANONYMOUS GHOST v26 PRO")
    print(Fore.CYAN + "  Auto IP + Random Country Rotation Enabled")
    print(Fore.YELLOW + "  Author : Anonymous")
    print(Fore.CYAN + "="*50 + "\n")

class AnonymousGhostPro:
    def __init__(self):
        self.session = requests.Session()
        self.session.proxies = proxies

    def check_ip(self):
        try:
            r = self.session.get(CHECK_URL, timeout=20)
            d = r.json()
            return d.get("IP"), d.get("IsTor")
        except:
            return "N/A", False

    def rotate_ip_country(self, code):
        with Controller.from_port(port=CONTROL_PORT) as c:
            c.authenticate(password=CONTROL_PASS)
            c.set_conf("ExitNodes", f"{{{code}}}")
            c.set_conf("StrictNodes", "1")
            c.signal(Signal.NEWNYM)

    def run(self):
        while True:
            try:
                code, country = random.choice(list(COUNTRIES.items()))
                self.rotate_ip_country(code)
                time.sleep(TOR_BUILD_TIME)

                ip, tor = self.check_ip()
                status = Fore.GREEN+"YES" if tor else Fore.RED+"NO"
                print(Fore.YELLOW + f"[IP] {ip} | [Tor] {status} | [Country] {country}")
                logging.info(f"{ip} | {country}")

                time.sleep(ROTATE_INTERVAL)

            except KeyboardInterrupt:
                print(Fore.RED + "\n[!] Stopped by user")
                break

if __name__ == "__main__":
    banner()
    AnonymousGhostPro().run()
EOF

chmod +x anonymous_ghost_pro.py

# ================= 4) Run =================
echo "[+] Running Anonymous Ghost PRO..."
python3 anonymous_ghost_pro.py
