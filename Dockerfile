# centos6.8+阿里云yum源+ssh密码登录+常用软件
# 基于官方centos6.8镜像，https://c.163.com/hub#/m/repository/?repoId=2968
# ssh初始密码root，可用passwd命令修改
# 个人博客：https://4xx.me
FROM hub.c.163.com/library/centos:6.8
MAINTAINER https://4xx.me

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum install wget -y

# 更换阿里源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo

# 安装常用软件
RUN yum clean all
RUN yum install -y yum-plugin-ovl || true
RUN yum install -y vim tar wget curl rsync bzip2 iptables tcpdump less telnet net-tools lsof sysstat cronie passwd openssl openssh-server
RUN yum clean all
# 安装ssh
RUN yum install passwd openssl openssh-server -y
# RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
# RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
# RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd
# 安装htop
# RUN rpm -ivh http://mirrors.sohu.com/fedora-epel/epel-release-latest-6.noarch.rpm
# RUN yum install htop -y

RUN yum clean all
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
