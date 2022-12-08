#!/bin/bash  
#########################################################
# Function :unixbench                                   #
# Platform :UnionTech OS                                #
# Version  :1.0                                         #
# Date     :2022-09-07                                 #
# Author   :binyanling                                    #
# Contact  :binyanling@uniontech.com                       #
# Company  :UnionTech                                   #
#########################################################

#进入测试工具目录
cd src || exit 1
if [ -d "byte-unixbench-master" ];then
	if [ -d "UnixBench" ];then
		rm -rf UnixBench
	fi
else
	unzip master.zip 
fi
cp -r byte-unixbench-master/UnixBench ./ 
#echo "cd src return is $?" 
chmod -R 777 UnixBench
#进入测试套
cd UnixBench || exit 1
#rm -rf results/*
#make clean

#取出cpu核数的值
if [ -x "$(command -v yum)" ];
then
       echo "r system"
       cpus=`sudo lscpu|grep -w "CPU:"|head -1|awk '{print$2}'`
       echo "cpu大小为：$cpus"
elif [ -x "$(command -v apt-get)" ];
then
       cpus=`sudo lscpu|grep -w "CPU(s):"|head -1|awk '{print$2}'`
       echo "d system"
       echo "cpu大小为：$cpus"
else
        echo "请执行lscpu明令查看获取cpu的字段，替换下一行命令中的CUP(CPUS(s)后重新执行"
        cpus=`sudo lscpu|grep -w "CPU(s)"|head -1|awk '{print$2}'` || exit 1
fi

sed -i 109s/16/$cpus/g  Run
echo "change_size1 return is $?"
chmod -R 777 Run

echo "正在进行满核测试。。。"
if ./Run -c 1 -c  $cpus
#if ./Run -c 1 -c 2
then
     echo "单核测试和满核测试完成"
else
     echo "测试失败"  || exit 1
fi


echo "清除缓存。。。"
if sync && echo 3 > /proc/sys/vm/drop_caches
then
     echo "清除缓存完成"
else
     echo "清除缓存失败"
fi


if [ -d ../../report/unixbench ];
then
    echo "Unixbench 旧的测试结果存在，即将删除"
    rm -rf ../../report/unixbench
fi

mkdir ../../report/unixbench
echo "正在将测试结果复制到report"
#复制测试结果到框架统一存放
cp  results/* ../../report/unixbench
cd ../../ || exit 1
#rm -rf report/unixbench_results/*.html
#rm -rf report/unixbench_results/*.log
#python3 unixbench1.py
echo "complete!"
