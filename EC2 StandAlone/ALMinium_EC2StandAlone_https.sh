#!/bin/bash
ALM_HOSTNAME=
SMTPSET=
SMTPSERVER=
SMTPTLS=
SMTPPORT=
SMTPLOGIN=
SMTPUser=
SMTPPass=
export HOME=/root
SSL=y
USE_DISABLE_SECURITY=Y
yum -y install git
cd /usr/local/src
git clone https://github.com/alminium/alminium.git
cd alminium
bash ./smelt > /usr/local/src/alminium/ALMinium_Install.log 2>&1
reboot
