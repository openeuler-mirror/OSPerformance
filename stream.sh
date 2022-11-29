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
if [ -d "STREAM" ]
then
    rm -rf  STREAM
    unzip STREAM-master.zip
else
    echo "请检查当前目录是否存在stream源码包"
    unzip STREAM-master.zip
fi
mv STREAM-master STREAM
#if ls src/STREAM exit 0
#then
#	rm -rf STREAM
#        git clone https://github.com/jeffhammond/STREAM.git
#else
#       	git clone https://github.com/jeffhammond/STREAM.git
#fi

cd STREAM
echo "chdir retrun is $?"
#取出cpu核数的值
if [ -x "$(command -v yum)" ]; 
then
       echo "r system"
       cpus=`sudo lscpu|grep -w "CPU:"|head -1|awk '{print$2}'`
       echo "cpu大小为：$cpus"
       L3Cache=`lscpu |grep -w "L3"|awk '{print$3}'`
       L3unit=`echo ${L3Cache: -1}`
       L3=`echo ${L3Cache%$L3unit}`
       echo "r系统三级缓存大小为：$L3"
       echo "三级缓存单位为：$L3unit"   
       

elif [ -x "$(command -v apt-get)" ]; 

then
	cpus=`sudo lscpu|grep -w "CPU(s):"|head -1|awk '{print$2}'`
       echo "d system"
       L3=`lscpu |grep -w "L3"|awk '{print$3}'`
       L3unit=`lscpu |grep -w "L3"|awk '{print$4}'`
       echo "d系统三级缓存大小为：$L3"
       echo "系统三级缓存单位为：$L3unit"
else	
	echo "请执行lscpu明令查看获取cpu的字段是啥，替换下一行命令中的CUP(CPUS(s)后重新执行"
	cpus=`sudo lscpu|grep -w "CPU(s)"|head -1|awk '{print$2}'`
fi
echo "a"

echo "cpu核数为：$cpus"

b=1024
if [ "$L3unit" = "K" ]
then
    size=`expr $cpus \* $L3 / $b \* 4 / 8 `
    echo "数组长度：$size "
else [ "$L3unit" = "MiB" ]
    size=`expr $cpus \* $L3 \* 4 / 8 `
    echo "数组长度：$size "
fi


if sed -i 94s/10000000/$size/g stream.c
then
	echo "change_size1 return is $?"
else
	echo "make the second times to test,no need to change the SIZE value."
fi
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
rm -rf ./stream
rm -rf stream_mu
#make
gcc -O2 -mcmodel=large stream.c -o stream
echo "-o stream return is $?"
gcc -O2 -mcmodel=large -fopenmp  stream.c -o stream_mu
echo "-o stream_mu return is $?"

./stream > ../../report/stream_results/单线程.txt
echo "single_test return is $?"
echo "结果成功写入单线程.txt"

#stream性能执行的结果输入到上层目录的满线程.txt文件中，并打印结果
./stream_mu > ../../report/stream_results/满线程.txt
echo "test_full return is $?"
echo "结果成功写入满线程.txt"

