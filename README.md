# Domm Finder

![Domm Finder](https://img.shields.io/badge/Domm%20Finder-Subdomain%20Scanner-blue)

---

## 🔎 Overview

**Domm Finder** is a Bash-based tool that finds **live subdomains** for a given domain and fetches their **IP addresses**. It uses certificate transparency logs from [crt.sh](https://crt.sh/) to gather subdomains, then checks their availability over HTTP and HTTPS.

---

## ⚙️ Features

- Enumerates subdomains from `crt.sh`
- Checks if subdomains are live via HTTP/HTTPS
- Resolves and displays the IP address of live subdomains
- Saves live subdomains and IPs to `live_subdomains.txt`
- Interactive and color-coded terminal output

---

## 🛠 Requirements

- `bash` (default on Linux/macOS)
- [`curl`](https://curl.se/)  
- [`jq`](https://stedolan.github.io/jq/)  
- [`dig`](https://linux.die.net/man/1/dig) (part of `dnsutils` package)

### Install dependencies on Debian/Ubuntu

```bash
sudo apt update
sudo apt install -y curl jq dnsutils

🚀 Installation & Usage

    Clone or download the script:

git clone https://github.com/yourusername/domm-finder.git
cd domm-finder

    Make the script executable:

chmod +x domm_finder.sh

    Run the tool:

./domm_finder.sh

    Follow the prompts:

        Enter the target domain (e.g., example.com)

        Confirm to proceed (y to start scanning)

        Wait while the tool enumerates and tests subdomains

📂 Output

The results will be saved in live_subdomains.txt with format:

subdomain.example.com - 93.184.216.34

⚠️ Notes

    The tool checks HTTP (port 80) first, then HTTPS (port 443).

    Only the first IPv4 address per subdomain is shown.

    Some live services might not respond on HTTP/HTTPS ports.

    Ensure you have internet connectivity for API calls and DNS resolution.

    The script requires jq, curl, and dig to work.

✨ Future Improvements

    Add multi-threaded scanning for faster execution

    Support for IPv6 addresses

    Export results to JSON or CSV

    Integrate more subdomain sources like VirusTotal or SecurityTrails

🧑‍💻 Author

Created by Your Name for ethical hacking learning and pentesting practice.
📜 License

This project is licensed under the MIT License - see the LICENSE
file for details.
