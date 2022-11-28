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
# 第一个参数为测试的硬盘比如/dev/sda
# 第二个参数为运行时间可以为数字
DIRPATH=`pwd`
cd $DIRPATH/src/ || exit 1
#if ls ./fio
#then
#	cd ./fio
#else
#    echo "fio软件包不存在，请检查是否被删除"
#    sleep 2
#fi
if [-d "fio"]
then
	rm -rf fio
	git clone https://github.com/axboe/fio
else
	git clone https://github.com/axboe/fio
fi

FILENAME=$1
RUNTIME=$2

#     #顺序读，顺序写，随机读写，顺序读写各运行一次
mkdir -p ./fio_result/4k
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=write -direct=1 -buffered=0 -thread -size=110g -bs=4k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=write > ./fio_result/4k/write_4k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=read -direct=1 -buffered=0 -thread -size=110g -bs=4k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=read > ./fio_result/4k/read_4k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randwrite -direct=1 -buffered=0 -thread -size=110g -bs=4k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randwrite > ./fio_result/4k/randwrite_4k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randread -direct=1 -buffered=0 -thread -size=110g -bs=4k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randread > ./fio_result/4k/randread_4k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randrw -rwmixwrite=70 -direct=1 -buffered=0 -thread -size=110g -bs=4k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randrw > ./fio_result/4k/randrw_mixwrite_70_4k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randrw -rwmixread=70 -direct=1 -buffered=0 -thread -size=110g -bs=4k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randrw > ./fio_result/4k/randrw_mixread_70_4k.txt
# #复制4k测试到report目录，并打印出cp命令执行的结果
if ls ../../report/fio_result/4k/
then
	echo "fio_result/4k/已经存在,即将帮你删除。"
	sleep 3
	rm  -r ../../report/fio_result/4k/
else
	echo "fio_result/4k/软件包不存在，拷贝fio测试结果。"
	sleep 2
fi
mkdir -p  ../../report/fio_result
cp -r fio_result/4k ../../report/fio_result
echo "cp retrun is $?"
     
mkdir -p ./fio_result/128k
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=write -direct=1 -buffered=0 -thread -size=110g -bs=128k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=write > ./fio_result/128k/write_128k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=read -direct=1 -buffered=0 -thread -size=110g -bs=128k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=read > ./fio_result/128k/read_128k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randwrite -direct=1 -buffered=0 -thread -size=110g -bs=128k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randwrite > ./fio_result/128k/randwrite_128k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randread -direct=1 -buffered=0 -thread -size=110g -bs=128k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randread > ./fio_result/128k/randread_128k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randrw -rwmixwrite=70 -direct=1 -buffered=0 -thread -size=110g -bs=128k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randrw > ./fio_result/128k/randrw_mixwrite_70_128k.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randrw -rwmixread=70 -direct=1 -buffered=0 -thread -size=110g -bs=128k -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randrw > ./fio_result/128k/randrw_mixread_70_128k.txt
# #复制128k测试到report目录，并打印出cp命令执行的结果
if ls ../../report/fio_result/128k/
then
        echo "fio_result/128k/已经存在,即将帮你删除。"
        sleep 3
        rm  -r ../../report/fio_result/128k/
else
        echo "fio_result/128k/软件包不存在，拷贝fio测试结果。"
        sleep 2
fi
cp -r fio_result/128k ../../report/fio_result
echo "cp retrun is $?"

mkdir -p ./fio_result/1M
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=write -direct=1 -buffered=0 -thread -size=110g -bs=1M -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=write > ./fio_result/1M/write_1M.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=read -direct=1 -buffered=0 -thread -size=110g -bs=1M -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=read > ./fio_result/1M/read_1M.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randwrite -direct=1 -buffered=0 -thread -size=110g -bs=1M -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randwrite > ./fio_result/1M/randwrite_1M.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randread -direct=1 -buffered=0 -thread -size=110g -bs=1M -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randread > ./fio_result/1M/randread_1M.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randrw -rwmixwrite=70 -direct=1 -buffered=0 -thread -size=110g -bs=1M -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randrw > ./fio_result/1M/randrw_mixwrite_70_1M.txt
sync && echo 3 > /proc/sys/vm/drop_caches
fio -filename=$FILENAME -ioengine=psync -time_based=1 -rw=randrw -rwmixread=70 -direct=1 -buffered=0 -thread -size=110g -bs=1M -numjobs=16 -iodepth=1 -runtime=$RUNTIME -lockmem=1G -group_reporting -name=randrw > ./fio_result/1M/randrw_mixread_70_1M.txt
# #复制1M测试到report目录，并打印出cp命令执行的结果
if ls ../../report/fio_result/1M/
then
        echo "fio_result/1M/已经存在,即将帮你删除。"
        sleep 3
        rm  -r ../../report/fio_result/1M/
else
        echo "fio_result/1M/软件包不存在，拷贝fio测试结果。"
        sleep 2
fi
cp -r fio_result/1M ../../report/fio_result
echo "cp retrun is $?"
cd $DIRPATH

