FROM mysql:8.0.19

ENV APP_HOME /root
# 备份文件名
ENV BAK_FILE=./*_qp.xb
# 解压数据目录
ENV UNPACK_DIR=$APP_HOME/unpack

WORKDIR $APP_HOME

# 将sources.list复制到镜像下的/etc/apt/下面，修改镜像源地址
COPY sources.list /etc/apt/

# 下载XtraBackup
RUN apt update && apt-get install axel wget -y 
#RUN axel -n 20 https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.12/binary/debian/stretch/x86_64/percona-xtrabackup-80_8.0.12-1.stretch_amd64.deb
COPY percona-xtrabackup-80_8.0.12-1.stretch_amd64.deb .
# 安装XtraBackup
RUN apt-get install libdbd-mysql-perl rsync libcurl4-openssl-dev libev4 -y
RUN dpkg -i --ignore-depends libcurl3 percona-xtrabackup-80_8.0.12-1.stretch_amd64.deb

# 下载qpress
COPY qpress-11-linux-x64.tar .
# 解压安装qpress
RUN tar xvf qpress-11-linux-x64.tar
RUN chmod 775 qpress
RUN cp qpress /usr/bin


# 拷贝备份文件
RUN mkdir -p $UNPACK_DIR
COPY $BAK_FILE .
# 备份文件解压
RUN cat $BAK_FILE | xbstream -x -v -C $UNPACK_DIR
RUN xtrabackup --decompress --remove-original --target-dir=$UNPACK_DIR
# 备份文件恢复
RUN xtrabackup --prepare --target-dir=$UNPACK_DIR
