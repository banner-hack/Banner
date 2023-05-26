#!/bin/sh

file_name=".gitignore"
script_dir=$(cd $(dirname $0); pwd)
destination=${script_dir}/${file_name}

# .gitがあればキャッシュを消す
if [ -d '.git' ]; then
	git rm -r --cached .
fi

echo "🚀🚀🚀 .gitignoreの作成を開始します 🚀🚀🚀"

curl -s https://raw.githubusercontent.com/lit-iphone-course/ios-gitignore/main/.gitignore >> ${destination}

echo "🚀🚀🚀 .gitignoreが正常に作成されました！ 🚀🚀🚀"
