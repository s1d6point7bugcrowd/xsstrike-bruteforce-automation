#!/bin/bash

# Step 1: Gather URLs that are potential XSS candidates
gau <domain> | gf xss | sort -u | tee Possible_xss.txt

# Step 2: Read each URL and test it with XSStrike
while IFS= read -r url; do
    echo "Testing URL: $url"
    python3 /home/kali/XSStrike/xsstrike.py -u "$url" --delay 1 -f /home/kali/encoded_payloads.txt
done < /home/kali/Possible_xss.txt
