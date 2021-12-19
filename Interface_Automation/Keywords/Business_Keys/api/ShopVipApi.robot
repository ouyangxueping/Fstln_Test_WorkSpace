*** Settings ***
Documentation           *店铺会员相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_ShopVipApi.txt

*** Test Cases ***
领取店铺会员卡
          [Documentation]          *领取店铺会员卡*
          ...
          ...          *参数注意：(XXX)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${VipCardModelId}          Get From Dictionary          ${json_user_content}          VipCardModelId
          ${data}          Create Dictionary          VipCardModelId=${VipCardModelId}
          ${have_not_par}          Validate Input Parameters          V          ${data}          #判断输入参数是否有空值
          #数据库
          #请求
          ${responsedata}          领取店铺会员卡          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          领取成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

获取用户店铺会员卡列表(GET)
          [Documentation]          *获取用户店铺会员卡列表(GET)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          5
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #GET请求
          ${responsedata}          获取用户店铺会员卡列表(GET)          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          ${Total}          Get From Dictionary          ${responsedata}          Total          #这里取的是服务器返回值，正常应该取数据库查询值。后面再修改
          ${status}          Run Keyword And Return Status          Should Be True          ${PageNo} < ${Total}
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          已经是最后一页          已经是最后一页          已经是最后一页
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          Get_ShopVipCard_List.json          Get_ShopVipCard_List.json          Get_ShopVipCard_List.json          Get_ShopVipCard_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${status}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${status}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${status}
          Delete All Sessions

获取用户店铺会员卡列表(POST)
          [Documentation]          *获取用户店铺会员卡列表(POST)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          5
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #GET请求
          ${responsedata}          获取用户店铺会员卡列表(POST)          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          ${Total}          Get From Dictionary          ${responsedata}          Total          #这里取的是服务器返回值，正常应该取数据库查询值。后面再修改
          ${status}          Run Keyword And Return Status          Should Be True          ${PageNo} < ${Total}
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          已经是最后一页          已经是最后一页          已经是最后一页
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          Get_ShopVipCard_List.json          Get_ShopVipCard_List.json          Get_ShopVipCard_List.json          Get_ShopVipCard_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${status}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${status}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${status}
          Delete All Sessions
