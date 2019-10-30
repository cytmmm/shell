#!/bin/bash
#
#
#
dataDir=/mydata/
Dingding_Url="钉钉机器人url"


#向钉钉发送消息方法
function SendMessageToDingding(){
    # 发送钉钉消息
    curl "${Dingding_Url}" -H 'Content-Type: application/json' -d "
    {
     \"msgtype\":\"text\",
     \"text\":{\"content\":\"${Body}\"},
     \"at\":{\"atMobiles\":[\"133333333333\",\"133333333333\"],\"isAtAll\":false}
    }"
}

#查找最近一分钟内修改过的文件
files=$(find  $dataDir  -type f  -cmin 1 | grep jar)
if [[ -n $files ]]; then
    Body="不好了最近一分钟下列文件发生变动:$files"
    echo "$Body"
    #SendMessageToDingding $Body $Dingding_Url
fi
exit 0