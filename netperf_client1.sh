#!/bin/bash

#########################################################
# Function :cangkujiance                                #
# Platform :UnionTech OS                                #
# Version  :1.0                                         #
# Date     :2022-08-29                                  #
# Author   :hanshuang                                   #
# Contact  :hanshuang@uniontech.com                     #
# Company  :UnionTech                                   #
#########################################################

# 手动实现：
# #前置条件
# 1.准备两台机器，一台作为server（测试机），一台作为client（被测机）
#   两台机器均安装netperf，且防火墙关闭
#   两台机器用网线直连，并手动设置ip，且网络互通（即：两台机器分别ping通对方的ip地址）
# 2.上传netperf工具包到当前下
# 3.关闭audit服务
# 4.解压netperf-2.7.0.tar.gz
# 5.UDP_STREAM 需要在同一网段并且服务端和客户端选择加密必须都加密，选择手动配置都手动配置。

#判断当前目录fio是否解压了，如果解压了就删除重新解压，保证环境干净

#解压编译安装fio
#echo "即将解压"
cd src/netperf || exit 1
arch=`uname -m`
if [ $arch == "aarch64" ]
then    
	sh autogen.sh
	./configure --build=arm-linux
elif [ $arch == "x86_64" ]
then
	sh autogen.sh
	./configure
else
	echo "不知道的架构，请检查架构是否正确"
fi
make && make install
systemctl stop firewalld.service

Serverip=$1
runtime=$2
netperf -H $Serverip -l $runtime -t TCP_STREAM >> TCP_STREAM.txt
netperf -H $Serverip -l $runtime -t  UDP_STREAM >> UDP_STREAM.txt
netperf -H $Serverip -l $runtime -t TCP_RR >> TCP_RR.txt
netperf -H $Serverip -l $runtime -t TCP_CRR >> TCP_CRR.txt
netperf -H $Serverip -l $runtime -t UDP_RR >> UDP_RR.txt
netperf -H $Serverip -l $runtime -t omni -- -d rr -O "THROUGHPUT,THROUGHPUT_UNITS,MIN_LATENCY,MAX_LATENCY,MEAN_LATENCY" >> omni.txt

if ls ../../report/netperf_results
then
    echo "netperf_results已经存在,即将帮你删除。"
    sleep 3
    rm  -r ../../report/netperf_results
else
    echo "netperf_results软件包不存在，拷贝netperf测试结果。"
    sleep 2
fi

mkdir -p ../../report/netperf_results/
cp TCP_STREAM.txt ../../report/netperf_results/
cp UDP_STREAM.txt ../../report/netperf_results/
cp TCP_RR.txt ../../report/netperf_results/
cp TCP_CRR.txt ../../report/netperf_results/
cp UDP_RR.txt  ../../report/netperf_results/
cp omni.txt ../../report/netperf_results/

