*** Settings ***
Documentation           *系统通知相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_SystemNotifApi.txt

*** Test Cases ***
获取系统通知列表
          [Documentation]          *获取系统通知列表*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #GET请求
          ${responsedata}          获取系统通知列表          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          获取成功
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_SystemNotice_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

系统消息批量更新已读
          [Documentation]          *系统消息批量更新已读*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Ids}          Get From Dictionary          ${json_user_content}          SystemNotice_Ids          #取到的是个列表
          ${SystemNotice_Ids}          Replace String          ${Ids}          [          ${EMPTY}          #用了个投巧的方法强制将列表转成字符串
          ${SystemNotice_Ids}          Replace String          ${SystemNotice_Ids}          ]          ${EMPTY}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${Ids}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          系统消息批量更新已读          ${API_URL}          ${SystemNotice_Ids}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          更新成功
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

删除系统消息
          [Documentation]          *删除系统消息*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Ids}          Get From Dictionary          ${json_user_content}          SystemNotice_Ids          #取到的是个列表
          ${SystemNotice_Ids}          Replace String          ${Ids}          [          ${EMPTY}          #用了个投巧的方法强制将列表转成字符串
          ${SystemNotice_Ids}          Replace String          ${SystemNotice_Ids}          ]          ${EMPTY}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${Ids}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          删除系统消息          ${API_URL}          ${SystemNotice_Ids}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          更新成功
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取系统通知详情
          [Documentation]          *获取系统通知详情（获取时通知更新为已读）*
          ...
          ...          *参数注意：(需要验证系统通知消息id是否已存在的情况)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Ids}          Get From Dictionary          ${json_user_content}          SystemNotice_Ids          #取到的是个列表
          ${SystemNotice_Ids}          Set Variable          ${Ids[0]}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${Ids}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${is_SystemNotice_Ids}          查询系统通知是否存在          ${SystemNotice_Ids}
          #GET请求
          ${responsedata}          获取系统通知详情          ${API_URL}          ${SystemNotice_Ids}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          获取成功          获取失败
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          False
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Get_SystemNotice_Details.json          ParameterError_Temp(Value).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${is_SystemNotice_Ids}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${is_SystemNotice_Ids}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${is_SystemNotice_Ids}
          Delete All Sessions
