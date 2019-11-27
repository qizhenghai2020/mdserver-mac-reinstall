#! /bin/sh

PATH=$PATH:/opt/local/bin:/opt/local/sbin:/opt/local/share/man:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin

DIR=$(cd "$(dirname "$0")"; pwd)
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
MDIR=$(dirname "$DIR")

VERSION=$1
LIBNAME=nsq
EXT_VERSION=no-debug-non-zts-20190902
LIBV=3.4.1

#check
TMP_PHP_INI=/tmp/t_tmp_php.ini
TMP_CHECK_LOG=/tmp/t_check_php.log

echo "extension=$LIBNAME.so" > $TMP_PHP_INI
$DIR/php/php$VERSION/bin/php -c $TMP_PHP_INI -r 'phpinfo();' > $TMP_CHECK_LOG
FIND_IS_INSTALL=`cat  $TMP_CHECK_LOG | grep "nsq support"`

echo "install $LIBNAME start"

rm -rf $TMP_PHP_INI
rm -rf $TMP_CHECK_LOG
if [ "$FIND_IS_INSTALL" != "" ]; then
	echo "install $LIBNAME end"	
	exit 0
fi

sh $MDIR/bin/reinstall/check_common.sh $VERSION

extFile=$DIR/php/php$VERSION/lib/php/extensions/${EXT_VERSION}/${LIBNAME}.so

if [ -f  $extFile ]; then
	rm -rf $extFile
fi

isInstall=`cat $DIR/php/php$VERSION/etc/php.ini|grep '${LIBNAME}.so'`
if [ "${isInstall}" != "" ]; then
	echo "php-$VERSION 已安装${LIBNAME},请选择其它版本!"
	return
fi

LIB_DEPEND_DIR=`brew info libevent | grep /usr/local/Cellar/libevent | cut -d \  -f 1 | awk 'END {print}'`

echo "$LIBNAME-DIR:"
echo $LIB_DEPEND_DIR

if [ ! -f "$extFile" ]; then

	php_lib=$MDIR/source/php_lib
	mkdir -p $php_lib

	if [ ! -f $php_lib/${LIBNAME}-${LIBV}.tgz ]; then
		wget -O $php_lib/${LIBNAME}-${LIBV}.tgz http://pecl.php.net/get/${LIBNAME}-${LIBV}.tgz
		
	fi

	if [ ! -d $php_lib/${LIBNAME}-${LIBV} ]; then
		cd $php_lib
		tar xvf ${LIBNAME}-${LIBV}.tgz
	fi

	cd $php_lib/${LIBNAME}-${LIBV}

	$DIR/php/php$VERSION/bin/phpize

	echo "./configure --with-php-config=$DIR/php/php$VERSION/bin/php-config --with-nsq --with-libevent-path=$LIB_DEPEND_DIR"
	./configure --with-php-config=$DIR/php/php$VERSION/bin/php-config \
	--with-nsq \
	--with-libevent-path=$LIB_DEPEND_DIR && \
	make clean && make && make install  && make clean
fi

echo "install $LIBNAME end"
