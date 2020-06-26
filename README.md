<h1 align="center">Percona Xtrabackup Docker</h1>

<div align="center">
Docker一键使用Xtrabackup工具恢复mysql备份文件到本地(以阿里云RDS为例, 备份格式*_qp.xb)
</div>

## 快速开始

1. 构建镜像运行容器
```
# 克隆代码
git clone git@github.com:piupuer/percona-xtrabackup-docker.git
cd percona-xtrabackup-docker
# 开始构建, 需要事先将数据压缩包文件(*_qp.xb)放入当前目录
docker-compose build
# 无缓存构建
# docker-compose build --no-cache

# 运行
docker-compose up
```

2. 拷贝数据文件  
将备份文件拷贝到挂载目录, Volume无法直接挂载自行生成的数据目录, 因此需要手动拷贝
```
# 进入容器内部
docker exec -it backup-mysql /bin/bash
# 拷贝数据unpack到bak目录
cp -r /root/unpack/. /root/bak
```

3. 停止容器
```
# 停止
docker-compose down
# 拷贝数据到mysql
rm -rf data/mysql
cp -r data/bak/. data/mysql
```

4. 重启容器, 用云端数据库用户名密码登录即可

## 阿里云帮助文档

如果版本有变化, 请看[官方文档](https://help.aliyun.com/knowledge_detail/41817.html)

## MIT License

    Copyright (c) 2020 piupuer
