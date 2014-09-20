#!/bin/bash
ALM_HOSTNAME=
SMTPSET=
SMTPSERVER=
SMTPTLS=
SMTPPORT=
SMTPLOGIN=
SMTPUser=
SMTPPass=
ENABLE_JENKINS=y
export USER=root
export HOME=/root
SSL=y
USE_DISABLE_SECURITY=N
yum -y install ruby19 ruby19-devel rubygems19 rubygems19-devel
alternatives --set ruby /usr/bin/ruby1.9
yum -y install git
cd /usr/local/src
git clone https://github.com/alminium/alminium.git
cd alminium
source ./smelt > /usr/local/src/alminium/ALMinium_Install.log 2>&1
reboot
