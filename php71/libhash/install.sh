#! /bin/sh

PATH=$PATH:/opt/local/bin:/opt/local/sbin:/opt/local/share/man:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin

DIR=$(cd "$(dirname "$0")"; pwd)
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
MDIR=$(dirname "$DIR")

VERSION=$1
LIBNAME=libhash
LIBV=1.0


echo "install $LIBNAME start"

sh $MDIR/bin/reinstall/check_common.sh $VERSION

extFile=$DIR/php/php$VERSION/lib/php/extensions/no-debug-non-zts-20160303/${LIBNAME}.so
rm -rf $extFile
isInstall=`cat $DIR/php/php$VERSION/etc/php.ini|grep '${LIBNAME}.so'`
if [ "${isInstall}" != "" ]; then
	echo "php-$VERSION 已安装${LIBNAME},请选择其它版本!"
	return
fi

if [ ! -f "$extFile" ]; then

	php_lib=$MDIR/source/php_lib
	mkdir -p $php_lib

	if [ ! -f $php_lib/${LIBNAME}-${LIBV}.tar.gz ]; then
		wget -O $php_lib/${LIBNAME}-${LIBV}.tar.gz https://github.com/midoks/libhash/archive/${LIBV}.tar.gz
		
	fi
	cd $php_lib/${LIBNAME}-${LIBV}

	if [ ! -d $php_lib/${LIBNAME}-${LIBV} ]; then
		cd $php_lib
		tar xvf ${LIBNAME}-${LIBV}.tar.gz
	fi

	cd $php_lib/${LIBNAME}-${LIBV}

	$DIR/php/php$VERSION/bin/phpize
	echo "$DIR/php/php$VERSION/bin/phpize"
	./configure --with-libhash --with-php-config=$DIR/php/php$VERSION/bin/php-config && \
	make && make install && make clean
fi

echo "install $LIBNAME end"
