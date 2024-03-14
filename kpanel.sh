#!/bin/bash
checktruenumber='^[0-9]+$'

kiemtraemail3="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~])+\.)*[-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,24}$";
svip=$(wget http://ipecho.net/plain -O - -q ; echo)
phpmacdinh="7.4"
numPHPmacdinh="74"
echo "=========================================================================="
echo "Mac dinh server se duoc cai dat PHP "$phpmacdinh". Neu muon su dung phien ban PHP "
echo "--------------------------------------------------------------------------"
echo "khac, sau khi cai dat server xong dung chuc nang [ Change PHP Version ] "
echo "--------------------------------------------------------------------------"
echo "trong [ Update System ] cua KPANEL."
echo "--------------------------------------------------------------------------"
echo "KPANEL ho tro: PHP 7.2, PHP 7.1, PHP 7.0, PHP 5.6, PHP 5.5 & PHP 5.4"
cpuname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cpufreq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
svram=$( free -m | awk 'NR==2 {print $2}' )
svhdd=$( df -h | awk 'NR==2 {print $2}' )
svswap=$( free -m | awk 'NR==4 {print $2}' )
free -m
df -h
echo "=========================================================================="
echo "Thong Tin Server:  "
echo "--------------------------------------------------------------------------"
echo "Server Type: $(virt-what | awk 'NR==1 {print $NF}')"
echo "CPU Type: $cpuname"
echo "CPU Core: $cpucores"
echo "CPU Speed: $cpufreq MHz"
echo "Memory: $svram MB"
echo "Disk: $svhdd"
echo "IP: $svip"
echo "--------------------------------------------------------------------------"
echo "Dien Thong Tin Cai Dat: "
echo "=========================================================================="
echo -n "Nhap Phpmyadmin Port [ENTER]: " 
read svport
if [ "$svport" = "80" ] || [ "$svport" = "443" ] || [ "$svport" = "22" ] || [ "$svport" = "3306" ] || [ "$svport" = "25" ] || [ "$svport" = "465" ] || [ "$svport" = "587" ] || [ "$svport" = "21" ]; then
	svport="1241"
echo "Phpmyadmin khong the trung voi port cua dich vu khac !"
echo "KPANEL se dat phpmyadmin port la "$svport
fi
if [ "$svport" = "" ] ; then
clear
echo "=========================================================================="
echo "$svport khong duoc de trong."
echo "--------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !" 
bash /root/kpanel-setup
exit
fi
if ! [[ $svport -ge 100 && $svport -le 65535  ]] ; then  
clear
echo "=========================================================================="
echo "$svport khong hop le!"
echo "--------------------------------------------------------------------------"
echo "Port hop le la so tu nhien nam trong khoang (100 - 65535)."
echo "--------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !" 
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /root/kpanel-setup
exit
fi

echo "--------------------------------------------------------------------------"
echo -n "Nhap dia chi email quan ly [ENTER]: " 
read kpanelemail
if [ "$kpanelemail" = "" ]; then
clear
echo "=========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /root/kpanel-setup
exit
fi

if [[ ! "$kpanelemail" =~ $kiemtraemail3 ]]; then
clear
echo "=========================================================================="
echo "$kpanelemail co le khong dung dinh dang email!"
echo "--------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
clear
bash /root/kpanel-setup
exit
fi

prompt="Nhap lua chon cua ban: "
options=("MariaDB 10.1" "MariaDB 10.2 (Recommendations)" "MariaDB 10.3" "MariaDB 10.4" "MariaDB 10.5")
echo "=========================================================================="
echo "Lua Chon Cai Dat Phien Ban MariaDB  "
echo "=========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 
case "$REPLY" in
1) mariadbversion="10.1"; break;;
2) mariadbversion="10.2"; break;;
3) mariadbversion="10.3"; break;;
4) mariadbversion="10.4"; break;;
5) mariadbversion="10.5"; break;;
#0) mariadbversion="10.2"; break;;
*) mariadbversion="10.2"; break;;
#*) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
esac  
done

if [ "$mariadbversion" = "10.1" ]; then
phienbanmariadb=10.1
#elif [ "$mariadbversion" = "10.2" ]; then
#phienbanmariadb=10.2
elif [ "$mariadbversion" = "10.3" ]; then
phienbanmariadb=10.3
elif [ "$mariadbversion" = "10.4" ]; then
phienbanmariadb=10.4
elif [ "$mariadbversion" = "10.5" ]; then
phienbanmariadb=10.5
else
phienbanmariadb=10.2
fi

# auto mysql root password
passrootmysql=`date |md5sum |cut -c '1-12'`
#echo $passrootmysql

# v1
#echo "-------------------------------------------------------------------------"
#echo "Mat khau root MySQL toi thieu 8 ki tu va chi su dung chu cai va so."
#echo "-------------------------------------------------------------------------"
#echo -n "Nhap mat khau root MySQL [ENTER]: " 
#read passrootmysql
#if [[ ! ${#passrootmysql} -ge 8 ]]; then
#clear
#echo "========================================================================="
#echo "Mat khau tai khoan root MySQL toi thieu phai co 8 ki tu."
#echo "-------------------------------------------------------------------------"
#echo "Ban vui long thu lai !"
#echo "-------------------------------------------------------------------------"
#read -p "Nhan [Enter] de tiep tuc ..."
#clear
#bash /root/kpanel-setup
#exit
#fi  

#checkpass="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
#if [[ ! "$passrootmysql" =~ $checkpass ]]; then
#clear
#echo "========================================================================="
#echo "Ban chi duoc dung chu cai va so de dat mat khau MySQL !"
#echo "-------------------------------------------------------------------------"
#echo "Ban vui long thu lai !"
#echo "-------------------------------------------------------------------------"
#read -p "Nhan [Enter] de tiep tuc ..."
#clear
#bash /root/kpanel-setup
#exit
#fi  
echo "$passrootmysql" > /tmp/passrootmysql

###############################################################################
#Download Nginx, KPANEL & phpMyadmin Version
cd /tmp
rm -rf 00-all-nginx-version.txt
rm -rf kpanel.newversion
rm -rf 00-all-phpmyadmin-version.txt
###########################
download_version_nginx () {
#wget --no-check-certificate -q https://kdata.vn/script/kpanel/00-all-nginx-version.txt
yes | cp -rf /opt/kdata_kpanel/script/kpanel/00-all-nginx-version.txt 00-all-nginx-version.txt
}
download_version_nginx
checkdownload_version_nginx=`cat /tmp/00-all-nginx-version.txt`
if [ -z "$checkdownload_version_nginx" ]; then
download_version_nginx
fi
###########################
download_version_phpmyadmin () {
#wget --no-check-certificate -q https://kdata.vn/script/kpanel/00-all-phpmyadmin-version.txt
yes | cp -rf /opt/kdata_kpanel/script/kpanel/00-all-phpmyadmin-version.txt 00-all-phpmyadmin-version.txt
}
download_version_phpmyadmin
checkdownload_version_phpmyadmin=`cat /tmp/00-all-phpmyadmin-version.txt`
if [ -z "$checkdownload_version_phpmyadmin" ]; then
download_version_phpmyadmin
fi
###########################
download_version_kpanel () {
#wget -q --no-check-certificate https://kdata.vn/script/kpanel/kpanel.newversion
yes | cp -rf /opt/kdata_kpanel/script/kpanel/kpanel.newversion kpanel.newversion
}
download_version_kpanel
checkdownload_version_kpanel=`cat /tmp/kpanel.newversion`
if [ -z "$checkdownload_version_kpanel" ]; then
download_version_kpanel
fi
###########################
cd
. /opt/kdata_kpanel/script/kpanel/nginx-setup.conf
phpmyadmin_version=`cat /tmp/00-all-phpmyadmin-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
#Nginx_VERSION=`cat /tmp/00-all-nginx-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
kpanel_version=`cat /tmp/kpanel.newversion`

# End Download Nginx, KPANEL & phpMyadmin Version
###############################################################################

clear

echo "=========================================================================="
echo "OS Version: "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))
echo "--------------------------------------------------------------------------"
echo "KPANEL Se Cai Dat Server Theo Thong Tin:"
echo "=========================================================================="
echo "eMail Quan Ly: $kpanelemail"
echo "--------------------------------------------------------------------------"
echo "phpMyAdmin Port: $svport"
echo "--------------------------------------------------------------------------"
echo "phpMyAdmin Version: $phpmyadmin_version"
echo "--------------------------------------------------------------------------"
echo "MariaDB Version: $phienbanmariadb"
echo "--------------------------------------------------------------------------"
echo "Mat khau tai khoan root MySQL: $passrootmysql"
echo "--------------------------------------------------------------------------"
echo "Nginx Version: $Nginx_VERSION"
echo "--------------------------------------------------------------------------"
echo "PHP Version: "$phpmacdinh
echo "--------------------------------------------------------------------------"
echo "KPANEL Version: $kpanel_version"
echo "=========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Dong Y" "Khong Dong Y")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) xacnhanthongtin="dongy"; break;;
    2) xacnhanthongtin="khongdongy"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done

if [ "$xacnhanthongtin" = "dongy" ]; then
echo "--------------------------------------------------------------------------"
echo "Chuan Bi Cai Dat KPANEL ..."
sleep 2
else 
clear
rm -rf /root/install && bash /root/kpanel-setup
exit
fi


download_nginx_conf () {
#wget --no-check-certificate -q https://kdata.vn/script/kpanel/nginx.conf -O /tmp/nginx.conf
yes | cp -rf /opt/kdata_kpanel/script/kpanel/nginx.conf /tmp/nginx.conf
}
download_nginx_conf
checkdownload_nginx_conf=`cat /tmp/nginx.conf`
if [ -z "$checkdownload_nginx_conf" ]; then
download_nginx_conf
fi

cat >> "/root/.bash_profile" <<END
IPkpanelcheck="\$(echo \$SSH_CONNECTION | cut -d " " -f 1)"
timeloginkpanelcheck=\$(date +"%e %b %Y, %a %r")
echo 'Someone has IP address '\$IPkpanelcheck' login to $svip on '\$timeloginkpanelcheck'.' | mail -s 'eMail Notifications From KPANEL On $svip' ${kpanelemail}
END
echo "$svport" > /tmp/priport.txt
if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi

/opt/kdata_kpanel/script/kpanel/menu/yum-first-install

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
if [ -f /etc/yum.repos.d/epel.repo ]; then
sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
fi

#if [ "$phienbanmariadb" = "10.0" ] || [ "$phienbanmariadb" = "10.1" ] || [ "$phienbanmariadb" = "10.2" ] || [ "$phienbanmariadb" = "10.3" ] || [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ]; then
#fi

# https://mariadb.com/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/
#if [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ]; then
if [ "$phienbanmariadb" = "10.6" ]; then
cat > "/etc/yum.repos.d/mariadb.repo" <<END
[mariadb-main]
name = MariaDB Server
baseurl = https://downloads.mariadb.com/MariaDB/mariadb-$phienbanmariadb/yum/rhel/\$releasever/\$basearch
gpgkey = file:///etc/pki/rpm-gpg/MariaDB-Server-GPG-KEY
gpgcheck = 1
enabled = 1


[mariadb-maxscale]
# To use the latest stable release of MaxScale, use "latest" as the version
# To use the latest beta (or stable if no current beta) release of MaxScale, use "beta" as the version
name = MariaDB MaxScale
baseurl = https://downloads.mariadb.com/MaxScale/2.4/centos/\$releasever/\$basearch
gpgkey = file:///etc/pki/rpm-gpg/MariaDB-MaxScale-GPG-KEY
gpgcheck = 1
enabled = 1

[mariadb-tools]
name = MariaDB Tools
baseurl = https://downloads.mariadb.com/Tools/rhel/\$releasever/\$basearch
gpgkey = file:///etc/pki/rpm-gpg/MariaDB-Enterprise-GPG-KEY
gpgcheck = 1
enabled = 1
END
else
cat > "/etc/yum.repos.d/mariadb.repo" <<END
# MariaDB $phienbanmariadb CentOS repository list 
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/$phienbanmariadb/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
END
fi

systemctl mask firewalld
systemctl stop firewalld
#systemctl stop sendmail.service 
systemctl stop xinetd.service
systemctl stop saslauthd.service 
systemctl stop rsyslog.service 
systemctl stop postfix.service
#systemctl disable sendmail.service
systemctl disable xinetd.service 
systemctl disable saslauthd.service 
systemctl disable rsyslog.service 
systemctl disable postfix.service
sudo yum -y remove mysql*
sudo yum -y remove php*
sudo yum -y remove httpd*
#sudo yum -y remove sendmail*
sudo yum -y remove postfix*
sudo yum -y remove rsyslog*
mkdir -p /usr/local/kpanel
cd /usr/local/kpanel

groupadd nginx
useradd -g nginx -d /dev/null -s /sbin/nologin nginx

sudo yum makecache
sudo yum -y update
sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel mailx tar expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Crypt-SSLeay perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxml2-devel libxml2 libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel libgcj gettext-devel vim-minimal nano cairo-devel libpng-devel freetype freetype-devel libart_lgpl-devel  GeoIP-devel gperftools-devel libicu libicu-devel aspell gmp-devel aspell-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant enchant-devel pam-devel git perl-ExtUtils perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils libc-client libc-client-devel numactl lsof pkgconfig gdbm-devel tk-devel libatomic_ops-devel gperftools bluez-libs-devel
sudo yum -y install unzip zip rar unrar rsync psmisc syslog-ng-libdbi screen 
sudo yum -y install sendmail sendmail-cf m4
systemctl start sendmail.service
systemctl enable sendmail.service
cd
#git --version | awk 'NR==1 {print $3}' > /tmp/gitversion
#if [ -f /tmp/gitversion ]; then
#sed -i 's/\.//g' /tmp/gitversion
#if [ $(cat /tmp/gitversion) -lt 253 ]; then
#if [ ! "$(cat /tmp/gitversion)" = "253" ]; then
#sudo yum -y remove git
#cd /usr/src
#wget -q --no-check-certificate https://github.com/kdatavn/kdata-vps-software/raw/master/git-2.5.3.tar.gz
#tar xzf git-2.5.3.tar.gz
#cd /usr/src/git-2.5.3
#make prefix=/usr/local/git all
#make prefix=/usr/local/git install
#echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
#source /etc/bashrc
#cd
#fi
#else
#cd /usr/src
#wget -q --no-check-certificate https://github.com/kdatavn/kdata-vps-software/raw/master/git-2.5.3.tar.gz
#tar xzf git-2.5.3.tar.gz
#cd /usr/src/git-2.5.3
#make prefix=/usr/local/git all
#make prefix=/usr/local/git install
#echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
#source /etc/bashrc
#cd
#fi


/opt/kdata_kpanel/script/kpanel/menu/nginx-setup7
/opt/kdata_kpanel/script/kpanel/menu/nginx-setup-done
# check ssl/ tls in serrver
#openssl s_client -connect $svip:443 -ssl2
#openssl s_client -connect $svip:443 -ssl3
#openssl s_client -connect $svip:443 -tls1
#openssl s_client -connect $svip:443 -tls1_1
#openssl s_client -connect $svip:443 -tls1_2
#sleep 30
#exit


sudo yum makecache fast
#if [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ]; then
#sudo yum -y install perl-DBI libaio libsepol lsof boost-program-options
#sudo yum -y install --repo="mariadb-main" MariaDB-server
#else
#sudo yum -y install --repo="mariadb" MariaDB-server
sudo yum -y install MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
#fi

sudo yum -y install exim syslog-ng cronie cronie-anacron

yum-config-manager --enable remi-php$numPHPmacdinh
#sudo yum -y install php php-curl php-soap php-cli php-snmp php-pspell redis php-pecl-redis php-gmp php-ldap php-bcmath php-intl php-imap perl-libwww-perl perl-LWP-Protocol-https php-pear-Net-SMTP php-enchant php-common php-fpm php-gd php-devel php-mysql php-pear php-pecl-memcached php-pecl-memcache php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt php-xmlrpc php-tidy
#sudo yum -y install php php-curl php-pecl-zip php-zip php-soap php-cli php-snmp php-pspell php-pecl-redis php-gmp php-ldap php-bcmath php-intl php-imap perl-libwww-perl perl-LWP-Protocol-https php-pear-Net-SMTP php-enchant php-common php-fpm php-gd php-devel php-mysql php-pear php-pecl-memcached php-pecl-memcache php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt php-xmlrpc php-tidy
if [ -f /etc/kpanel/menu/nangcap-php/install-php ]; then
/etc/kpanel/menu/nangcap-php/install-php
else
echo "Install php module..."
sudo yum -y install php php-curl php-pecl-zip php-zip php-soap php-cli php-snmp php-pspell php-gmp php-ldap php-bcmath php-intl php-imap perl-libwww-perl perl-LWP-Protocol-https php-pear-Net-SMTP php-enchant php-common php-fpm php-gd php-devel php-mysql php-pear php-opcache php-pdo php-zlib php-xml php-mbstring php-mcrypt php-xmlrpc php-tidy
fi

#sudo yum -y install memcached

sudo yum -y install ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel 
yes "" | pecl install imagick
# neu cai dat thanh cong imagick -> include vao
if [ -f /usr/lib64/php/modules/imagick.so ]; then
echo "extension=imagick.so" > /etc/php.d/imagick.ini
else
rm -rf /etc/php.d/imagick.ini
fi

clear
echo "=========================================================================="
echo "Cai Dat Hoan Tat, Bat Dau Qua Trinh Cau Hinh...... "
echo "=========================================================================="
sleep 3
	ramformariadb=$(calc $svram/10*6)
	ramforphpnginx=$(calc $svram-$ramformariadb)
	max_children=$(calc $ramforphpnginx/30)
	memory_limit=$(calc $ramforphpnginx/5*3)M
	mem_apc=$(calc $ramforphpnginx/5)M
	buff_size=$(calc $ramformariadb/10*8)M
	log_size=$(calc $ramformariadb/10*2)M
systemctl enable exim.service 
systemctl enable syslog-ng.service
systemctl start exim.service 
systemctl start syslog-ng.service
systemctl disable httpd.service
systemctl enable nginx.service 
systemctl start nginx.service 
systemctl enable php-fpm.service 
systemctl start php-fpm.service
#systemctl enable mariadb.service
#systemctl start mariadb.service 
chkconfig --add mysql
chkconfig --levels 235 mysql on
systemctl enable mysql
service mysql start
#systemctl enable redis.service
#systemctl start redis.service
mkdir -p /home/kpanel.demo/public_html
cd /home/kpanel.demo/public_html
#wget https://kdata.vn/script/kpanel/robots.txt
#wget --no-check-certificate -q https://kpanel.com/script/kpanel/html/install/vietnam/index.html
yes | cp -rf /opt/kdata_kpanel/script/kpanel/html/install/vietnam/index.html index.html
cd
mkdir /home/kpanel.demo/private_html

# tao thu muc log va cac file log de phong truong hop cac ung dung khong the tu tao
mkdir -p /home/kpanel.demo/logs
chmod 777 /home/kpanel.demo/logs
touch /home/kpanel.demo/logs/mysql-slow.log
touch /home/kpanel.demo/logs/mysql.log
touch /home/kpanel.demo/logs/php-fpm-error.log
touch /home/kpanel.demo/logs/php-fpm-slow.log
touch /home/kpanel.demo/logs/php-fpm.log
chmod 777 /home/kpanel.demo/logs/*

mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
chown -R nginx:nginx /var/lib/php/session
rm -rf /etc/sysconfig/memcached
cat > "/etc/sysconfig/memcached" <<END
PORT="11211"
USER="memcached"
MAXCONN="10024"
CACHESIZE="20"
OPTIONS=""
END

kpanel_setup_cleanup_config_file () {
# remove blank in last line
sed -i -e "s/\s*$//" $1
# remove blank in first line
sed -i -e "s/^\s*//" $1
# remove blank line
sed -i -e "/^$/d" $1
sed -i -e '/^\s*$/d' $1
# remove comment line
sed -i -e '/^\s*#.*$/d' $1
}

rm -rf /etc/nginx/conf.d
mkdir -p /etc/nginx/conf.d
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf-webserver/kpanel.demo.txt /etc/nginx/conf.d/kpanel.demo.conf
# config
cat > "/tmp/kpanelSetConfigFile" <<END
#!/bin/bash 
sed -i 's/tmp_listen_svport/listen   $svport/g' /etc/nginx/conf.d/kpanel.demo.conf
END
chmod +x /tmp/kpanelSetConfigFile
sh /tmp/kpanelSetConfigFile
rm -f /tmp/kpanelSetConfigFile
# cleanup
kpanel_setup_cleanup_config_file "/etc/nginx/conf.d/kpanel.demo.conf"


if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
pmmaxchildren=4
pmstartservers=2
pmminspareservers=1
pmmaxspareservers=3
pmmaxrequests=150
###############################################
elif [[ $svram -ge 450 && $svram -le 1300  ]] ; then
pmmaxchildren=10
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=400
###############################################
elif [[ $svram -ge 1302 && $svram -le 1800  ]] ; then
pmmaxchildren=15
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500
###############################################
elif [[ $svram -ge 1801 && $svram -le 2800  ]] ; then
pmmaxchildren=20
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500
###############################################
elif [[ $svram -ge 2801 && $svram -le 5000  ]] ; then
pmmaxchildren=33
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500

###############################################
else
pmmaxchildren=50
pmstartservers=3
pmminspareservers=2
pmmaxspareservers=6
pmmaxrequests=500
fi



rm -f /etc/php-fpm.d/www.conf
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf-webserver/www.txt /etc/php-fpm.d/www.conf
# config
cat > "/tmp/kpanelSetConfigFile" <<END
#!/bin/bash 
sed -i 's/tmp_pmmaxchildren/$pmmaxchildren/g' /etc/php-fpm.d/www.conf
sed -i 's/tmp_pmstartservers/$pmstartservers/g' /etc/php-fpm.d/www.conf
sed -i 's/tmp_pmminspareservers/$pmminspareservers/g' /etc/php-fpm.d/www.conf
sed -i 's/tmp_pmmaxspareservers/$pmmaxspareservers/g' /etc/php-fpm.d/www.conf
sed -i 's/tmp_pmmaxrequests/$pmmaxrequests/g' /etc/php-fpm.d/www.conf
END
chmod +x /tmp/kpanelSetConfigFile
sh /tmp/kpanelSetConfigFile
rm -f /tmp/kpanelSetConfigFile
# cleanup
kpanel_setup_cleanup_config_file "/etc/php-fpm.d/www.conf"


rm -rf /etc/php.ini
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf-webserver/php.ini /etc/php.ini
# config
cat > "/tmp/kpanelSetConfigFile" <<END
#!/bin/bash 
sed -i 's/tmp_memory_limit/$memory_limit/g' /etc/php.ini
END
chmod +x /tmp/kpanelSetConfigFile
sh /tmp/kpanelSetConfigFile
rm -f /tmp/kpanelSetConfigFile
# cleanup
kpanel_setup_cleanup_config_file "/etc/php.ini"


if [ ! -d /home/0-KPANEL-SHORTCUT ];then
#wget --no-check-certificate -q https://kpanel.com/script/kpanel/check-imagick.php.zip -O /home/kpanel.demo/private_html/check-imagick.php
yes | cp -rf /opt/kdata_kpanel/script/kpanel/check-imagick.php.zip /home/kpanel.demo/private_html/check-imagick.php
mkdir -p /home/0-KPANEL-SHORTCUT
mkdir -p /home/kpanel.demo/private_html/backup
ln -s /home/kpanel.demo/private_html/backup /home/0-KPANEL-SHORTCUT/Backup\ \(Website\ +\ Database\)
ln -s /etc/nginx/conf.d /home/0-KPANEL-SHORTCUT/Vhost\ \(Vitual\ Host\)
echo "This is shortcut to Backup ( Code & Database ) and Vitual Host in VPS" > /home/0-KPANEL-SHORTCUT/readme.txt
echo "Please do not delete it" >>  /home/0-KPANEL-SHORTCUT/readme.txt
fi

rm -rf /etc/php.d/*opcache*
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf-webserver/opcache.ini /etc/php.d/opcache.ini
# cleanup
kpanel_setup_cleanup_config_file "/etc/php.d/opcache.ini"


rm -rf /etc/sysctl.conf
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf-webserver/sysctl.txt /etc/sysctl.conf
# cleanup
kpanel_setup_cleanup_config_file "/etc/sysctl.conf"


rm -rf /etc/php-fpm.conf
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf-webserver/php-fpm.txt /etc/php-fpm.conf
# cleanup
kpanel_setup_cleanup_config_file "/etc/php-fpm.conf"


if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
heso1=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso1=1
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso1=3
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso1=6
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso1=8
else
heso1=10
fi

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
heso2=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso2=2
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso2=3
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso2=4
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso2=6
else
heso2=10
fi

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
heso3=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso3=2
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso3=3
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso3=4
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso3=5
else
heso3=6
fi

if [[ $svram -ge 32 && $svram -le 449  ]] ; then 
heso4=1
elif [[ $svram -ge 450 && $svram -le 1099  ]] ; then
heso4=1
elif [[ $svram -ge 1100 && $svram -le 1999  ]] ; then
heso4=2
elif [[ $svram -ge 2000 && $svram -le 2999  ]] ; then
heso4=2
elif [[ $svram -ge 3000 && $svram -le 5000  ]] ; then
heso4=3
else
heso4=4
fi

if ! [[ $cpucores =~ $checktruenumber ]] ; then
cpucores=1
fi 

rm -f /etc/my.cnf.d/server.cnf
    cat > "/etc/my.cnf.d/server.cnf" <<END

[mysqld]
skip-host-cache
skip-name-resolve
collation-server = utf8_unicode_ci
init-connect='SET NAMES utf8'
character-set-server = utf8
skip-character-set-client-handshake

user = mysql
default-storage-engine = InnoDB
local-infile=0
ignore-db-dir=lost+found
character-set-server=utf8
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

#bind-address=127.0.0.1
back_log = $(calc 75*$heso2)
max_connections = $(calc 22*$heso2)
key_buffer_size = 32M
myisam_recover = FORCE,BACKUP
myisam_sort_buffer_size = $(calc 32*$heso1)M
join_buffer_size = $(calc 32*$heso2)K  
read_buffer_size = $(calc 32*$heso2)K 
sort_buffer_size = $(calc 64*$heso2)K 
table_definition_cache = 2048
table_open_cache = 2048
thread_cache_size = $(calc 8*$heso2)K
wait_timeout = 50
connect_timeout = 10
interactive_timeout = 40
optimizer_search_depth = 4
tmp_table_size = $(calc 16*$heso3)M
max_heap_table_size = $(calc 16*$heso3)M
max_allowed_packet = $(calc 16*$heso2)M
max_seeks_for_key = 1000

max_length_for_sort_data = 1024
net_buffer_length = 16384
max_connect_errors = 100000
concurrent_insert = 2
read_rnd_buffer_size = $(calc 1*$heso2)M
bulk_insert_buffer_size = 8M
query_cache_limit = 512K
query_cache_size = $(calc 8*$heso2)M
query_cache_type = 1
query_cache_min_res_unit = 2K


log_warnings=1
slow_query_log=0
long_query_time=1
log_error = /home/kpanel.demo/logs/mysql.log
log_queries_not_using_indexes = 0
slow_query_log_file = /home/kpanel.demo/logs/mysql-slow.log

# innodb settings
innodb_large_prefix=1
innodb_purge_threads=1
innodb_file_format = Barracuda
innodb_file_per_table = 1
innodb_open_files = $(calc 200*$heso2)
innodb_data_file_path= ibdata1:10M:autoextend
innodb_buffer_pool_size = $(calc 64*$heso2)M
skip-innodb_doublewrite # or commented out

## https://mariadb.com/kb/en/mariadb/xtradbinnodb-server-system-variables/#innodb_buffer_pool_instances
#innodb_buffer_pool_instances=2

innodb_log_files_in_group = 2
innodb_log_file_size = 48M
#innodb_log_buffer_size = 1M
innodb_flush_log_at_trx_commit = 2
innodb_thread_concurrency = $(calc 2*$cpucores)
innodb_lock_wait_timeout=50
innodb_flush_method = O_DIRECT
innodb_support_xa=1

# 200 * # DISKS
#innodb_io_capacity = 100 # 100 for HDD
innodb_read_io_threads = $(calc 4*$cpucores)
innodb_write_io_threads = $(calc 4*$cpucores)

# mariadb settings
[mariadb]

userstat = 0
#key_cache_segments = 0  # 1 to 64
aria_group_commit = none
aria_group_commit_interval = 0
aria_log_file_size = $(calc 11*$heso2)M
aria_log_purge_type = immediate 
aria_pagecache_buffer_size = 1M
aria_sort_buffer_size = 1M

[mariadb-5.5]
#ignore_db_dirs=
query_cache_strip_comments=0

innodb_read_ahead = linear
innodb_adaptive_flushing_method = estimate
innodb_flush_neighbor_pages=none
innodb_stats_update_need_lock = 0
innodb_log_block_size = 512

log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

[mysqld_safe] 
socket=/var/lib/mysql/mysql.sock
log-error=/home/kpanel.demo/logs/mysql.log
#nice = -5
open-files-limit = 8192

[mysqldump]
quick
max_allowed_packet = 32M

[isamchk]
key_buffer = $(calc 16*$heso4)M
sort_buffer_size = $(calc 128*$heso4)K
read_buffer = $(calc 128*$heso4)K
write_buffer = $(calc 128*$heso4)K

[myisamchk]
key_buffer = $(calc 16*$heso4)M
sort_buffer_size = $(calc 128*$heso4)K
read_buffer = $(calc 128*$heso4)K
write_buffer = $(calc 128*$heso4)K

[mysqlhotcopy]
interactive-timeout
END


# fixed ERROR for MariaDB config (xu ly loi config tren cac phien ban MariaDB khac nhau)
if [ "$phienbanmariadb" = "10.2" ] ; then
# ERROR: Field doesn't have a default value -> Loi sql_mode trong phien ban 10.2++
cat > "/tmp/kpanelSetConfigFile" <<END
#!/bin/bash 
sed -i -e "/sql_mode=/d" /etc/my.cnf.d/server.cnf
sed -i '/^skip-character-set-client-handshake.*/a sql_mode=NO_ENGINE_SUBSTITUTION' /etc/my.cnf.d/server.cnf
END
chmod +x /tmp/kpanelSetConfigFile
sh /tmp/kpanelSetConfigFile
rm -f /tmp/kpanelSetConfigFile
fi

if [ "$phienbanmariadb" = "10.3" ] || [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ] ; then
# https://mariadb.com/kb/en/upgrading-from-mariadb-102-to-mariadb-103/
cat > "/tmp/kpanelSetConfigFile" <<END
#!/bin/bash 
sed -i 's/innodb_support_xa=/\#innodb_support_xa=/g' /etc/my.cnf.d/server.cnf
END
chmod +x /tmp/kpanelSetConfigFile
sh /tmp/kpanelSetConfigFile
rm -f /tmp/kpanelSetConfigFile
fi


if [ "$phienbanmariadb" = "10.0" ] || [ "$phienbanmariadb" = "10.1" ] || [ "$phienbanmariadb" = "10.2" ] ; then
cat >> "/etc/my.cnf.d/server.cnf" <<END

[mariadb-$phienbanmariadb]
innodb_buffer_pool_dump_at_shutdown=1
innodb_buffer_pool_load_at_startup=1
innodb_buffer_pool_populate=0
performance_schema=OFF
innodb_stats_on_metadata=OFF
innodb_sort_buffer_size=1M
query_cache_strip_comments=0
log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

END
fi

if [ "$phienbanmariadb" = "10.3" ] || [ "$phienbanmariadb" = "10.4" ] || [ "$phienbanmariadb" = "10.5" ] ; then
cat >> "/etc/my.cnf.d/server.cnf" <<END

[mariadb-$phienbanmariadb]
innodb_buffer_pool_dump_at_shutdown=1
innodb_buffer_pool_load_at_startup=1
#innodb_buffer_pool_populate=0
performance_schema=OFF
innodb_stats_on_metadata=OFF
innodb_sort_buffer_size=1M
query_cache_strip_comments=0
log_slow_filter =admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk

END
fi


    cat >> "/etc/security/limits.conf" <<END
* soft nofile 65536
* hard nofile 65536
nginx soft nofile 65536
nginx hard nofile 65536
* soft core 0 
* hard core 0
END

ulimit  -n 65536


mkdir -p /etc/kpanel
echo "" > /etc/kpanel/pwprotect.default

cat > "/etc/kpanel/nginx.version" <<END
${Nginx_VERSION}
END

cat > "/etc/kpanel/kpanel.version" <<END
${kpanel_version}
END

cat > "/etc/kpanel/phpmyadmin.version" <<END
${phpmyadmin_version}
END

mkdir -p /etc/redis
cat > "/etc/redis/redis.conf" <<END
maxmemory 40mb
maxmemory-policy allkeys-lru
END

if [ ! "$(grep LANG=en_US.utf-8 /etc/environment)" == "LANG=en_US.utf-8" ]; then
cat > "/etc/environment" <<END
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
END
fi

rm -f /home/kpanel.conf
    cat > "/home/kpanel.conf" <<END
mainsite="kpanel.demo"
priport="$svport"
serverip="$svip"
END

rm -f /var/lib/mysql/ib_logfile0
rm -f /var/lib/mysql/ib_logfile1
rm -f /var/lib/mysql/ibdata1
if [ "$phienbanmariadb" = "10.4" ] ; then
sudo systemctl enable --now mariadb
fi
service mysql start
# Download mysql_secure_installation
rm -f /bin/mysql_secure_installation
download_mysql_secure_installation () {
#wget --no-check-certificate -q https://kdata.vn/script/kpanel/mysql_secure_installation -O /bin/mysql_secure_installation && chmod +x /bin/mysql_secure_installation
yes | cp -rf /opt/kdata_kpanel/script/kpanel/mysql_secure_installation /bin/mysql_secure_installation && chmod +x /bin/mysql_secure_installation
}
download_mysql_secure_installation
checkmysql_secure_installation=`cat /bin/mysql_secure_installation`
if [ -z "$checkmysql_secure_installation" ]; then
download_mysql_secure_installation
fi

#wget --no-check-certificate -q https://kpanel.com/script/kpanel/Softwear/wp-cli.phar
#yes | cp -rf /opt/kdata_kpanel/script/kpanel/Softwear/wp-cli.phar wp-cli.phar
wget -q --no-check-certificate https://github.com/kdatavn/kdata-vps-software/raw/main/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
#clear
#echo "=========================================================================="
#echo "Dat Mat Khau Cho Tai Khoan root Cua MYSQL ... "
#echo "=========================================================================="
/bin/mysql_secure_installation
cat >> "/home/kpanel.conf" <<END
emailmanage="$kpanelemail"
END
#systemctl restart mariadb.service
service mysql restart
clear
echo "=========================================================================="
echo "Cai dat phpMyAdmin... "
echo "=========================================================================="
sleep 2
cd /home/kpanel.demo/private_html/
#wget -q https://gist.github.com/ck-on/4959032/raw/0b871b345fd6cfcd6d2be030c1f33d1ad6a475cb/ocp.php
wget -q https://gist.githubusercontent.com/ck-on/4959032/raw/0b871b345fd6cfcd6d2be030c1f33d1ad6a475cb/ocp.php
#wget --no-check-certificate -q https://kpanel.com/script/kpanel/memcache.php.zip -O /home/kpanel.demo/private_html/memcache.php
yes | cp -rf /opt/kdata_kpanel/script/kpanel/memcache.php.zip /home/kpanel.demo/private_html/memcache.php

wget -q https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.zip
unzip -q phpMyAdmin-*.zip > /dev/null 2>&1
yes | cp -rf phpMyAdmin-*/* .
rm -rf phpMyAdmin-*
randomblow=`date |md5sum |cut -c '1-32'`;
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomblow'|" config.sample.inc.php > config.inc.php
cd
mkdir -p /var/lib/php/session
chown -R nginx:nginx /var/lib/php
clear
echo "=========================================================================="
echo "Dang Tao KPANEL Menu...... "
echo "=========================================================================="
rm -rf /etc/motd

#wget --no-check-certificate -q https://kdata.vn/script/kpanel/motd -O /etc/motd
yes | cp -rf /opt/kdata_kpanel/script/kpanel/motd /etc/motd


# Download kpanel_main_menu
download_kpanel_main_menu () {
#wget --no-check-certificate -q https://kdata.vn/script/kpanel/kpanel -O /bin/kpanel && chmod +x /bin/kpanel
yes | cp -rf /opt/kdata_kpanel/script/kpanel/kpanel /bin/kpanel && chmod +x /bin/kpanel
}
download_kpanel_main_menu
checkkpanel_main_menu=`cat /bin/kpanel`
if [ -z "$checkkpanel_main_menu" ]; then
download_kpanel_main_menu
fi



cd /etc/kpanel/

# Download KPANEL data
download_kpanel_data () {
#rm -rf menu.zip
#wget --no-check-certificate -q https://kdata.vn/script/kpanel/menu.zip
#unzip -q menu.zip
#rm -rf menu.zip
mkdir -p /etc/kpanel/menu ; chmod 755 /etc/kpanel/menu
yes | cp -rf /opt/kdata_kpanel/script/kpanel/menu/. /etc/kpanel/menu/
}
#download_kpanel_data
#if [ ! -f /etc/kpanel/menu/kpanel-tien-ich ]; then
#download_kpanel_data
#fi

#wget --no-check-certificate -q https://kpanel.com/script/kpanel/errorpage_html.zip
#unzip -q errorpage_html.zip
#rm -rf errorpage_html.zip
#cp -r /etc/kpanel/errorpage_html /home/kpanel.demo/
mkdir -p /home/kpanel.demo/errorpage_html ; chmod 755 /home/kpanel.demo/errorpage_html
yes | cp -rf /opt/kdata_kpanel/script/kpanel/errorpage_html/. /home/kpanel.demo/errorpage_html/
mkdir -p /etc/kpanel/errorpage_html ; chmod 755 /etc/kpanel/errorpage_html
yes | cp -rf /opt/kdata_kpanel/script/kpanel/errorpage_html/. /etc/kpanel/errorpage_html/

# tao thu muc cho phpmyadmin dung lam cache
mkdir -p /home/kpanel.demo/private_html/tmp ; chmod 777 /home/kpanel.demo/private_html/tmp

cd
# Chmod 755 Menu
#/opt/kdata_kpanel/script/kpanel/menu/chmod-755-menu

# Download /etc/nginx/conf
cd /etc/nginx/
download_etc_nginx_conf () {
#rm -rf conf.zip
#wget --no-check-certificate -q https://kpanel.com/script/kpanel/conf.zip
#unzip -q conf.zip
#rm -rf conf.zip
mkdir -p /etc/nginx/conf ; chmod 755 /etc/nginx/conf
yes | cp -rf /opt/kdata_kpanel/script/kpanel/conf/. /etc/nginx/conf/
}
download_etc_nginx_conf
#if [ ! -f /etc/nginx/conf/staticfiles.conf ]; then
#download_etc_nginx_conf
#fi
find /etc/nginx/conf -type f -exec chmod 644 {} \;
cd

###################################################
# Dat mat khau bao ve phpmyadmin, backup files
clear
echo "=========================================================================="
echo "Tao Username & Password bao ve phpMyadmin, backup files  ... "
echo "=========================================================================="
sleep 3
cp -r /etc/kpanel/menu/kpanel-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
rm -rf /etc/nginx/.htpasswd
matkhaubv=`date |md5sum |cut -c '1-6'`
usernamebv=`echo "${kpanelemail};" | sed 's/\([^@]*\)@\([^;.]*\)\.[^;]*;[ ]*/\1 \2\n/g' | awk 'NR==1 {print $1}'`
htpasswd.py -c -b /etc/nginx/.htpasswd $usernamebv $matkhaubv
chmod -R 644 /etc/nginx/.htpasswd
cat > "/etc/kpanel/pwprotect.default" <<END
userdefault="$usernamebv"
passdefault="$matkhaubv"
END
#wget --no-check-certificate -q https://kpanel.com/script/kpanel/Softwear/status.zip -O /home/kpanel.demo/public_html/status.php
yes | cp -rf /opt/kdata_kpanel/script/kpanel/Softwear/status.zip /home/kpanel.demo/public_html/status.php
rm -rf /etc/kpanel/defaulpassword.php
cat > "/etc/kpanel/defaulpassword.php" <<END
<?php
define('ADMIN_USERNAME','$usernamebv');   // Admin Username
define('ADMIN_PASSWORD','$matkhaubv');    // Admin Password
?>
END
sed -i "s/kpanel@kpanel.com/${kpanelemail}/g" /home/kpanel.demo/public_html/status.php
###################################################

if [ -f /etc/sysconfig/iptables ]; then
systemctl enable iptables 
systemctl enable ip6tables
systemctl start iptables
systemctl start ip6tables
systemctl start iptables.service

#iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#iptables -I INPUT -p tcp --dport 22 -j ACCEPT
#iptables -I INPUT -p tcp --dport 21 -j ACCEPT
#iptables -I INPUT -p tcp --dport 25 -j ACCEPT
#iptables -I INPUT -p tcp --dport 443 -j ACCEPT
#iptables -I INPUT -p tcp --dport 465 -j ACCEPT
#iptables -I INPUT -p tcp --dport 587 -j ACCEPT
#iptables -I INPUT -p tcp --dport $svport -j ACCEPT
#iptables -I INPUT -p tcp --dport 11211 -j ACCEPT

FIREWALLLIST="21 22 25 80 443 465 587 $svport 11211"
#echo $FIREWALLLIST
for PORT in ${FIREWALLLIST}; do
	if [ ! "$(iptables -L -n | grep :$PORT | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
		iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
		iptables -I INPUT -p udp --dport ${PORT} -j ACCEPT
	else
		echo $PORT
	fi
done 

# add ca ssh port hien tai neu no khong phai port 22
current_ssh_port=${SSH_CLIENT##* }
echo "current_ssh_port: "$current_ssh_port
if [ ! "$current_ssh_port" = "22" ]; then
iptables -I INPUT -p tcp --dport $current_ssh_port -j ACCEPT
fi

service iptables save
fi


# auto update system
/etc/kpanel/menu/auto-update-system "first-setup"


clear
#echo "=========================================================================="
#echo "Setup CSF Firewall ... "
#echo "=========================================================================="
sleep 3
#/etc/kpanel/menu/cai-csf-firewall-cai-dat-CSF-FIREWALL
#systemctl start memcached.service
#systemctl enable memcached.service 
rm -rf /root/install*
rm -rf /root/kpanel-setup
rm -rf rm -rf /etc/sysconfig/memcached
cat >> "/home/KPANEL-manage-info.txt" <<END
=========================================================================
                           VPS MANAGE INFOMATION                         
=========================================================================

phpMyAdmin: http://$svip:$svport

Quan Ly Zend Opcache: http://$svip:$svport/ocp.php

Quan Ly Memcache: http://$svip:$svport/memcache.php

Xem Server Status: http://$svip/status.php

Thong tin dang nhap phpMyadmin, quan ly Zend Opcache, status.php, download backup files ...

Username: $usernamebv
Password: $matkhaubv 

Lenh truy cap KPANEL: kpanel

LUU Y: 

De VPS co hieu suat tot nhat - Hay bat: Zend Opcache, Memcached, 
va su dung cac Plugin cache(wp super cache....) cho website. 

Neu VPS dang bat Zend Opcache, khi edit file PHP, do cac file php duoc cache vao RAM  
nen ban can clear Zend Opcache de thay doi duoc cap nhat. 

Chuc ban se thanh cong cung KPANEL .
END
# increase SSH login speed
if [ -f /etc/ssh/sshd_config ]; then 
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
fi
#Change default folder ssh login
#if [ -f /root/.bash_profile ]; then
#sed -i "/.*#\ .bash_profile.*/acd /home" /root/.bash_profile
#fi


cat > "/tmp/finishedemail.sh" <<END
#!/bin/bash 
echo -e 'Subject: KPANEL - Chuc mung cai dat thanh cong $svip!

Chao ban!

Chuc mung ban da hoan thanh qua trinh cai dat va cau hinh server $svip bang KPANEL.
Sau day la thong tin quan ly server cua ban:

+ Lenh goi KPANEL: kpanel
+ Link phpMyAdmin: http://$svip:$svport
+ Quan Ly Zend Opcache: http://$svip:$svport/ocp.php
+ Quan Ly Memcached: http://$svip:$svport/memcache.php
+ Xem Server Status: http://$svip/status.php
+ Thong tin dang nhap quan ly phpMyadmin,ocp.php, memcache.php, status.php, download backup files ... : 
Username: $usernamebv  
Password: $matkhaubv 

Luu Y:

+ Sau khi cai dat xong, neu server chua tao SWAP (RAM ao), ban tao them SWAP bang chuc nang [ Quan Ly Swap ] (Bat buoc).
+ De dat mat khau bao mat phpMyAdmin, backup files, ...: dung chuc nang [ BAT/TAT Bao Ve phpMyAdmin ] trong [ Quan Ly phpMyAdmin ]
+ De cai dat File Manager: Dung chuc nang [ Cai Dat File Manager ] 
+ Sau khi them website vao server, cai dat FTP server va tao tai khoan FTP cho tung website tren server bang chuc nang [ Quan Ly FTP Server ].
  Mac dinh ban khong the dang nhap FTP vao server bang tai khoan root. Neu muon dang nhap, ban phai dung sFTP voi thong tin dang nhap:
  Host: sftp://$svip  - User: root - Password: Your_password - Port: 22 (hoac port SSH ban da thay)
+ Neu server Timezone khong trung voi gio cua ban, cai dat lai time zone cho Server bang chuc nang [ Cai Dat Server Timezone ] trong [ Tien Ich - Addons ]
+ Sau khi Upload code len server. Ban phai chay chuc nang [ Fix Loi Chmod, Chown ] trong [ Tien Ich - Addons ] de thiet lap phan quyen cho website. 
  Neu website su dung code wordpress, thiet lap phan quyen cho website bang chuc nang [ Fix loi Permission ] trong [ Wordpress Blog Tools ]
+ Tuy theo so luong website, dung luong code ma ban cau hinh lai Zend Opcache, Memcached, Redis Cache bang chuc nang [ Quan Ly Memcached ], [ Quan Ly Zend Opcache ] , [ Quan Ly Redis Cache ] cho phu hop.
+ De bao mat, moi khi co dang nhap SSH va Server, KPANEL se gui email thong bao toi dia chi email $kpanelemail .
  Thay email hoac tat chuc nang nay bang [ BAT/TAT Email Thong Bao Login ] trong [ Tien ich - Addons ].  
  
KPANEL -- YOUR SUCCESS IS OUR SUCCESS - https://kdata.vn' | exim  $kpanelemail
END
chmod +x /tmp/finishedemail.sh
/tmp/finishedemail.sh
rm -f /tmp/finishedemail.sh
clear
echo "=========================================================================="
echo "KPANEL da hoan tat qua trinh cai dat Server. "
echo "=========================================================================="
echo "Lenh goi KPANEL: kpanel"
echo "--------------------------------------------------------------------------"
echo "Link phpMyAdmin: http://$svip:$svport"
echo "--------------------------------------------------------------------------"
echo "Quan Ly Zend Opcache: http://$svip:$svport/ocp.php"
echo "--------------------------------------------------------------------------"
#echo "Quan Ly Memcached: http://$svip:$svport/memcache.php"
#echo "--------------------------------------------------------------------------"
echo "Xem Server Status: http://$svip/status.php"
echo "--------------------------------------------------------------------------"
echo "Thong tin username & password bao ve phpMyAdmin, ocp.php, status.php ..."
echo "--------------------------------------------------------------------------"
echo "Username: $usernamebv  | Password: $matkhaubv"
echo "--------------------------------------------------------------------------"
echo "Thay thong tin dang nhap nay: KPANEL menu ==> User & Password Mac Dinh. "
echo "=========================================================================="
echo "Thong tin quan ly duoc luu tai: /home/KPANEL-manage-info.txt "
echo "--------------------------------------------------------------------------"
echo "va gui kem luu y su dung KPANEL toi: $kpanelemail"
echo "=========================================================================="
echo "Server se tu khoi dong lai sau 3 giay.... "
sleep 3
reboot
exit
