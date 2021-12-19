*** Settings ***
Documentation           *整个项目的公共参数配置文件*

*** Variables ***
${API_URL}              https://rmapi.bbxlk.cc          # API地址变量
${Sign}                 Ea1OWCAnQWD4GCijZ2ChEB83i+7MXQahK7/Kd9jrmYHi+rQ9PvalLOYWa5JIYep9QbOamIej1KEPuQvyKuhlN/DXpUB3YKjHTx6I+hk8nAd7F6J/y80IbZ5tVgptGhE2          # API签名字符串
@{Auth}                 kevin_tan          123456          # API用户认证变量
${Database_Addr}          18.179.129.254          # 数据库地址
${Database_Port}          3306          # 数据库端口
@{Database_Name}          rmapi          bsapi          # 数据库名 \ ${Database_Name[0]} 表示第一个
${Database_User}          test          # 数据库用户名
${Database_Passwd}          yfat7LAI7qHd          # 数据库密码

*** Keywords ***
