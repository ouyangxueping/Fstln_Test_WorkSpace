*** Settings ***
Documentation           *平台公告API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_PlatformNoticeApi.txt

*** Test Cases ***
获取买家收到的平台公告列表
          [Documentation]          *获取买家收到的平台公告列表*
          ...
          ...          *参数注意：模板数据验证时，对于已读和未读的公告信息需要分开验证*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          9
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${is_read}          查询用户平台公告是否已读          ${userId}
          #GET请求
          ${responsedata}          获取买家收到的平台公告列表          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          None          None
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          True
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Get_PlatformNotice_List(IsRead).json          Get_PlatformNotice_List(NotRead).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${is_read}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${is_read}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${is_read}
          Delete All Sessions

获取公告详细信息
          [Documentation]          *获取公告详细信息*
          ...
          ...          *参数注意：(id参数为用户的平台公告id)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${PlatformnoticeId}          Query          select id from azt_platformnotice_user
          ${temp}          Get Random Choice Number          ${PlatformnoticeId}
          ${PlatformnoticeId}          Set Variable If          ${PlatformnoticeId}==[]          ${EMPTY}          ${temp[0]}
          Disconnect From Database
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PlatformnoticeId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          获取公告详细信息          ${API_URL}          ${PlatformnoticeId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_PlatformNotice_Detail.json
          Delete All Sessions

批量设置平台公告为已读
          [Documentation]          *批量设置平台公告为已读*
          ...
          ...          *参数注意：不明白 Ids 参数的意义,脚本中直接取空来处理的*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Get From Dictionary          ${json_user_content}          PlatformnoticeUserId
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${IdList}          ${Ids}
          #数据库
          #请求
          ${responsedata}          批量设置平台公告为已读          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Comment          Run Keyword If          ${have_not_par}          Should Be True          ${Success} == False
          Run Keyword If          ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par}          当参数都为空时，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

批量删除平台公告
          [Documentation]          *批量删除平台公告*
          ...
          ...          *参数注意：不明白 Ids 参数的意义,脚本中直接取空来处理的*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Get From Dictionary          ${json_user_content}          PlatformnoticeUserId
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${IdList}          ${Ids}
          #数据库
          #请求
          ${responsedata}          批量删除平台公告          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Comment          Run Keyword If          ${have_not_par}          Should Be True          ${Success} == False
          Run Keyword If          ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par}          当参数都为空时，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions
