# Copyright © 2020 Feature.su. All rights reserved. 
# Licensed under the Apache License, Version 2.0  

# Warning: disable --with-imagick in 30-compile-php-7.1.sh!  There is compile with new ImageMagick

yum -y install libwebp-devel

cd /tmp
wget https://imagemagick.org/download/releases/ImageMagick-6.9.11-43.tar.gz
tar -xvzf ./ImageMagick-6.9.11-43.tar.gz
cd ImageMagick-6.9.11-43
./configure
make
make install

cd /tmp
wget https://pecl.php.net/get/imagick-3.4.4.tgz
tar -xvzf ./imagick-3.4.4.tgz
cd imagick-3.4.4
/usr/local/php71/bin/phpize
./configure --with-imagick=/usr/local --with-php-config=/usr/local/php71/bin/php-config
make
make install

echo 'extension=imagick.so' > /usr/local/php71/etc/conf.d/imagick.ini

systemctl reload httpd
