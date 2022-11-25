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

cd fio || exit 1
#if [ $(uname -m) == "x86_64" ]
#then
sed -i '10 i\#include <sys/sysmacros.h>' diskutil.c
sed -i '8 i\#include <sys/sysmacros.h>' blktrace.c
#fi
./configure
make && make install
