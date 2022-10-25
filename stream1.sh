#!/bin/bash
#########################################################
# Function :stream test                               #

# Platform :Uniontech OS                              #

# Version  :20                                        #

# Date     :2022-09-07                                #

# Author   :binyanling                                #

# Contact  :binyanling@uniontech.com                  #

# Company  :Uniontech                                 #
#########################################################

#进入src目录
cd src/

#判断stream目录是否存在，如果存在就删除并且打印目录被删除
if [ -d "stream-5.10-1" ]
then
    rm -rf stream-5.10-1
    echo "删除当前目录已解压的stream-5.10-1文件"
fi

#解压当前src目录下的stream.zip，并且打印出unzip命令的执行结果
tar -jxvf stream-5.10-1.tar.bz2
echo "tar retrun is $?"

#进入到stream目录,并打印出cd命令执行的结果
cd stream-5.10-1
echo "cd return is $?"


#取出cpu核数的值
cpus=`sudo lscpu|grep -w "CPU(s)"|head -1|awk '{print$2}'`

#用命令获取model name 且判断单位
model=`lscpu |grep -w "Model name"|awk '{print$3}'`
# model1=`lscpu |grep -w "L3 cache"|awk '{print$3}'`
# i=$((${#model}-1))
# model2=`echo ${model:$i:1}`

#获取架构类型
b=1024
name=$(dpkg --print-architecture)
name1="amd64"
name2="arm64"
name3="mips64el"
name4="loongarch64"

#获取当前位置
location=$(pwd)
# pwd

#判断当前架构类型

if [ "$name" = "$name1" ]
then
    cpul=`sudo dmidecode -t cache|grep "Installed Size"|awk '{print$3}'|wc -l`
    if [ "$cpul" = "3" ]
    then
        cache=`dmidecode -t cache|grep "Installed Size"|awk '{print$3}' | tail -1`
        cachem=$(expr $cache / $b)
        echo "三级缓存单位为MB的值是$cachem"
        size=`expr $cachem \* $cpus \* 4100000`
        size1=`expr $size / 8`
    else
        cache=`dmidecode -t cache|grep "Installed Size"|awk '{print$3}' | tail -1`
        cache1=`expr $cache \* 2`
        cachem=$(expr $cache1 / $b)
        echo "三级缓存单位为MB的值是$cachem"
        size=`expr $cachem \* $cpus \* 4100000`
        size1=`expr $size / 8`
    fi
elif [ "$name" = "$name2" ]
then
    str=`lscpu |grep -w "Model name"|awk '{print$3}'`
    model=`echo ${str%-*}`
    if [ "$model" = "FT" ]
    then
        cache=`dmidecode -t cache|grep "Installed Size"|awk '{print$3}' | tail -1`
        cachem=$(expr $cache / $b)
        echo "三级缓存单位为MB的值是$cachem"
        size=`expr $cachem \* $cpus \* 4100000`
        size1=`expr $size / 8`
    elif [ "$model" = "S2500" ];then
        size1=131200000
    else
        cache=`dmidecode -t cache|grep "Installed Size"|awk '{print$3}' | tail -1`
        cache1=`expr $cache \* 2`
        cachem=$(expr $cache1 / $b)
        echo "三级缓存单位为MB的值是$cachem"
        size=`expr $cachem \* $cpus \* 4100000`
        size1=`expr $size / 8`
    fi

elif [ "$name" = "$name3" ]||[ "$name" = "$name4" ]
then
    # cache=`lscpu |grep -w "L3 cache"|awk '{print$3}'`
    #cache1=`echo $cache|sed 's/.$//'`
    #cachem=$(expr $cache1 / $b)
    # echo "三级缓存单位为MB的值是$cache"
    # size=`expr $cache \* $cpus \* 4100000`
    size1=65600000
    echo "mipse的Array size为固定值"
else
    echo '请确认当前系统架构是否支持'
    exit
fi

#把取得的size1值写入stream.c文件
sed -i 94s/9663676416/$size1/g stream.c
echo "change_size1 return is $?"

#获取架构类型
#如果是龙芯执行第一条命令，其他平台执行第二条命令
#gcc -O3编译器优化级别 ，DSTREAM_ARRAY_SIZE=20000000指定计算中a[],b[],c[]数组的大小
#name=$(dpkg --print-architecture)
if [ "$name" = "$name3" ]
then
    gcc -O3 -DNTIMES=30 stream.c -o stream
else
    gcc -O3 -DNTIMES=30 -mcmodel=large stream.c -o stream
fi


#stream性能执行的结果输入到上层目录的单线程.txt文件中，并打印结果
./stream >../../单线程.txt
echo "single_test return is $?"
echo "结果成功写入单线程.txt"

#如果是龙芯执行第一条命令，其他平台执行第二条命令
#gcc -O3编译器优化级别 ，-fopenmp 提供多线程支持，DSTREAM_ARRAY_SIZE=20000000指定计算中a[],b[],c[]数组的大小
if [ "$name" = "$name3" ]
then
    gcc -O3 -fopenmp -DNTIMES=30 stream.c -o stream
else
    #gcc -O3 -fopenmp -DNTIMES=30 -mcmodel=large stream.c -o stream
    make
    echo "gcc is retrun $?"

fi

#stream性能执行的结果输入到上层目录的满线程.txt文件中，并打印结果
./stream_mu >../../满线程.txt
echo "test_full return is$?"
echo "结果成功写入满线程.txt"

#返回到上上层目
cd ../../

echo "删除report目录下stream_results下的旧的测试结果"
rm -rf report/stream_reults/*
#复制单线程.txt到当前report目录，并打印出cp命令执行的结果
#mkdir stream_results
cp 单线程.txt report/stream_results
echo "cp retrun is $?"

#复制满线程.txt到当前report目录，并打印出cp命令执行的结果
cp 满线程.txt report/stream_results
echo "cp retrun is $?"


#cp stream_results/* ../../report/stream_results/

#执行stream.py脚本
#python stream.py

#删除当前目前的单线程.txt 满线程.txt，并打印出rm命令执行的结果
#rm -rf 单线程.txt 满线程.txt
#echo "rm -rf retrun is $?"

#清除缓存
#sync && echo 3 > /proc/sys/vm/drop_caches
#echo "缓存清除成功"
