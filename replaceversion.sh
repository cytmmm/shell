#!/bin/bash
#
#
#
#
printf "
#######################################################################
#                       批量修改项目版本号脚本                         #
#######################################################################
"


echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
CSI=$($echo  "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"



projectDir=/project
projects=$(ls $projectDir)
i=1

echo 'Please select project name:'
for project in $projects;do
    projectArray[$i]=${project}
    echo "\t${CMSG}$i${CEND}. ${project}"
    ((i++))
done
read -p "Please input a number:(Default 1 press Enter) " project_num
if [ -z ${projectArray[$project_num]} ];then
    echo "\t${CFAILURE}请输入正确的项目编号！${CEND}"
    exit 1
fi
project_name=${projectArray[$project_num]}
read -p "请输入${projectArray[$project_num]}的版本号" version
read -p "请输入${projectArray[$project_num]}的common版本号" common_version
read -p "请输入${projectArray[$project_num]}的interface版本号" interface_version
read -p "项目:$project_name 版本为${version} 确认吗？[y/n]" agree
if [[ ! ${agree} =~ ^[y,n]$ ]]; then
      echo "${CFAILURE}input error! Please only input 'y' or 'n'${CEND}"
else
    if [[ ${agree} == 'n' ]]; then
        exit 1
    fi
fi
read -p "是否需要为项目:$project_name 版本为${version} 创建新的release分支？[y/n]" release_yn
if [[ ! ${release_yn} =~ ^[y,n]$ ]]; then
      echo "${CFAILURE}input error! Please only input 'y' or 'n'${CEND}"
      exit 1
fi

pushd $projectDir/$project_name
git checkout develop
git pull -a
if [[ ${release_yn} == 'y' ]]; then
    git checkout -b release/$version
    if [[ $? -ne 0 ]]; then
       echo 项目:$project_name 版本为${version} 分支创建失败！
       exit 1
    fi
    else
    git checkout  release/$version
    if [[ $? -ne 0 ]]; then
       echo 项目:$project_name 版本为${version} 不存在对应分支
       exit 1
    fi
fi

#获取所有的pom文件
pomfiles=`find $projectDir/$project_name  -type f |grep pom.xml`
for pomfile in $pomfiles; do
lines=$(awk '{if($0~"1.0-SNAPSHOT")print}' $pomfile)
for line in $lines; do
    line=$(echo $line |sed 's/^[ \t]*//g')
    if [[ $line == '<version>1.0-SNAPSHOT</version>' ]]; then
        sed -i -e "s/<version>1.0-SNAPSHOT<\/version>/<version>$version<\/version>/" $pomfile
    elif [[ $line == '<wagu.convert.version>1.0-SNAPSHOT</wagu.convert.version>' ]]; then
        sed -i -e "s/<wagu.convert.version>1.0-SNAPSHOT<\/wagu.convert.version>/<wagu.convert.version>$common_version<\/wagu.convert.version>/" $pomfile
    elif [[ $line =~ "common" && ! $line =~ "interface"  ]]; then
        common_line=$(echo $line |sed "s/1.0-SNAPSHOT/$common_version/")
        line="${line//\//\\/}"
        common_line="${common_line//\//\\/}"
        sed -i -e  "s/$line/$common_line/" $pomfile
    else
        interface_line=$(echo $line |sed "s/1.0-SNAPSHOT/$interface_version/")
        line="${line//\//\\/}"
        interface_line="${interface_line//\//\\/}"
        sed -i -e "s/$line/$interface_line/" $pomfile
    fi
done
#不知道为啥sed会新建一个-e结尾的文件
if [[ -f $pomfile"-e" ]]; then

    rm -rf $pomfile"-e"
fi
done

#提交
if [[ ${release_yn} == 'y' ]]; then
git add .

git commit -m 'update version'

git push --set-upstream origin release/$version
fi
popd
exit 0



















