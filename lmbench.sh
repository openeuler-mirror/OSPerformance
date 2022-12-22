#!/bin/bash
#########################################################
# Function :lmbench automation script                   #
# Platform :Uniontech OS                                #
# Version  :1.0                                         #
# Date     :finshed for 2022-09-07                      #
# Author   :hanshuang                                   #
# Contact  :hanshuang@uniontech.com                     #
# Company  :UnionTech                                   #
#########################################################

#Source code acquisition and decompression
#Switch to the source package directory
cd `pwd`/src/ || exit 1
if [ -d "lmbench" ];then
	echo "已经存在lmbench，即将删除重新解压"
	rm -rf lmbench
	echo "delete lmbench return is $?"
else
    echo "不存在，即将解压lmbench"
    sleep 3
fi


#unzip the lmbench source package
unzip lmbench-master.zip 

mv lmbench-master lmbench
#Give permission
chmod -R 777 lmbench

echo "lmbench source code package decompressed successfully"

#Start an automated test run
cd lmbench || exit 2
echo "Switch successfully"
if [ -x "$(command -v apt-get)" ];
then
	command="make results"
else
	command="make results LDFLAGS=-ltirpc"
fi
#$ent_a variable is the enter key, custom made.
ent_a="\\n"

#$sc_b variable is input 1, custom made
sc_b="1\\n"

#The $size_c variable is the input parameter of 2048, custom made
size_c="1024\\n"

#The $sele_d variable is a customized input parameter no
sele_d="no\\n"

#Automatic interactive input of the above customized variables through the expect method
expect -c "

#Set the timeout period to 3000
set timeout 3000

#export use conventions
spawn $command;
sleep 1

#When recognized as the following characters, execute the carriage return action
expect \"MULTIPLE COPIES\"
send $ent_a

#When recognized as the following characters, perform the action of input 1
expect \"Job placement selection\"
send $sc_b

#When recognized as the following characters, perform the action of entering 2048
expect \"MB\"
send $size_c
sleep 6

#
#The following are all recognized as relevant characters, execute the carriage return action
#
expect \"SUBSET\"
send $ent_a
expect \"FASTMEM\"
send $ent_a
expect \"SLOWFS\"
send $ent_a
expect \"DISKS\"
send $ent_a
expect \"REMOTE\"
send $ent_a
expect \"Processor mhz\"
send $ent_a
expect \"FSDIR\"
send $ent_a
expect \"Status output file\"
send $ent_a

#When recognized as the following characters, perform the no action
expect \"Mail results\"
send $sele_d

#By convention
interact
"

#Get data file
make see > results/summary.out
data=`pwd`/results/summary.out
if [ ! -f "$data" ];
	then
	echo "-------------lmbench failed to run--------------------"
    exit -1
else
	echo "------------lmbench runs successfully-------"
fi

if [ -d "../../report/lmbench" ]; then
	rm -rf ../../report/lmbench
fi
mkdir ../../report/lmbench

#Copy the running results to the specified directory report
cp -r `pwd`/results/summary.out ../../report/lmbench

echo 3 > /proc/sys/vm/drop_caches
cd ../../ 
