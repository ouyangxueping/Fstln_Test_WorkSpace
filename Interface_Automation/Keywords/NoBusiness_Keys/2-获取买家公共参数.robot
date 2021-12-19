*** Settings ***
Documentation           *说明：*
...
...                     *1、查询用户信息表：获取用户相关信息*
...
...                     *2、通过第一步获取的用户id中，随机一个用户，查询出该用户相关的其他表的字段id*
...
...                     *3、通过第二步获取的该用户全部相关id后，生成相应的 json数据文件。*
Force Tags              CollectData
Library                 ../API_Lib/Create_Common_Arg.py
Library                 DatabaseLibrary
Library                 Collections
Resource                ../../Generic_Profiles.txt

*** Test Cases ***
Query_User_Info
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.1 Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${count}          Query          SELECT COUNT(*) FROM user
          ${query_user_info}          Query          SELECT id FROM user          #取id的值
          ${temp}          Get Random Choice Number          ${query_user_info}
          ${UserID}=          Set Variable If          ${query_user_info}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${UserID}          #设置全局变量

获取买家相关ID
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${SystemNotice_Ids}          Query          select id from azt_system_notice          #系统消息通知记录ID,随机获取5个
          ${temp}          Get Random Choice Number          ${SystemNotice_Ids}          5
          ${SystemNotice_Ids}=          Set Variable If          ${SystemNotice_Ids}==[]          ${EMPTY}          ${temp}
          Set Global Variable          ${SystemNotice_Ids}          #设置全局变量
          ${InstantPushId}          Query          select id from azt_instantpush          #即时推送消息ID,随机获取1个
          ${temp}          Get Random Choice Number          ${InstantPushId}
          ${InstantPushId}=          Set Variable If          ${InstantPushId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${InstantPushId}          #设置全局变量
          ${TalkId}          Query          select id from azt_talk          #话题ID,随机获取1个
          ${temp}          Get Random Choice Number          ${TalkId}
          ${TalkId}=          Set Variable If          ${TalkId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${TalkId}          #设置全局变量
          ${TalkName}          Query          select TopicName from azt_talk where id="${TalkId}"          #话题名称,根据话题id获取
          ${temp}          Get Random Choice Number          ${TalkName}
          ${TalkName}=          Set Variable If          ${TalkName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${TalkName}          #设置全局变量
          ${TalkReviewId}          Query          select id from azt_review where SourceType="3" and SourceId="${TalkId}"          #话题下的评论ID,根据话题id获取，随机选1个
          ${temp}          Get Random Choice Number          ${TalkReviewId}
          ${TalkReviewId}=          Set Variable If          ${TalkReviewId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${TalkReviewId}          #设置全局变量
          ${SpecialId}          Query          select id from azt_specialthemebaseconfig          #专题ID,随机获取1个
          ${temp}          Get Random Choice Number          ${SpecialId}
          ${SpecialId}=          Set Variable If          ${SpecialId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${SpecialId}          #设置全局变量
          ${VipCardModelId}          Query          select id from azt_shop_vip          #会员卡记录ID,随机获取1个
          ${temp}          Get Random Choice Number          ${VipCardModelId}
          ${VipCardModelId}=          Set Variable If          ${VipCardModelId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${VipCardModelId}          #设置全局变量
          ${PlatformnoticeId}          Query          select id from azt_platformnotice          #平台公告ID,随机获取5个
          ${temp}          Get Random Choice Number          ${PlatformnoticeId}          5          #返回的是多个随机数的列表
          ${PlatformnoticeId}=          Set Variable If          ${PlatformnoticeId}==[]          ${EMPTY}          ${temp}
          Set Global Variable          ${PlatformnoticeId}          #设置全局变量
          ${PlatformnoticeUserId}          Query          select id from azt_platformnotice_user where MemberId="${userID}"          #用户平台公告ID,随机获取5个
          ${temp}          Get Random Choice Number          ${PlatformnoticeUserId}          5          #返回的是多个随机数的列表
          ${PlatformnoticeUserId}=          Set Variable If          ${PlatformnoticeUserId}==[]          ${EMPTY}          ${temp}
          Set Global Variable          ${PlatformnoticeUserId}          #设置全局变量
          ${ReviewId}          Query          select id from azt_review          #评论ID,随机获取5个
          ${temp}          Get Random Choice Number          ${ReviewId}          5          #返回的是多个随机数的列表
          ${ReviewId}=          Set Variable If          ${ReviewId}==[]          ${EMPTY}          ${temp}
          Set Global Variable          ${ReviewId}          #设置全局变量
          ${UserReviewId}          Query          select id from azt_review where ReviewUserId="${userID}"          #用户评论ID
          ${temp}          Get Random Choice Number          ${UserReviewId}
          ${UserReviewId}=          Set Variable If          ${UserReviewId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${UserReviewId}          #设置全局变量
          ${TalentShowID}          Query          select id from azt_talent_show          #达人秀ID，随机获取1个
          ${temp}          Get Random Choice Number          ${TalentShowID}
          ${TalentShowID}=          Set Variable If          ${TalentShowID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${TalentShowID}          #设置全局变量
          ${UserTalentShowID}          Query          select id from azt_talent_show where MemberId="${userID}"          #用户的达人秀ID
          ${temp}          Get Random Choice Number          ${UserTalentShowID}
          ${UserTalentShowID}=          Set Variable If          ${UserTalentShowID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${UserTalentShowID}          #设置全局变量
          ${distributionID}          Query          select id from azt_distribution_person where MemberId="${userID}"          #用户分销商ID
          ${temp}          Get Random Choice Number          ${distributionID}
          ${distributionID}=          Set Variable If          ${distributionID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${distributionID}          #设置全局变量
          ${distribution_Products_ID}          Query          select id from azt_distribution_product where MemberId="${userID}"          #用户的已分销商品ID
          ${temp}          Get Random Choice Number          ${distribution_Products_ID}          3          #随机取3个
          ${distribution_Products_ID}=          Set Variable If          ${distribution_Products_ID}==[]          ${EMPTY}          ${temp}
          Set Global Variable          ${distribution_Products_ID}          #设置全局变量
          ${user_signinID}          Query          select id from azt_member_signin where MemberId="${userID}"          #用户签到ID
          ${temp}          Get Random Choice Number          ${user_signinID}
          ${user_signinID}=          Set Variable If          ${user_signinID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${user_signinID}          #设置全局变量
          ${User_AddressID}          Query          select id from azt_shippingaddresses where UserId="${userID}"          #用户收货地址ID
          ${temp}          Get Random Choice Number          ${User_AddressID}
          ${User_AddressID}=          Set Variable If          ${User_AddressID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_AddressID}          #设置全局变量
          ${User_InvoiceTitleID}          Query          select id from azt_invoicetitle where UserId="${userID}"          #用户发票抬头ID
          ${temp}          Get Random Choice Number          ${User_InvoiceTitleID}
          ${User_InvoiceTitleID}=          Set Variable If          ${User_InvoiceTitleID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_InvoiceTitleID}          #设置全局变量
          ${User_ShoppingCartsID}          Query          select id from azt_shoppingcarts where UserId="${userID}"          #用户购物车ID          #注意：没有关联sku查询
          ${temp}          Get Random Choice Number          ${User_ShoppingCartsID}
          ${User_ShoppingCartsID}=          Set Variable If          ${User_ShoppingCartsID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_ShoppingCartsID}          #设置全局变量
          ${User_OrderId}=          Query          select id from azt_orders where UserId="${userID}"          #用户订单ID
          ${temp}          Get Random Choice Number          ${User_OrderId}
          ${User_OrderId}=          Set Variable If          ${User_OrderId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_OrderId}          #设置全局变量
          ${User_OrderItemId}=          Query          select id from azt_orderitems where OrderId="${User_OrderId}"          #用户订单明细ID
          ${temp}          Get Random Choice Number          ${User_OrderItemId}
          ${User_OrderItemId}=          Set Variable If          ${User_OrderItemId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_OrderItemId}          #设置全局变量
          ${User_OrderRetundId}=          Query          select id from azt_orderrefunds where OrderId="${User_OrderId}" and OrderItemId="${User_OrderItemId}"          #用户订单退款ID
          ${temp}          Get Random Choice Number          ${User_OrderRetundId}
          ${User_OrderRetundId}=          Set Variable If          ${User_OrderRetundId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_OrderRetundId}          #设置全局变量
          ${User_OrderComplaintsId}=          Query          select id from azt_ordercomplaints where UserId="${userID}"          #用户投诉维权ID
          ${temp}          Get Random Choice Number          ${User_OrderComplaintsId}
          ${User_OrderComplaintsId}=          Set Variable If          ${User_OrderComplaintsId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${User_OrderComplaintsId}          #设置全局变量
          ${PraisedreviewId}=          Query          select id from azt_Praisedreview where ReviewId="${ReviewId}"          #评论回复ID
          ${temp}          Get Random Choice Number          ${PraisedreviewId}
          ${PraisedreviewId}=          Set Variable If          ${PraisedreviewId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${PraisedreviewId}          #设置全局变量
          Disconnect From Database

Get_Common_Arg_From_DataBase(买家)
          [Documentation]          *从json文件中取出参数文件的步骤：*
          ...
          ...          *|${json_content} | Read Joson Content | Common_Arg(User).json | *
          ...
          ...          *| ${json_content} | To Json | ${json_content} | *
          ...
          ...          *| ${userId} | Get From Dictionary | ${json_content} | userId | *
          ${userInfo}          Create Dictionary
          #往字典里新增数据
          Set To Dictionary          ${userInfo}          UserID=${userID}
          Set To Dictionary          ${userInfo}          UserName=${UserName}
          Set To Dictionary          ${userInfo}          Password=${Password}
          Set To Dictionary          ${userInfo}          PasswordSalt=${PasswordSalt}
          Set To Dictionary          ${userInfo}          Phone=${Phone}
          Set To Dictionary          ${userInfo}          Email=${Email}
          Set To Dictionary          ${userInfo}          ReviewId=${ReviewId}          #评论ID,随机获取
          Set To Dictionary          ${userInfo}          UserReviewId=${UserReviewId}          #用户的评论ID
          Set To Dictionary          ${userInfo}          PlatformnoticeId=${PlatformnoticeId}          #平台公告ID
          Set To Dictionary          ${userInfo}          TalkId=${TalkId}          #话题ID
          Set To Dictionary          ${userInfo}          TalkName=${TalkName}          #话题名称
          Set To Dictionary          ${userInfo}          TalkReviewId=${TalkReviewId}          #话题下的评论ID
          Set To Dictionary          ${userInfo}          SpecialId=${SpecialId}          #专题ID
          Set To Dictionary          ${userInfo}          InstantPushId=${InstantPushId}          #即时推送消息ID
          Set To Dictionary          ${userInfo}          PlatformnoticeUserId=${PlatformnoticeUserId}          #用户的平台公告ID
          Set To Dictionary          ${userInfo}          VipCardModelId=${VipCardModelId}          #会员卡记录ID
          Set To Dictionary          ${userInfo}          SystemNotice_Ids=${SystemNotice_Ids}          #系统消息通知记录ID
          Set To Dictionary          ${userInfo}          TalentShowID=${TalentShowID}          #达人秀ID
          Set To Dictionary          ${userInfo}          UserTalentShowID=${UserTalentShowID}          #用户的达人秀ID
          Set To Dictionary          ${userInfo}          User_SigninID=${user_signinID}          #签到ID
          Set To Dictionary          ${userInfo}          User_AddressID=${User_AddressID}          #用户收货地址ID
          Set To Dictionary          ${userInfo}          User_InvoiceTitleID=${User_InvoiceTitleID}          #用户发票抬头ID
          Set To Dictionary          ${userInfo}          User_ShoppingCartsID=${User_ShoppingCartsID}          #用户购物车ID
          Set To Dictionary          ${userInfo}          DistributionID=${distributionID}          #用户分销商ID
          Set To Dictionary          ${userInfo}          Distribution_Products_ID=${distribution_Products_ID}          #用户已分销商品ID
          Set To Dictionary          ${userInfo}          User_OrderId=${User_OrderId}          #用户订单ID
          Set To Dictionary          ${userInfo}          User_OrderItemId=${User_OrderItemId}          #用户订单明细ID
          Set To Dictionary          ${userInfo}          User_OrderRetundId=${User_OrderRetundId}          #用户订单退款ID
          Set To Dictionary          ${userInfo}          User_OrderComplaintsId=${User_OrderComplaintsId}          #用户投诉维权ID
          Set To Dictionary          ${userInfo}          PraisedreviewId=${PraisedreviewId}          #评论回复ID
          Create_Common_Arg          ${userInfo}          Common_Arg(User).json
