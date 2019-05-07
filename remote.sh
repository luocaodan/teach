#!/usr/bin/env bash
set -e
# 服务端脚本 # rvm 环境
source ~/.profile
export RAILS_ENV=production
project=$1
compress=${project}.tar.gz

if [[ -d ${project} ]];then
	echo "服务器已存在该项目，开始更新...."
	cd ${project}
	if [[ -f ${project}/shared/pids/puma.pid ]];then
		pid=`cat shared/pids/puma.pid`
		if [[ -d /proc/${pid} ]];then
			kill ${pid}
		fi
	fi
	if [[ -f ${project}/shared/pids/sidekiq.pid ]];then
		pid=`cat shared/pids/sidekiq.pid`
		if [[ -d /proc/${pid} ]];then
			kill ${pid}
		fi
	fi
	cd ..
	# 删除存在的项目
	rm -rf ${project}
fi

# 解压
echo "开始解压...."
tar xzf ${compress}
rm -rf ${compress}

cd ${project}
# ruby 依赖
echo "安装 Ruby 依赖...."
bundle install > /dev/null
# 创建数据库
bundle exec rake db:create
# 数据库迁移
echo "运行数据库迁移...."
bundle exec rails db:migrate > /dev/null

# 更新 cron jobs
whenever -i

# 创建必要文件夹
mkdir -p shared/log shared/pids shared/sockets

# 运行服务器
echo "启动服务器...."
puma

# 启动 sidekiq
echo "启动 sidekiq"
bundle exec sidekiq -d -e production

echo "服务器启动成功"