#!/bin/bash
ALM_HOSTNAME=
BucketName=
IAMRole=
RDSENDNAME=
RDSDBNAME=
RDSUser=
RDSPass=
SMTPSET=
SMTPSERVER=
SMTPTLS=
SMTPPORT=
SMTPLOGIN=
SMTPUser=
SMTPPass=
s3fs_var=1.74
ENABLE_JENKINS=y
export USER=root
export HOME=/root
SSL=N
USE_DISABLE_SECURITY=N
yum -y install ruby19 ruby19-devel rubygems19 rubygems19-devel
alternatives --set ruby /usr/bin/ruby1.9
gem install rubygems-update
update_rubygems
yum -y install http://mirror.centos.org/centos/6/os/x86_64/Packages/libical-0.43-6.el6.x86_64.rpm
yum -y install http://mirror.centos.org/centos/6/os/x86_64/Packages/ipa-pgothic-fonts-003.02-4.1.el6.noarch.rpm
yum -y install subversion make automake gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel curl-devel libxml2-devel openssl-devel mailcap
yum -y install git
cd /usr/local/src
wget http://s3fs.googlecode.com/files/s3fs-$s3fs_var.tar.gz
tar xvzf s3fs-$s3fs_var.tar.gz
cd /usr/local/src/s3fs-$s3fs_var/
./configure --prefix=/usr
make
make install
rm -rf /usr/local/src/s3fs-$s3fs_var.tar.gz
cd /usr/local/src
git clone https://github.com/alminium/alminium.git
cd /usr/local/src/alminium
yum -y install patch
cat ../alminium_inst-script_rhel6_httpd-redmine.conf.patch | patch -p1
cat ../alminium_inst-script_rhel6_post-install.patch | patch -p1
source ./smelt > /usr/local/src/alminium/ALMinium_Install.log 2>&1
mkdir -p /mnt/s3
s3fs $BucketName /mnt/s3 -o allow_other -o allow_other,default_acl=public-read,iam_role=$IAMRole
cd /mnt/s3
rm -rf /opt/alminium/
rm -rf /opt/alminium/files
ln -s /mnt/s3/alminium /var/opt/alminium
ln -s /mnt/s3/files /opt/alminium/files
echo "/usr/bin/s3fs#$BucketName /mnt/s3 fuse allow_other,default_acl=public-read,iam_role=$IAMRole 0 0" >> /etc/fstab
echo -e "production-sqlite:
  adapter: sqlite3
  database: db/alminium.sqlite3

production:
  adapter: mysql2
  database: $RDSDBNAME
  host: $RDSENDNAME
  username: $RDSUser
  password: $RDSPass
  encoding: utf8" > /opt/alminium/config/database.yml
service mysqld stop
chkconfig mysqld off
sed -i -e 's/DBI:mysql:database=alminium;host=localhost/DBI:mysql:database='"$RDSDBNAME"';host='"$RDSENDNAME"'/' /etc/httpd/conf.d/vcs.conf
sed -i -e 's/RedmineDbUser "alminium"/RedmineDbUser "'"$RDSUser"'"/' /etc/httpd/conf.d/vcs.conf
sed -i -e 's/RedmineDbPass "alminium"/RedmineDbPass "'"$RDSPass"'"/' /etc/httpd/conf.d/vcs.conf
service httpd restart
reboot
