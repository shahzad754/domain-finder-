#!/bin/bash

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
NC="\e[0m" # No Color

# Clear screen and show banner
clear
echo -e "${CYAN}"
echo "#################################################"
echo "#             🔎 Domm Finder Tool               #"
echo "#   (Live Subdomain + IP Address Scanner)       #"
echo "#################################################"
echo -e "${NC}"

# Ask for domain input
read -p "Enter a domain (e.g., example.com): " DOMAIN

# Validate input
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}[!] No domain entered. Exiting.${NC}"
    exit 1
fi

# Confirm to continue
read -p "Do you want to continue scanning subdomains for $DOMAIN? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo -e "${YELLOW}[!] Operation cancelled. See you next time!${NC}"
    exit 0
fi

# Output file
OUTPUT="live_subdomains.txt"
> "$OUTPUT"  # Clear file before use

echo -e "${GREEN}[*] Domm Finder is now searching for subdomains of: $DOMAIN${NC}"
echo ""

# Check for required tools
for cmd in jq dig curl; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}[!] '$cmd' is required but not installed. Please install it.${NC}"
        exit 1
    fi
done

# Fetch subdomains using crt.sh
SUBDOMAINS=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | \
    jq -r '.[].name_value' | \
    sed 's/\*\.//g' | \
    sort -u)

if [ -z "$SUBDOMAINS" ]; then
    echo -e "${RED}[-] No subdomains found for $DOMAIN.${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Checking which subdomains are live and resolving their IP addresses...${NC}"
echo ""

# Function to check if a subdomain is live (HTTP or HTTPS)
is_live() {
    local url=$1
    # Try HTTP
    curl -s --head --max-time 5 "http://$url" | head -n 1 | grep "HTTP/" > /dev/null
    if [ $? -eq 0 ]; then
        return 0
    fi
    # Try HTTPS
    curl -s --head --max-time 5 --insecure "https://$url" | head -n 1 | grep "HTTP/" > /dev/null
    return $?
}

# Loop through subdomains and check live status + IP
for SUB in $SUBDOMAINS; do
    if is_live "$SUB"; then
        # Get IP address
        IP=$(dig +short "$SUB" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1)

        if [ -z "$IP" ]; then
            IP="(IP not found)"
        fi

        echo -e "${GREEN}[+] Live: $SUB - IP: $IP${NC}"
        echo "$SUB - $IP" >> "$OUTPUT"
    else
        echo -e "${RED}[-] Not live: $SUB${NC}"
    fi
done

echo ""
echo -e "${CYAN}[*] Domm Finder completed. Live subdomains with IPs saved to: ${OUTPUT}${NC}"
echo -e "${CYAN}[!] Thank you for using Domm Finder 🕵️‍♂️${NC}"
