*** Settings ***
Documentation           *评论API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_ReviewApi.txt

*** Test Cases ***
评论点赞
          [Documentation]          *评论点赞*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${ReviewId}          Get From Dictionary          ${json_user_content}          ReviewId          #返回的是个列表
          ${ReviewId}          Set Variable          ${ReviewId[0]}          #默认只取第一个
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${SourceName}          Get From Dictionary          ${json_manager_content}          SourceName
          ${data}          Create Dictionary          userId=${userId}          shopId=${shopId}          shopName=${shopName}          storeId=${storeId}          storeName=${storeName}
          ...          videoId=${videoId}          videoName=${videoName}          ReviewId=${ReviewId}          sourceType=${sourceType}          sourceId=${sourceId}          SourceName=${SourceName}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${shopId}          ${shopName}          ${storeId}          ${storeName}
          ...          ${videoId}          ${videoName}
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          评论点赞          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp(None).json          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取我发出的评论数据
          [Documentation]          *获取我发出的评论数据*
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
          ${responsedata}          获取我发出的评论数据          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_Review_From_Me_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取回复我的评论数据
          [Documentation]          *获取回复我的评论数据*
          ...
          ...          *参数注意：*
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
          #GET请求
          ${responsedata}          获取回复我的评论数据          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_Review_From_Me_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

批量删除评论
          [Documentation]          *批量删除评论*
          ...
          ...          *表操作： azt_review 视频评论表，删除记录*
          ...
          ...          *参数注意：不明白 Ids 参数的意义,脚本中直接取空来处理的*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Get From Dictionary          ${json_user_content}          ReviewId
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${IdList}          ${Ids}
          #数据库
          #请求
          ${responsedata}          批量删除评论          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par}          Should Be True          ${Success} == False
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

批量设置评论为已读
          [Documentation]          *批量设置评论为已读*
          ...
          ...          *表操作： azt_review 视频评论表，更新 HasRead 字段为 1*
          ...
          ...          *参数注意：不明白 Ids 参数的意义,脚本中直接取空来处理的*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Get From Dictionary          ${json_user_content}          ReviewId
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${IdList}          ${Ids}
          #数据库
          #请求
          ${responsedata}          批量设置评论为已读          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par}          Should Be True          ${Success} == False
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
