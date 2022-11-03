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

#检查测试套是否存在，存在就删掉，主要是为了防止多次运行，数据混乱
if [ -a ./UnixBench ]
then
    echo "UnixBench已存在，删除！！"
    rm -rf ./UnixBench
fi

echo "正在解压"
tar -xvf UnixBench5.1.3-1.tar.bz2
echo "解压完成"


#进入测试套
cd UnixBench5.1.3-1 || exit 1

#取出cpu核数的值
cpus=`sudo lscpu|grep -w "CPU:"|head -1|awk '{print$2}'`
echo "$cpus"

sed -i 109s/128/$cpus/g  Run
echo "change_size1 return is $?"


#执行单核用例
echo "正在进行单核测试。。。"
if ./Run
then
     echo "测试完成"
else
     echo "测试失败"
fi

##将命令获取的cpu核数赋值给cpus
cpus=$(lscpu |grep "CPU:"| awk '{print $2}'|sed -n '1,1p')
#
执行满核用例
echo "正在进行满核测试。。。"
if ./Run -c "${cpus}"
then
     echo "满核测试完成"
else
     echo "满核测试失败"
fi


echo "清除缓存。。。"
if sync && echo 3 > /proc/sys/vm/drop_caches
then
     echo "清除缓存完成"
else
     echo "清除缓存失败"
fi


if [ -a ../../report/unixbench_results ]
then
    echo "Unixbench 旧的测试结果存在，即将删除"
    rm -rf ../../report/unixbench_results
fi

mkdir ../../report/unixbench_results
echo "正在将测试结果复制到report"
#复制测试结果到框架统一存放
cp  results/* ../../report/unixbench_results
cd ../../ || exit 1
rm -rf report/unixbench_results/*.html
rm -rf report/unixbench_results/*.log
echo "complete!"
