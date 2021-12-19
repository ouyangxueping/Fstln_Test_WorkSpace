*** Settings ***
Documentation           *移动端首页配置相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Test Cases ***
获取移动端首页配置信息
          [Documentation]          *获取移动端首页配置信息*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${shopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          获取移动端首页配置信息          ${API_URL}          ${shopId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Get_MobileSetttings_Home.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取APP版本信息
          [Documentation]          *获取APP版本信息*
          ...
          ...          *参数注意：*
          #创建参数
          ${list}          Create List          Android
          ${app_type}          Get Random Choice Number          ${list}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${app_type}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          获取APP版本信息          ${API_URL}          ${app_type}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_AppVersion.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions
