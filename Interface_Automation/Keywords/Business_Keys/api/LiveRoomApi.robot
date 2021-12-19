*** Settings ***
Documentation           *直播间相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_LiveRoomApi.txt

*** Test Cases ***
获取直播列表
          [Documentation]          *获取直播列表*
          ...
          ...          *参数注意：(XXX)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          1          2          3          #直播状态：1待直播，2直播中，3直播结束
          ${status}          Get Random Choice Number          ${list}
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取直播列表          ${API_URL}          ${status}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          LiveRoom_List.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取直播间信息
          [Documentation]          *获取直播间信息*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${liveRoomId}          Get From Dictionary          ${json_manager_content}          LiveID
          ${batch}          Set Variable          1
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${liveRoomId}
          #数据库
          ${have_liveRoom}          查询直播是否存在          ${liveRoomId}
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          获取直播间信息          ${API_URL}          ${liveRoomId}          ${batch}          ${userId}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_liveRoom} or not ${have_user}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          LiveRoom_Show.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取直播间主播发送的数据列表
          [Documentation]          *获取直播间主播发送的数据列表*
          ...
          ...          *备注：模板校验取的时候比较麻烦。*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${liveRoomId}          Set Variable          1231
          ${liveRoomId}          Get From Dictionary          ${json_manager_content}          LiveID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${liveRoomId}
          #数据库
          ${have_liveRoom}          查询直播是否存在          ${liveRoomId}
          #请求
          ${responsedata}          获取直播间主播发送的数据列表          ${API_URL}          ${liveRoomId}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_liveRoom}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(Data).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取直播间用户发送的弹幕列表
          [Documentation]          *获取直播间用户发送的弹幕列表*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${liveRoomId}          Get From Dictionary          ${json_manager_content}          LiveID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${liveRoomId}
          #数据库
          ${have_liveRoom}          查询直播是否存在          ${liveRoomId}
          #请求
          ${responsedata}          获取直播间主播发送的数据列表          ${API_URL}          ${liveRoomId}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_liveRoom}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(Data).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

直播投诉
          [Documentation]          *直播投诉*
          ...
          ...          *数据库表操作： azt_complain *
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${SourceId}          Get From Dictionary          ${json_manager_content}          LiveID
          ${SourceType}          Set Variable          2
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${UserContent}          Get Random Chinese String          20
          ${ImageQuantityString}          Set Variable          1
          ${ImageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\Liveroom_Complain_Photo1.png          #获得图片流
          ${ImageStreamList}          Create List          ${ImageStreamString}
          ${data}          Create Dictionary          SourceId=${SourceId}          SourceType=${SourceType}          UserId=${UserId}          UserContent=${UserContent}          ImageQuantityString=${ImageQuantityString}
          ...          ImageStreamList=${ImageStreamList}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${SourceId}          ${SourceType}
          ...          ${UserId}          ${UserContent}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          直播投诉          ${API_URL}          ${data}
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

直播间订阅
          [Documentation]          *直播间订阅*
          ...
          ...          *参数注意：(接口返回的Value就是订阅Id（相当于订单Id）)*
          ...
          ...          *备注：接口执行后会重新写订阅id到基础数据文件，为了集成测试时使用*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${liveRoomId}          Get From Dictionary          ${json_manager_content}          LiveID
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${liveRoomId}          ${userId}
          #数据库
          ${have_liveRoom}          查询直播是否存在          ${liveRoomId}
          ${have_user}          查询用户是否存在          ${userId}
          ${have_SubscribeId}          查询用户是否已订阅直播          ${userId}          ${liveRoomId}
          #请求
          ${responsedata}          直播间订阅          ${API_URL}          ${liveRoomId}          ${userId}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_liveRoom} or not ${have_user}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #往字典里新增数据
          Set To Dictionary          ${json_manager_content}          SubscribeId=${Value}          #value值就是SubscribeId
          Create_Common_Arg          ${json_manager_content}          Common_Arg(Manager).json          #重新写入公共数据文件
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          您已经订阅该直播          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          LiveRoom_Subscribe.json          LiveRoom_Subscribe.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_SubscribeId}
          Validate Output Results          ${Success}          ${Success_list}          ${have_SubscribeId}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_SubscribeId}
          Delete All Sessions

用户中心-订阅列表
          [Documentation]          *用户中心-订阅列表*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${userId}          Set Variable          633
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}
          #数据库
          #请求
          ${responsedata}          用户中心-订阅列表          ${API_URL}          ${userId}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          LiveRoom_GetSubscribeList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取直播购票的详细信息
          [Documentation]          *获取直播购票的详细信息*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${subscribeId}          Set Variable          2017070330580629
          ${subscribeId}          Get From Dictionary          ${json_manager_content}          SubscribeId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${subscribeId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取直播购票的详细信息          ${API_URL}          ${subscribeId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Liveroom_Subscribe_Detail.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

直播间订阅付费提交 - 微信支付
          [Documentation]          *直播间订阅付费提交 - 微信支付*
          ...
          ...          *参数注意：（接口有个判断，只有当票价不为0的时候才有支付）*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${Ids}          Set Variable          2017070330580629
          ${Ids}          Get From Dictionary          ${json_manager_content}          SubscribeId
          ${data}          Create Dictionary          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Ids}
          #数据库
          ${have_Subscribe}          查询直播订阅ID是否存在          ${Ids}
          ${price}          查询订阅直播的价格          ${Ids}
          ${has_pay}          Set Variable If          ${price[0][0]} == 0.00          False          True
          ${has_pay}          Evaluate          bool(${has_pay})
          #请求
          ${responsedata}          直播间订阅付费提交 - 微信支付          ${API_URL}          ${data}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_Subscribe}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          LiveRoom_WeixinPay.json          LiveRoom_WeixinPay(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${has_pay}
          Validate Output Results          ${Success}          ${Success_list}          ${has_pay}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${has_pay}
          Delete All Sessions

直播间订阅付费提交 - 支付宝支付
          [Documentation]          *直播间购票付费提交 - 支付宝支付*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：IdList参数没什么用，不需要提供，这里直接取空了*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${Ids}          Set Variable          2017070330580629
          ${Ids}          Get From Dictionary          ${json_manager_content}          SubscribeId
          ${data}          Create Dictionary          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Ids}
          #数据库
          ${have_Subscribe}          查询直播订阅ID是否存在          ${Ids}
          #请求
          ${responsedata}          直播间订阅付费提交 - 支付宝支付          ${API_URL}          ${data}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_Subscribe}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(Value).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

申请直播退票
          [Documentation]          *申请直播退票*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${Ids}          Set Variable          2017070330580629
          ${Ids}          Get From Dictionary          ${json_manager_content}          SubscribeId
          ${data}          Create Dictionary          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Ids}
          #数据库
          ${have_refund}          查询直播退票ID是否存在          ${Ids}          SubscribeId
          #请求
          ${responsedata}          申请直播退票          ${API_URL}          ${data}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_refund}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          你已经提交了退款!          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_refund}
          Validate Output Results          ${Success}          ${Success_list}          ${have_refund}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_refund}
          Delete All Sessions

重新申请直播退票
          [Documentation]          *重新申请直播退票*
          ...
          ...          *参数注意：（参数为直播退票的退票id）*
          ...
          ...          *备注：这个接口没有采用固定的基础数据，而是在已有的订阅id的基础上动态的去取退票id。*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${subscribeId}          Get From Dictionary          ${json_manager_content}          SubscribeId
          ${Ids}          查询订阅直播退票的ID          ${subscribeId}
          ${Ids}          Set Variable          ${Ids[0][0]}
          ${data}          Create Dictionary          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Ids}
          #数据库
          ${have_refund}          查询直播退票ID是否存在          ${Ids}          ID
          #请求
          ${responsedata}          重新申请直播退票          ${API_URL}          ${data}
          #验证参数为空或有效
          Pass Execution If          ${have_not_par} or not ${have_refund}          当参数为空或者无效时，实际上已经异常了，这里不做验证，跳出case！
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions
