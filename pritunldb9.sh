#!/bin/bash
# pritunl สำหรับ linux debien 9 เท่านั้น 

cd
# ติดตั้ง อะไรเล็กๆน้อยๆ
apt-get -y install ufw
apt-get -y install sudo
apt-get install dirmngr

# ตั้งเขตเวลา 
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# ติดตั้ง Pritunl mongodb server 
echo "deb http://repo.pritunl.com/stable/apt stretch main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get update
apt-get --assume-yes install pritunl mongodb-server
systemctl start mongodb pritunl
systemctl enable mongodb pritunl

# ติดตั้ง Squid 
apt-get -y install squid3
cp /etc/squid/squid.conf /etc/squid/squid.conf.orig
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/auiyhyo/vps2/master/squid.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid/squid.conf;
service squid restart

# เปิด Firewall
ufw allow 22,80,81,222,443,8080,9700,60000/tcp
ufw allow 22,80,81,222,443,8080,9700,60000/udp
yes | ufw enable

clear

# อ่านนิดนึง
echo "============#######==============="
echo "xxxxxxxxxxxx I NA HEE xxxxxxxxxxxx"
echo "ไม่เหมาะสำหรับมึงหรอก"
echo "ใช้กับ Debian 9 x64 "
echo "มัดรวม แบบ กรึ่งออโต้ by ....ใครวะ"
echo "ก้อปปี้ หรือ กดที่ url เพื่อใช้งาน : https://$MYIP"
echo "ก้อปปี้ คีย์ข้างล่างไว้เอาไว้ใส่หน้าเว็ป"
pritunl setup-key
echo "reboot vps ก่อนจะใช้งานล่ะ หรือไม่ไม่ก็แล้วแล้วแต่มึง"
echo "##########==================######"

rm pritunldb9.sh
