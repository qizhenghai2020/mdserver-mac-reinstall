#! /bin/sh
export PATH=$PATH:/opt/local/bin:/opt/local/sbin:/opt/local/share/man:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin


DIR=$(cd "$(dirname "$0")"; pwd)
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
MDIR=$(dirname "$DIR")


mkdir -p $MDIR/source/openresty


VERSION=1.11.2.1

if [ ! -f $MDIR/source/openresty/openresty-${VERSION}.tar.gz ];then
	wget -O $MDIR/source/openresty/openresty-${VERSION}.tar.gz https://openresty.org/download/openresty-${VERSION}.tar.gz
fi

if [ ! -d $MDIR/source/openresty/openresty-${VERSION} ];then
	cd $MDIR/source/openresty && tar -zxvf $MDIR/source/openresty/openresty-${VERSION}.tar.gz
fi

cd $MDIR/source/openresty/openresty-${VERSION}


if [ ! -d $DIR/openresty ];then

make clean

./configure \
--prefix=$DIR/openresty \
--with-pcre=$MDIR/source/pcre \
--with-openssl=$MDIR/source/openssl \
--with-http_v2_module \
--with-http_stub_status_module

make && make install && make clean

fi

if [ ! -d $DIR/openresty/nginx/conf/vhost ];then
	mkdir -p $DIR/openresty/nginx/conf/vhost
	cp -rf $MDIR/bin/reinstall/tpl/openresty/vhost/ $DIR/openresty/nginx/conf/vhost/
fi

if [ ! -f $DIR/openresty/nginx/conf/nginx.tpl.conf ];then
	cp $MDIR/bin/reinstall/tpl/openresty/nginx.tpl.conf $DIR/openresty/nginx/conf/
	#default 55
	sed -i '_bak' "s#{VERSION}#55#g" $DIR/openresty/nginx/conf/nginx.tpl.conf
	rm -rf $DIR/openresty/nginx/conf/nginx.tpl.conf_bak
fi
