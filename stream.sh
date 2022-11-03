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
echo `pwd`
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
cpus=`sudo lscpu|grep -w "CPU:"|head -1|awk '{print$2}'`
echo "cpu核数为：$cpus"

L3=`lscpu |grep -w "L3"|awk '{print$3}'`
echo "三级缓存大小为：$L3"
#model=`echo ${L3:%$model1}`
#echo "$model"
#判断单位
model1=`echo ${L3: -1}`
echo "三级缓存单位为：$model1"

L3cache=`echo ${L3%$model1}`
echo "三级缓存单位为K的值是$L3cache"
#model=`echo ${L3%$model1}`
#echo "$model"

if [ "$model1" = "K" ]
then
   # L3cache=`echo ${L3%$model1}`
   #echo "三级缓存单位为K的值是$L3cache"
   # L3cache=`expr $model \* $b` 
   # echo "$L3cache"
    size=`expr $cpus \* $L3cache / $b \* 4 / 8`
    echo "数组长度：$size"
else [ "$model1" = "MB" ]
    size=`expr $cpus \* $L3cache \* 4 / 8`
    echo "数组长度：$size"
fi
#b=1024
#cache=`dmidecode -t cache|grep "Installed Size"|awk '{print$3}' | tail -1`
#cachem=$(expr $cache / $b)
#echo "三级缓存单位为MB的值是$cachem"

sed -i 93s/9663676416/$size/g stream.c
echo "change_size1 return is $?"

#stream性能执行的结果输入到上上级别目录的单线程.txt文件中，并打印结果
if [ -d "../../report/stream_results" ] 
then
    echo "stream_results已经存在,即将帮你删除。"
    sleep 3
    rm  -r ../../report/stream_results
else
    echo "stream_results不存在"
    sleep 2
fi
mkdir ../../report/stream_results/

make

./stream >../../report/stream_results/单线程.txt
echo "single_test return is $?"
echo "结果成功写入单线程.txt"

#stream性能执行的结果输入到上层目录的满线程.txt文件中，并打印结果
./stream_mu >../../report/stream_results/满线程.txt
echo "test_full return is$?"
echo "结果成功写入满线程.txt"




