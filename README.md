# OSPerformance

#### 介绍
Operating Systems performance Tool.

#### 软件架构
软件架构说明


#### 安装教程

1.  xxxx
2.  xxxx
3.  xxxx

#### 使用说明

1. stream:
   执行python3 stream.py可进行测试，测试结果存放在report/stream目录下。

2. fio:
   请确保运行环境中至少有2块磁盘，磁盘太小比如5G测试不了，（大于或等于110G可测），另外机器线程需大于等于16。修改fio.conf文件中修改指定硬盘名称，指定的空分区，不可使用系统盘，会使系统崩溃，执行 python3 fio.py进行测试，结果存放在热report/fio目录下。 

3. netperf:
  (1) 准备两台机器，一台作为server（测试机），一台作为client（被测机),两台机器均安装netperf，且防火墙关闭两台机器用网线直连，并手动设置ip，且网络互通（即：两台机器分别ping通对方的ip地址)（此处无直连物理机可实用一台机器上的两台虚拟机进行测试，这种方式可能网络不是很稳定，数据波动较大）。
  (2) 运行前安装automake和autoconf：
       U 系：sudo apt-get install automake autoconf
       R 系: sudo yum install automake autoconf
  (3) 把OSPformance分别放在服务端和客户端上，在服务端执行sh netperf_server.sh,在客户端中修改netperf.conf中的SERVERIP为服务端的IP地址，其中的RUMTIME可按照自己需求进行修改（单位：秒）。
  (4) 在客户端执行python3 netperf.py即可以进行测试,测试结果将存放在report/netperf目录下。

4. lmbench:安装libtirpc和libtirpc-devel，安装成功这两个软件之后执行cp /usr/include/tirpc/rpc/* /usr/include/rpc/ 和cp /usr/include/tirpc/netconfig.h /usr/include/，最后执行sh lmbench.sh进行测试，测试结果将存放在report/lmbench目录下。

5. unixbench：执行python3 unixbench.py 进行测试,测试结果将存放在report/unixbench目录下。

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
