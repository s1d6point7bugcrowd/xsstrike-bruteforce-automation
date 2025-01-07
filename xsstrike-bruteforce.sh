#!/bin/bash

# Usage: ./xss_automation.sh <domain>

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN="$1"
OUTPUT_FILE="Possible_xss.txt"
LOG_FILE="xsstrike_output.log"

echo "[-] Gathering URLs that are potential XSS candidates from: $DOMAIN"

# Step 1: Gather URLs that are potential XSS candidates
gau "$DOMAIN" | gf xss | sort -u | tee "$OUTPUT_FILE"

echo "[+] Potential XSS URLs saved to: $OUTPUT_FILE"

# Step 2: Read each URL and test it with XSStrike
echo "[-] Starting XSStrike tests..."
while IFS= read -r url; do
    echo "[*] Testing URL: $url"
    python3 /home/kali/XSStrike/xsstrike.py -u "$url" --delay 1 -f /home/kali/encoded_payloads.txt \
        | tee -a "$LOG_FILE"
    echo "-----------------------------------------"
done < "$OUTPUT_FILE"

echo "[+] XSStrike scans are complete. All output has been logged to: $LOG_FILE"
