#!/bin/bash

#########################################################
# Function :fio                              #
# Platform :Uniontech OS                                #
# Version  :1                                           #
# Date     :2021-08-29                                  #
# Author   :hanshuang                                     #
# Contact  :hanshuang@uniontech.com                       #
# Company  :Uniontech                                   #
#########################################################

#判断当前目录fio是否解压了，如果解压了就删除重新解压，保证环境干净
cd `pwd`/src/ || exit 1
if ls ./fio
then
    echo "fio已经被解压,即将帮你删除，然后重新解压"
    sleep 3
    rm  -r ./fio
else
    echo "fio软件包不存在，请检查是否被删除"
    sleep 2
fi

echo "即将解压"
unzip fio-master.zip
chmod -R 777 fio
mv fio-master fio

cd fio || exit 1
#if [ $(uname -m) == "x86_64" ]
#then
sed -i '10 i\#include <sys/sysmacros.h>' diskutil.c
sed -i '8 i\#include <sys/sysmacros.h>' blktrace.c
#fi
./configure
make && make install
