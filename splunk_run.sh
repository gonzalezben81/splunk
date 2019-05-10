#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

clear 

. ./setuprc

echo;
echo "####################################################################################################	

This script is installing and configuring Splunk for ingestion of the OpenStack logs.  Splunk can 
be used to debug and monitor your OpenStack configuration. Access it from the following URL:

http://$SG_SERVICE_CONTROLLER_IP:8000/

####################################################################################################	
"
echo;

# download
wget -O splunklight-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.2.6&product=splunk_light&filename=splunklight-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz&wget=true'

# extract, move, cleanup
tar xvfz splunklight-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz
mv splunk /opt/splunk
rm splunklight-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz

# whack on inputs.conf file
echo "
[monitor:///var/log/keystone]
disabled = false
followTail = 0

[monitor:///var/log/nova]
disabled = false
followTail = 0

[monitor:///var/log/glance]
disabled = false
followTail = 0

[monitor:///var/log/cinder]
disabled = false
followTail = 0

[monitor:///var/log/rabbit]
disabled = false
followTail = 0

[monitor:///var/log/mongodb]
disabled = false
followTail = 0

[monitor:///var/log/ceilometer]
disabled = false
followTail = 0

[monitor:///var/log/libvirt]
disabled = false
followTail = 0
" >> /opt/splunk/etc/apps/launcher/default/inputs.conf

# Auto start Splunk on boot
 /opt/splunk/bin/splunk enable boot-start --accept-license
 
# start splunk
/opt/splunk/bin/splunk start --accept-license

echo;
echo "##########################################################################################"
echo;
echo "Splunk setup complete.  Continue the setup by doing a './openstack_mysql.sh'."
echo;
echo "##########################################################################################"
echo;
