*** Settings ***
Documentation           *评论点赞相关API*
...
...                     *过滤标记：‘公共点赞接口’ *
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_PraisedApi.txt

*** Test Cases ***
我收到的评论赞列表
          [Documentation]          *我收到的评论赞列表*
          ...
          ...          *参数注意：(XXX)*
          ...
          ...          *备注：返回结果模板验证中去掉了 LatestPraisedTime 的验证*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${userId}          Set Variable          633
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          我收到的评论赞列表          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          PraisedReview_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

评论赞标记为已读
          [Documentation]          *评论赞标记为已读*
          ...
          ...          *表操作：azt_praisedreview 评论点赞表，根据 ReviewId 更新 IsRead 字段为 1*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ReviewId}          Get From Dictionary          ${json_user_content}          ReviewId          #取到的是个列表，从这个列表内再随机取一个值
          ${ReviewId}          Get Random Choice Number          ${ReviewId}
          ${LatestPraisedTimeString}          Set Variable          2016-7-27 11:33:00
          ${data}          Create Dictionary          ReviewId=${ReviewId}          LatestPraisedTimeString=${LatestPraisedTimeString}
          ${data}          Create List          ${data}          #将字典填入个列表内
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${ReviewId}          ${LatestPraisedTimeString}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          评论赞标记为已读          ${API_URL}          ${data}
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

批量删除评论赞
          [Documentation]          *批量删除评论赞*
          ...
          ...          *表操作： azt_review 视频评论表，根据 ID 更新 IsPraisedDelete 字段为 1*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ReviewId}          Get From Dictionary          ${json_user_content}          ReviewId          #取到的是个列表，从这个列表内再随机取一个值
          ${IdList}          Get Random Choice Number          ${ReviewId}
          ${data}          Create Dictionary          IdList=${IdList}          sign=${Sign}
          #数据库
          #请求
          ${responsedata}          批量删除评论赞          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

公共点赞接口
          [Documentation]          *公共点赞接口*
          ...
          ...          *参数注意：点赞 SourceType:0=普通，1=专题，2=直播，3=话题，4=达人秀 SourceId: 对应type的唯一Id，例如SourceType=2，则SourceId为LiveRoomId*
          ...
          ...          *备注：应该是不包括达人推荐点赞*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${MemberId}          Get From Dictionary          ${json_user_content}          UserID
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${PraisedTime}          Set Variable          2016-7-27 11:33:00
          ${data}          Create Dictionary          MemberId=${MemberId}          SourceType=${SourceType}          SourceId=${SourceId}          PraisedTime=${PraisedTime}          sign=${Sign}
          #数据库
          ${have_user}          查询用户是否已点赞          ${MemberId}          ${SourceType}          ${SourceId}
          #请求
          ${responsedata}          公共点赞接口          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          已经点赞          点赞成功
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}
          Delete All Sessions

*** Keywords ***
