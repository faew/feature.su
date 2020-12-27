# Copyright © 2020 Feature.su. All rights reserved. 
# Licensed under the Apache License, Version 2.0  

# Warning: Install the databases and new icu-lib before you compile

yum -y groupinstall "Development Tools"
yum -y install httpd-devel
yum -y install zlib-devel openssl-devel sqlite-devel bzip2-devel
yum -y install openldap-devel libicu-devel libwebp-devel gmp-devel libXpm-devel libcurl-devel libicu-devel
yum -y install mysql-devel libxslt-devel mhash-devel libmcrypt-devel libpng-devel libxml2-devel
dnf -y --enablerepo=powertools install ImageMagick-devel

cd /tmp
wget -O php-7.1.tar.gz http://php.net/get/php-7.1.33.tar.gz/from/this/mirror
tar -xvzf ./php-7.1.tar.gz
cd php-7.1.33
cd ext
wget https://pecl.php.net/get/imagick-3.4.4.tgz
tar -xvzf ./imagick-3.4.4.tgz
mv imagick-3.4.4 imagick
cd ..
rm -f configure
./buildconf --force
./configure --prefix=/usr/local/php71 --with-ldap --with-libdir=lib64 --with-config-file-path=/usr/local/php71/etc --with-config-file-scan-dir=/usr/local/php71/etc/conf.d --with-apxs2 --enable-bcmath --with-bz2 --with-curl --enable-cgi --enable-filter --enable-pcntl --with-gd --with-mhash --enable-gd-native-ttf --with-freetype-dir --with-jpeg-dir --with-png-dir --with-webp-dir --enable-mbstring --with-mcrypt --enable-json --enable-mysqlnd --with-mysql-sock=/var/lib/mysql/mysql.sock --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-sqlite --disable-phpdbg --disable-phpdbg-webhelper --enable-opcache --with-openssl --enable-simplexml --with-xsl --with-sqlite3 --enable-xmlreader --enable-xmlwriter --enable-zip --enable-soap --with-zlib --with-imagick --enable-intl --with-icu-dir=/usr/
make

make install
mkdir /usr/local/php71/etc/conf.d
cp ./php.ini-production /usr/local/php71/etc/php.ini
echo 'zend_extension=opcache.so' > /usr/local/php71/etc/conf.d/opcache.ini
/usr/local/php71/bin/php -v

sed -i "s/short_open_tag = Off/short_open_tag = On/g" /usr/local/php71/etc/php.ini
sed -i "s/expose_php = On/expose_php = Off/g" /usr/local/php71/etc/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /usr/local/php71/etc/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 20M/g" /usr/local/php71/etc/php.ini
sed -i "s/;date.timezone =/date.timezone = UTC/g" /usr/local/php71/etc/php.ini
sed -i "s/;pcre.jit=1/pcre.jit=0/g" /usr/local/php71/etc/php.ini

sed -i "/php5_module/ d" /etc/httpd/conf/httpd.conf
systemctl reload httpd

setsebool -P httpd_execmem on
