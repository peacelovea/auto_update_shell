#!/bin/bash

delete_directory() {
  local directory=$1
  if [ -d "$directory" ]; then
    rm -rf "$directory" && echo "Step: 删除 $directory 目录成功" || echo "Step: 删除 $directory 目录失败"
  else
    echo "Step: $directory 目录不存在，无需删除"
  fi
}

delete_file() {
  local file=$1
  if [ -e "$file" ]; then
    rm "$file" && echo "Step: 删除 $file 文件成功" || echo "Step: 删除 $file 文件失败"
    sed -i $'s/\r*$/\r/' $file
  else
    echo "Step: $file 文件不存在，无需删除"
  fi
}

# 获取当前分支
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 定义要执行的脚本
script_path="your_script.sh"

# 定义分支列表
branches=("branch_name_1" "branch_name_2" "branch_name_3" ...)

# Step 1: 删除node_modules目录
delete_directory "node_modules"

# Step 2: 删除package-lock.json文件
delete_file "package-lock.json"

# Step 3: 删除yarn.lock文件
delete_file "yarn.lock"

# Step 4: 修改.npmrc文件
echo "registry=http://artifactory.hundsun.com/artifactory/api/npm/es2-npm-virtual/" > .npmrc && echo "Step: .npmrc文件修改成功" || echo "Step: 修改 .npmrc 文件失败"
sed -i $'s/\r*$/\r/' .npmrc

# Step 5: 修改.yarnrc文件
echo 'registry "http://artifactory.hundsun.com/artifactory/api/npm/es2-npm-virtual/"' > .yarnrc && echo "Step: .yarnrc文件修改成功" || echo "Step: 修改 .yarnrc 文件失败"
sed -i $'s/\r*$/\r/' .yarnrc

# Step 6: 修改package.json中的devDependencies
if [ -e "package.json" ]; then
  sed -i 's/"@winner-fed\/winner-deploy": "[^"]*"/"@winner-fed\/winner-deploy": "^3.0.0"/' package.json && echo "Step: package.json文件修改成功" || echo "Step: 修改 package.json 文件失败"
  sed -i $'s/\r*$/\r/' package.json
else
  echo "Step: package.json文件不存在"
fi

# Step 7: 执行npm i
echo "Step 7: 执行命令 npm install"
npm install || npm install --legacy-peer-deps && echo "Step: npm install执行完成" || echo "Step7: npm install时发生错误"
