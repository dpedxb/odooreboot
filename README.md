# Odoo Service Restarter

**Note: Don't rely solely on this tool to tackle 502 errors! It can provide temporary relief, but a lasting solution lies in fixing the underlying code issues **

This setup is designed to automatically restart the Odoo service whenever it dies or fails to respond with a 502 HTTP Error. The solution involves using NGINX, FCGI Wrap, and a bash script to achieve this. When a 502 error occurs, the script will collect current details of CPU, memory, and IO usage, then proceed to restart the Odoo and PostgreSQL services. You have the flexibility to choose which details to collect before and after restarting the services. In some cases, you may only need to restart the Odoo service without affecting PostgreSQL. Modify the script according to your specific requirements.

## Usage

This automatic setup monitors the health of your Odoo service and takes action if it encounters issues. Using NGINX, FCGI Wrap, and a customizable bash script, the system detects 502 HTTP errors (indicating Odoo isn't responding) and triggers a proactive response.

Here's what happens:

- Error Detection: NGINX, with the help of FCGI Wrap, identifies a 502 error from Odoo.
- Script Activation: The configured bash script automatically initiates upon recognizing the error.
- System Diagnostics (Optional): You can choose to customize the script to gather pre-restart information like CPU, memory, and I/O usage. This data can provide valuable insights into the cause of the issue.
- Service Restart: The script automatically restarts the Odoo service and potentially PostgreSQL as well (depending on your customization). This prompt action helps minimize downtime and restore functionality.

## Installation.

1. Install NGINX.
   'apt install nginx'

2. Install FCGI Wrap
   'apt install fcgiwrap'

3. Modify your your current NGINX configutation file and add the 502 redirect section from odoo-nginx.conf

4. Copy the bash script odoo_check.sh to "/opt/odoo/scripts"

5. Restart NGINX and FCGI Wrap service and test it by stopping the odoo service manually.

** Remember: When debugging Odoo, manually stop NGINX to avoid automatic restarts triggered by the service **
   





   

