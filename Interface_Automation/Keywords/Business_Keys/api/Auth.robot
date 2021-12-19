*** Settings ***
Documentation           *API签名及签名验证接口*
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_Auth.txt

*** Test Cases ***
测试API是否调用正常
          [Documentation]          *测试API是否调用正常*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          ${data}          Create Dictionary          sign=${Sign}
          #数据库
          #请求
          ${responsedata}          测试API是否调用正常          ${API_URL}          ${data}
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Message}          Get From Dictionary          ${responsedata}          Message
          Delete All Sessions

获取Web站点地址
          [Documentation]          *获取Web站点地址*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          ${data}          Create Dictionary          sign=${Sign}
          #数据库
          #请求
          ${responsedata}          获取Web站点地址          ${API_URL}          ${data}
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          Delete All Sessions
          log          ${Data[0]}
          log          ${Data[1]}
          log          ${Data[2]}
          log          ${Data[3]}
          log          ${Data[4]}

检查APP是否需要更新
          [Documentation]          *检查APP是否需要更新*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          ${data}          Create Dictionary          sign=${Sign}
          #数据库
          #请求
          ${responsedata}          检查APP是否需要更新          ${API_URL}          ${data}
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          Delete All Sessions
          Run Keyword If          ${Value} == 0          log          不需要！
          ...          ELSE          log          有更新！
