README for Security Testing Scripts Repository

Welcome to the Security Testing Scripts repository. This collection of scripts can help you test various aspects of network and host security, from privilege escalation and reverse shells to SYN floods and simulated traffic. Below you will find a brief description and usage instructions for each script.

1. nc_linux.sh (to be used with EDR endpoints)

Purpose:
Automates a Linux privilege escalation via sudo and opens a reverse shell back to a listener.

Prerequisites:

Bash shell on Linux

nc (netcat) installed

User with sudo privileges

Configuration:
Edit the top of the script to set:

LISTENER_IP="<your_listener_ip>"
LISTENER_PORT=<your_listener_port>

Usage:

chmod +x nc_linux.sh
./nc_linux.sh

2. nc_ps.ps1 (to be used with EDR endpoints))

Purpose:
PowerShell script that checks for administrative privileges, elevates with UAC if needed, then opens a reverse TCP shell to a specified listener.

Prerequisites:

Windows PowerShell (v5+)

Execution policy allowing script execution (e.g., Set-ExecutionPolicy Bypass)

Listener (e.g., nc -lvnp <port>)

Configuration:
At the top of the script, set:

$IP   = "<your_listener_ip>"
$Port = <your_listener_port>

Usage:

# Open PS as normal user; script will request elevation if required
.
.\nc_ps.ps1

3. synflood.sh (DOS attack on target Firewall device)

Purpose:
Sends ~2,000 TCP SYN packets over ~5 seconds to a target to test firewall/IDS response.

Prerequisites:

Must run as root

hping3 installed

Usage:

chmod +x synflood.sh
sudo ./synflood.sh
# Follow prompts to enter target IP and port

4. Explotation.sh (Connection to IOC categorized as Explotation)

Purpose:
Basic script to curl a list of IP addresses (e.g., testing connectivity or web server response).

Prerequisites:

Bash shell

curl installed

Configuration:
Edit the IPS array in the script to include your targets.

Usage:

chmod +x Explotation.sh
./Explotation.sh

5. simulated_traffic.sh (To Test Protection Profiles)

Purpose:
Generates simulated network traffic for testing: web browsing, IM connections, and file downloads.

Prerequisites:

Ubuntu 24.04 (tested)

curl, wget, openssl, git (script installs missing packages automatically)

Internet connectivity

Usage:

chmod +x simulated_traffic.sh
sudo ./simulated_traffic.sh

6. CnC.sh (Connection to IOC categorized as CnC)

Purpose:
Lightweight script to periodically check connectivity to a command-and-control (C2) server by sending HTTP requests.

Prerequisites:

Bash shell

curl installed

Configuration:
Update the IPS array with your C2 server IPs.

Usage:

chmod +x CnC.sh
./CnC.sh

7. virus.sh (Connection to download EICAR test files using encrypted traffic)

Purpose:
Downloads the EICAR test files (standard and zipped variants) to test antivirus detection and recursive scanning.

Prerequisites:

Bash shell

wget installed

Usage:

chmod +x virus.sh
./virus.sh

Disclaimer:
These scripts are provided for authorized security testing and educational purposes only. Use them responsibly and only on systems you own or have explicit permission to test.