*** Settings ***
Documentation           *话题相关接口API*
Force Tags              API-Automated
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                L1_Components.txt
Resource                ../../../Generic_Profiles.txt
Resource                L2_Keywords_TalkApi.txt

*** Test Cases ***
获取话题列表
          [Documentation]          *获取话题列表*
          ...
          ...          *参数注意：*
          #创建参数字典
          ${list}          Create List          0          1          #0.全部话题 1.精选话题
          ${Recommend}          Get Random Choice Number          ${list}
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          Recommend=${Recommend}          PageNo=${PageNo}          PageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Recommend}          ${PageNo}
          #数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          SELECT count(*) FROM \ azt_talk where OfflineTime>Now()
          ${Count}          Set Variable          ${Count[0][0]}
          ${Count1}          Query          SELECT COUNT(*) FROM azt_talk WHERE Recommend=1 and OfflineTime>Now()
          ${Count1}          Set Variable          ${Count1[0][0]}
          Disconnect From Database
          #POST请求
          ${responsedata}          获取话题列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #验证Total总数是否和数据库中一致
          ${Total}          Get From Dictionary          ${responsedata}          Total
          Run Keyword If          ${Count}==${Total} or ${Count1}==${Total}          log          查询结果一致
          ...          ELSE          fail          数据库中查询和接口返回的话题总数不一致！！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          获取成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Talk_List.json          Talk_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取话题的评论回复列表
          [Documentation]          *获取话题的评论回复列表*
          ...
          ...          *参数注意：（接口似乎有点问题，userid参数应该是过滤用户的话题评论，但接口返回的是所有用户的数据）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          3          #来源类型0.普通 1.专题 2.直播 3.话题 4.达人秀          #这里直接取3
          ${SourceType}          Get Random Choice Number          ${list}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalkId}          Get From Dictionary          ${json_user_content}          TalkId
          ${PageNo}          Get Range Number String          1          2
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          SourceType=${SourceType}          UserId=${UserID}          PageNo=${PageNo}          PageSize=${PageSize}          Id=${TalkId}
          ${have_not_pageno}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageNo}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageSize}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalkId}
          #数据库          取话题的评论总数和金山云地址
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          SELECT \ COUNT(*) FROM \ azt_review WHERE SourceType='${SourceType}' AND sourceid='${TalkId}'
          ${Count}          Set Variable          ${Count[0][0]}
          ${ImageServerUrl}          Query          SELECT a.value FROM azt_appsettings a WHERE a.key='ImageServerUrl'
          ${ImageServerUrl}          Set Variable          ${ImageServerUrl[0][0]}
          Disconnect From Database
          #POST请求
          ${responsedata}          获取话题的评论回复列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #验证Dada中ImagePath是否为金山云地址
          Run Keyword If          ${Data}!=[] and ${Data}!=None          验证接口返回的图片地址是否为金山云地址          ${Data[0]}          ${ImageServerUrl}
          ...          ELSE          log          Data无值返回！！
          Comment          ${type}          Evaluate          type(${Data[0]})          #查看数据类型
          #验证Total总数是否和数据库中一致
          ${Total}          Get From Dictionary          ${responsedata}          Total
          Run Keyword If          ${have_not_pageno}==False          验证接口返回total是否与数据库相同          ${Count}          ${Total}
          ...          ELSE          log          total返回为0
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          话题Id错误          话题Id错误          获取成功          Count 必须具有非负值。\r\n参数名: count          话题Id错误
          ...          话题Id错误          获取成功          获取成功
          ${Success_list}          Create List          False          False          True          False          False
          ...          False          True          True
          ${Json_list}          Create List          Talk_ReviewList.json          Talk_ReviewList.json          Talk_ReviewList.json          Talk_ReviewList.json          Talk_ReviewList.json
          ...          Talk_ReviewList.json          Talk_ReviewList.json          Talk_ReviewList.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_pageno}          ${have_not_par}          ${have_not_id}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_pageno}          ${have_not_par}          ${have_not_id}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_pageno}          ${have_not_par}          ${have_not_id}
          Delete All Sessions

获取话题详情评论列表
          [Documentation]          *获取话题详情评论列表*
          ...
          ...          *参数注意：（同“获取话题的评论回复列表”接口，userid参数没什么用处）*
          ...
          ...
          ...          *此接口统计的是话题一级评论数*
          ...
          ...
          ...          *“获取话题的评论回复列表”接口统计话题的所有评论数*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          3          #来源类型0.普通 1.专题 2.直播 3.话题 4.达人秀          #这里直接取3
          ${SourceType}          Get Random Choice Number          ${list}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalkId}          Get From Dictionary          ${json_user_content}          TalkId
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          SourceType=${SourceType}          UserId=${UserID}          PageNo=${PageNo}          PageSize=${PageSize}          Id=${TalkId}
          ${have_not_pageno}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageNo}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageSize}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalkId}
          #数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          SELECT COUNT(*) FROM \ azt_review WHERE SourceType='${SourceType}' AND sourceid='${TalkId}' AND reviewid=0
          ${Count}          Set Variable          ${Count[0][0]}
          Disconnect From Database
          #POST请求
          ${responsedata}          获取话题详情评论列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          log          ${Message}
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #验证Total总数是否和数据库中一致
          ${Total}          Get From Dictionary          ${responsedata}          Total
          Run Keyword If          ${have_not_pageno}==False          验证接口返回total是否与数据库相同          ${Count}          ${Total}
          ...          ELSE          log          total返回为0
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          话题Id错误          话题Id错误          获取成功          Count 必须具有非负值。\r\n参数名: count          话题Id错误
          ...          话题Id错误          获取成功          获取成功
          ${Success_list}          Create List          False          False          True          False          False
          ...          False          True          True
          ${Json_list}          Create List          Talk_List(ERR).json          Talk_List(ERR).json          Talk_List(ERR).json          Talk_List(ERR).json          Talk_List(ERR).json
          ...          Talk_List(ERR).json          Talk_DetailList.json          Talk_DetailList.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_pageno}          ${have_not_par}          ${have_not_id}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_pageno}          ${have_not_par}          ${have_not_id}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_pageno}          ${have_not_par}          ${have_not_id}
          Delete All Sessions

获取话题详情
          [Documentation]          *获取话题详情*
          ...
          ...          *参数注意：（只有话题id参数有用，其余参数无用）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          3          #来源类型0.普通 1.专题 2.直播 3.话题 4.达人秀          #这里直接取3
          ${SourceType}          Get Random Choice Number          ${list}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalkId}          Get From Dictionary          ${json_user_content}          TalkId
          ${data}          Create Dictionary          UserId=${UserID}          SourceType=${SourceType}          Id=${TalkId}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalkId}
          #数据库
          ${Talk_OK}          判断话题是否在线          ${TalkId}
          #POST请求
          ${responsedata}          获取话题详情          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          话题Id错误          话题Id错误          获取成功          暂无数据
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Talk_Detail(ERR).json          Talk_Detail(ERR).json          Talk_Detail.json          Talk_Detail(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_id}          ${Talk_OK}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_id}          ${Talk_OK}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_id}          ${Talk_OK}
          Delete All Sessions

添加话题点赞
          [Documentation]          *添加话题点赞*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：该接口同时用于话题点赞和达人秀点赞*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          3          4          #来源类型0.普通 1.专题 2.直播 3.话题 4.达人秀          #这里只取3和4
          ${SourceType}          Get Random Choice Number          ${list}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalkId}          Get From Dictionary          ${json_user_content}          TalkId
          ${TalentShowID}          Get From Dictionary          ${json_user_content}          TalentShowID
          ${ID}          Set Variable If          ${SourceType} == 3          ${TalkId}          ${TalentShowID}          #根据类型来选择使用哪个id
          ${data}          Create Dictionary          UserId=${UserID}          SourceType=${SourceType}          Id=${ID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ID}
          #数据库
          #POST请求
          ${responsedata}          添加话题点赞          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          话题Id错误          用户ID错误          话题Id错误          添加成功          #
          ...          # 未将对象引用设置到对象的实例。
          ${Success_list}          Create List          False          False          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_user}          ${have_not_id}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_user}          ${have_not_id}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_user}          ${have_not_id}
          Delete All Sessions
          #查询数据库记录，存在则删除
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${praisedid}          Query          SELECT id FROM azt_praisedpublic \ WHERE MemberId='${UserID}' AND SourceType='${SourceType}' AND SourceId='${ID}' ORDER BY praisedtime DESC
          Run Keyword If          '${praisedid}'!='[]'          Execute Sql String          DELETE FROM azt_praisedpublic \ WHERE \ id='${praisedid[0][0]}'
          ...          ELSE          log          数据库中不存在数据！无需删除！
          Disconnect From Database

添加话题评论
          [Documentation]          *添加话题评论*
          ...
          ...          *参数注意：（需要调用上传图片接口获取服务端的图片保存地址、评论的根节点取0或者取当前话题下的评论id（接口默认会将评论新增到当前话题下）、）*
          ...
          ...          *备注：接口的参数判断逻辑顺序为 话题id不能为空、userid不能为空、其余参数均不能为空*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${TalkReviewId}          Get From Dictionary          ${json_user_content}          TalkReviewId          #话题评论ID
          ${list1}          Create List          0          ${TalkReviewId}          #评论根节点ID，可以取0，也可以取话题下的评论
          ${AtRId}          Get Random Choice Number          ${list1}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalkId}          Get From Dictionary          ${json_user_content}          TalkId
          ${TopicName}          Get From Dictionary          ${json_user_content}          TalkName          #话题名称
          ${Content}          Get Random Chinese String          100
          ${ImageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\Talk_Photo1.jpg
          ${responsedata}          上传图片(话题接口)          ${API_URL}          ${ImageStreamString}
          ${image_path}          Get From Dictionary          ${responsedata}          Value
          ${Images}          Set Variable          ${image_path}          #将调用上传图片接口返回的路径传给iamges参数
          ${list2}          Create List          3          #来源类型0.普通 1.专题 2.直播 3.话题 4.达人秀          #这里直接取3
          ${SourceType}          Get Random Choice Number          ${list2}
          ${data}          Create Dictionary          AtRId=${AtRId}          UserId=${UserID}          Content=${Content}          TopicName=${TopicName}          Images=${Images}
          ...          SourceType=${SourceType}          Id=${TalkId}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Content}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalkId}
          #数据库
          #POST请求
          ${responsedata}          添加话题评论          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          话题Id错误          话题Id错误          话题Id错误          话题Id错误          用户ID错误
          ...          评论内容不能为空          用户ID错误          添加成功
          ${Success_list}          Create List          False          False          False          False          False
          ...          False          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_id}          ${have_not_user}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_id}          ${have_not_user}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_id}          ${have_not_user}          ${have_not_par}
          Delete All Sessions
          #查询数据库记录，存在则删除
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${reviewid}          Query          SELECT id FROM azt_review WHERE SourceType=3 AND ReviewContent='${Content}' AND Sourceid='${TalkId}' AND ReviewId='${AtRId}'
          Run Keyword If          '${reviewid}'!='[]'          Execute Sql String          DELETE FROM azt_review WHERE \ id='${reviewid[0][0]}'
          ...          ELSE          log          数据库中不存在数据！无需删除！
          Disconnect From Database

上传图片
          [Documentation]          *上传图片，返回图片在服务端保存的地址*
          ${ImageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\test.png
          log          ${ImageStreamString}
          ${responsedata}          上传图片(话题接口)          ${API_URL}          ${ImageStreamString}
          ${str1}          Get From Dictionary          ${responsedata}          Message
          ${str2}          Get From Dictionary          ${responsedata}          Success
          ${image_path}          Get From Dictionary          ${responsedata}          Value
          comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          上传成功
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(Value_String).json
          Validate Output Results          ${str1}          ${Message_list}
          Validate Output Results          ${str2}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions
