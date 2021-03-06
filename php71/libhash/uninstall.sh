#! /bin/sh

PATH=$PATH:/opt/local/bin:/opt/local/sbin:/opt/local/share/man:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin

DIR=$(cd "$(dirname "$0")"; pwd)
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
DIR=$(dirname "$DIR")
MDIR=$(dirname "$DIR")

VERSION=$1
LIBNAME=libhash

extFile=$DIR/bin/php/php$VERSION/lib/php/extensions/no-debug-non-zts-20160303/${LIBNAME}.so

if [ -f $extFile ]; then
	rm -rf $extFile
	echo "uninstall $LIBNAME ok"
	exit 1
fi