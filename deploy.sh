#!/usr/bin/env bash
set -e
# 部署脚本
project=`basename $PWD`
compress=${project}.tar.gz
# node 依赖
echo "安装 Node 依赖...."
yarn install > /dev/null
# 编译 Assets
echo "编译 Assets...."
rm -rf public/packs
RAILS_ENV=production rake assets:precompile > /dev/null

ssh deploy@10.2.28.170 <<EOF
	if [[ -f ${compress} ]];then
		echo '服务器存在同名文件，脚本退出执行';
		exit 1;
	fi
EOF
# 上传项目
echo "开始压缩...."
cd ..
tar czf ${compress} ${project}
echo "开始上传...."
scp ${compress} deploy@10.2.28.170:~/
rm -rf ${compress}

# 登录服务器，执行远程脚本
echo "登录服务器中...."
cd ${project}
ssh deploy@10.2.28.170 "bash -s" < remote.sh ${project}

echo "部署成功"

echo "恢复本地环境"
yarn install
echo "恢复完成"