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
gem install rubygems-update
update_rubygems
yum -y install http://mirror.centos.org/centos/6/os/x86_64/Packages/libical-0.43-6.el6.x86_64.rpm
yum -y install http://mirror.centos.org/centos/6/os/x86_64/Packages/ipa-pgothic-fonts-003.02-4.1.el6.noarch.rpm
yum -y install git
cd /usr/local/src
git clone https://github.com/alminium/alminium.git
cd alminium
yum -y install patch
cat ../alminium_inst-script_rhel6_httpd-redmine.conf.patch | patch -p1
cat ../alminium_inst-script_rhel6_post-install.patch | patch -p1
source ./smelt > /usr/local/src/alminium/ALMinium_Install.log 2>&1
reboot
