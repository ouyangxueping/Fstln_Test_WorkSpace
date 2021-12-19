*** Settings ***
Documentation           *播放器相关API*
...
...                     *过滤标记：’播放器统计‘、’播放器访客次数统计‘、’App分享写入‘、’App写入经验值‘、获取播放器中使用的客户QQ(GET)*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_StoreApi.txt

*** Test Cases ***
播放器统计
          [Documentation]          *播放器统计*
          ...
          ...          *参数注意：下单统计还没调通。。 待定*
          ...
          ...          *备注：暂时tag标记为 filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${SharePlatform}          Set Variable          0
          ${list1}          Create List          share          order
          ${CountType}          Get Random Choice Number          ${list1}          #share:统计分享计数 order:统计下单计数
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${Amount}          Get Random Number String          2
          ${ShareLink}          Set Variable          ${EMPTY}
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${data}          Create Dictionary          StoreId=${storeId}          StoreName=${storeName}          ShopId=${shopId}          ShopName=${shopName}          VideoId=${VideoId}
          ...          VideoName=${videoName}          SharePlatform=${SharePlatform}          CountType=${CountType}          UserId=${UserId}          Amount=${Amount}          ShareLink=${ShareLink}
          ...          SourceType=${SourceType}          SourceId=${SourceId}
          #数据库
          #请求
          ${responsedata}          播放器统计          ${API_URL}          ${data}
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

播放器访客次数统计
          [Documentation]          *播放器访客次数统计【app加载播放器时调用】*
          ...
          ...          *备注：暂时tag标记为 filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Id}
          ${Platform}
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${BrowseTime}
          ${Ip}
          ${NetworkCard}
          ${data}          Create Dictionary          Id=${Id}          Platform=${Platform}          StoreId=${storeId}          StoreName=${storeName}          ShopId=${shopId}
          ...          ShopName=${shopName}          BrowseTime=${BrowseTime}          Ip=${Ip}          NetworkCard=${NetworkCard}
          #数据库
          #请求
          ${responsedata}          播放器访客次数统计          ${API_URL}          ${data}
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

App分享写入
          [Documentation]          *App 分享写入*
          ...
          ...          *备注：暂时tag标记为 filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${SharePlatform}          Set Variable          0
          ${list1}          Create List          share          order
          ${CountType}          Get Random Choice Number          ${list1}          #share:统计分享计数 order:统计下单计数
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${Amount}          Get Random Number String          2
          ${ShareLink}          Set Variable          ${EMPTY}
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${data}          Create Dictionary          StoreId=${storeId}          StoreName=${storeName}          ShopId=${shopId}          ShopName=${shopName}          VideoId=${VideoId}
          ...          VideoName=${videoName}          SharePlatform=${SharePlatform}          CountType=${CountType}          UserId=${UserId}          Amount=${Amount}          ShareLink=${ShareLink}
          ...          SourceType=${SourceType}          SourceId=${SourceId}
          #数据库
          #请求
          ${responsedata}          App分享写入          ${API_URL}          ${data}
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

App写入经验值
          [Documentation]          *App写入经验值*
          ...
          ...          *备注：暂时tag标记为 filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${SharePlatform}          Set Variable          0
          ${list1}          Create List          share          order
          ${CountType}          Get Random Choice Number          ${list1}          #share:统计分享计数 order:统计下单计数
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${Amount}          Get Random Number String          2
          ${ShareLink}          Set Variable          ${EMPTY}
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${data}          Create Dictionary          StoreId=${storeId}          StoreName=${storeName}          ShopId=${shopId}          ShopName=${shopName}          VideoId=${VideoId}
          ...          VideoName=${videoName}          SharePlatform=${SharePlatform}          CountType=${CountType}          UserId=${UserId}          Amount=${Amount}          ShareLink=${ShareLink}
          ...          SourceType=${SourceType}          SourceId=${SourceId}
          #数据库
          #请求
          ${responsedata}          App写入经验值          ${API_URL}          ${data}
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

收藏播放器次数(GET)
          [Documentation]          *收藏播放器次数(GET)*
          ...
          ...          *参数注意：接口返回的收藏次数，在message中*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${StoreId}          Set Variable          673
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${StoreId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          收藏播放器次数(GET)          ${API_URL}          ${StoreId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

收藏播放器次数(POST)
          [Documentation]          *收藏播放器次数(POST)*
          ...
          ...          *参数注意：接口返回的收藏次数，在message中*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${StoreId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          收藏播放器次数(POST)          ${API_URL}          ${StoreId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取商家名片信息(GET)
          [Documentation]          *获取商家名片信息(GET)*
          ...
          ...          *数据库操作：涉及到的数据库表 azt_shops*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${ShopId}          Set Variable          251
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${has_Shopcard}          查询商家是否存在          ${ShopId}
          #请求
          ${responsedata}          获取商家名片信息(GET)          ${API_URL}          ${ShopId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          没有此店铺
          ${Success_list}          Create List          True          False
          ${Json_list}          Create List          Store_ShopCard.json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${has_Shopcard}
          Validate Output Results          ${Success}          ${Success_list}          ${has_Shopcard}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${has_Shopcard}
          Delete All Sessions

获取商家名片信息(POST)
          [Documentation]          *获取商家名片信息(POST)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ShopId
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${has_Shopcard}          查询商家是否存在          ${ShopId}
          #请求
          ${responsedata}          获取商家名片信息(POST)          ${API_URL}          ${ShopId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          没有此店铺
          ${Success_list}          Create List          True          False
          ${Json_list}          Create List          Store_ShopCard.json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${has_Shopcard}
          Validate Output Results          ${Success}          ${Success_list}          ${has_Shopcard}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${has_Shopcard}
          Delete All Sessions

收藏播放器(GET)
          [Documentation]          *根据用户id和视频id收藏播放器*
          ...
          ...          *表操作：检查有效 userid和 storeid后，添加 azt_favoriteviedo 表记录*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${StoreId}          Set Variable          673
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          #验证参数为空
          #数据库
          ${has_user}          查询用户是否存在          ${UserId}
          ${have_store}          查询视频店铺是否存在          ${StoreId}
          #请求
          ${responsedata}          收藏播放器(GET)          ${API_URL}          ${StoreId}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          收藏成功          收藏失败          收藏失败          收藏失败
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_store}          ${has_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_store}          ${has_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_store}          ${has_user}
          Delete All Sessions

收藏播放器(POST)
          [Documentation]          *根据用户id和视频id收藏播放器*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          #验证参数为空
          #数据库
          ${has_user}          查询用户是否存在          ${UserId}
          ${have_store}          查询视频店铺是否存在          ${StoreId}
          #请求
          ${responsedata}          收藏播放器(POST)          ${API_URL}          ${StoreId}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          收藏成功          收藏失败          收藏失败          收藏失败
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_store}          ${has_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_store}          ${has_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_store}          ${has_user}
          Delete All Sessions

取消收藏播放器(GET)
          [Documentation]          *取消收藏播放器API*
          ...
          ...          *表操作：根据 userid和 storeid值，删除 azt_favoriteviedo 表记录*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          #验证参数为空
          #数据库
          #请求
          ${responsedata}          取消收藏播放器(GET)          ${API_URL}          ${StoreId}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          取消成功
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

取消收藏播放器(POST)
          [Documentation]          *取消收藏播放器API*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          #验证参数为空
          #数据库
          #请求
          ${responsedata}          取消收藏播放器(POST)          ${API_URL}          ${StoreId}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          取消成功
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

批量取消收藏播放器
          [Documentation]          *批量取消收藏播放器*
          ...
          ...          *参数注意：接口并未做参数有效性验证*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${website}          Set Variable          1
          ${data}          Create Dictionary          productIds=${storeId}          userId=${UserId}          website=${website}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${StoreId}          ${UserId}
          #数据库
          #请求
          ${responsedata}          批量取消收藏播放器          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          取消失败          取消成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

查询收藏播放器信息(GET)
          [Documentation]          *查询收藏播放器信息(GET)*
          ...
          ...          *返回Value值：1表示有收藏 \ 0表示未收藏*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          #验证参数为空
          #数据库
          #请求
          ${responsedata}          查询收藏播放器信息(GET)          ${API_URL}          ${StoreId}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Store_FavoriteInfo.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

查询收藏播放器信息(POST)
          [Documentation]          *查询收藏播放器信息(POST)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          #验证参数为空
          #数据库
          #请求
          ${responsedata}          查询收藏播放器信息(GET)          ${API_URL}          ${StoreId}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Store_FavoriteInfo.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取收藏播放器列表(GET)
          [Documentation]          *获取收藏播放器列表(GET)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserId}          Set Variable          633
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取收藏播放器列表(GET)          ${API_URL}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Store_FavoriteList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取收藏播放器列表(POST)
          [Documentation]          *获取收藏播放器列表(POST)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserId}          Set Variable          633
          ${UserId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取收藏播放器列表(POST)          ${API_URL}          ${UserId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Store_FavoriteList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取播放器中使用的客户QQ(GET)
          [Documentation]          *获取播放器中使用的客户QQ(GET)*
          ...
          ...          *备注：该接口应该没有再使用了，标记tag 为 filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取播放器中使用的客户QQ(GET)          ${API_URL}          ${ShopId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(Value_String).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

为播放器投票
          [Documentation]          *为播放器投票*
          ...
          ...          *参数注意：因投票接口并未做参数有效性验证，所以暂时只考虑参数为空和不为空的场景。*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${storeCreateTime}          Get Unix Time
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${videoCreateTime}          Get Unix Time
          ${data}          Create Dictionary          userId=${userId}          shopId=${shopId}          shopName=${shopName}          storeId=${storeId}          storeName=${storeName}
          ...          storeCreateTime=${storeCreateTime}          videoId=${VideoId}          videoName=${videoName}          videoCreateTime=${videoCreateTime}          sign=${Sign}
          #验证输入参数中，是否存在空值
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          Pass Execution If          ${have_not_par[1]}          由于URL方式传参时，参数不能为空！故当参数为空时Case不执行后面的操作！          #如果参数字典中存在空参数，case跳过
          #判断输入参数的状态，是否全部都存在
          ${check_input}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${userId}          ${shopId}          ${shopName}          ${storeId}
          ...          ${storeName}          ${VideoId}          ${videoName}
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${is_add}          Run Keyword If          ${have_user}          查询用户是否当天已经投过票          ${userId}
          #请求
          ${responsedata}          播放器投票          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          您今天已经投过票，每个用户每天只能为同一个播放器投票一次！          投票成功！          您今天已经投过票，每个用户每天只能为同一个播放器投票一次！          投票成功！
          ${Success_list}          Create List          False          True          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${check_input}          ${is_add}
          Validate Output Results          ${Success}          ${Success_list}          ${check_input}          ${is_add}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${check_input}          ${is_add}
          Delete All Sessions

获取投票总数
          [Documentation]          *获取投票总数*
          ...
          ...          *参数注意： 接口没有判断用户id的有效性。*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${data}          Create Dictionary          storeId=${storeId}          videoId=${VideoId}
          #数据库
          ${VoteTotal}          查询播放器投票总数          ${storeId}          ${VideoId}
          #请求
          ${responsedata}          获取投票总数          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          获取成功!
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Get_Vote_Count.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

返回微信分享图片
          [Documentation]          *返回微信分享图片(App端，点击视频分享的时候调用)*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${storeId}          Set Variable          629
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${data}          Create Dictionary          storeId=${storeId}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${storeId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          返回微信分享图片          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          获取成功!
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

返回播放器视频信息(POST)
          [Documentation]          *返回播放器视频信息(POST)*
          ...
          ...          *参数注意：这个接口的校验模板分为店铺下有商品和没有商品的情况*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${storeId}          Set Variable          673
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${data}          Create Dictionary          storeId=${storeId}          sign=${Sign}
          #数据库
          ${have_store}          查询视频店铺是否存在          ${storeId}
          ${have_product}          查询视频店铺下是否存在商品          ${storeId}
          Pass Execution If          not ${have_store}          当storeID无效时，其实已经异常了
          #请求
          ${responsedata}          返回播放器视频信息(POST)          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Store_GetStoreVideoPost.json          Store_GetStoreVideoPost(NoProduct).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_product}
          Validate Output Results          ${Success}          ${Success_list}          ${have_product}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_product}
          Delete All Sessions

返回播放器视频信息(GET)
          [Documentation]          *返回播放器视频信息(GET)*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          #数据库
          ${have_store}          查询视频店铺是否存在          ${storeId}
          ${have_product}          查询视频店铺下是否存在商品          ${storeId}
          Pass Execution If          not ${have_store}          当storeID无效时，其实已经异常了
          #请求
          ${responsedata}          返回播放器视频信息(GET)          ${API_URL}          ${storeId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Store_GetStoreVideoPost.json          Store_GetStoreVideoPost(NoProduct).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_product}
          Validate Output Results          ${Success}          ${Success_list}          ${have_product}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_product}
          Delete All Sessions

扣减流量
          [Documentation]          *扣减流量*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${flownum}          Set Variable          2.97
          ${plat}          Set Variable          2
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${data}          Create Dictionary          flownum=${flownum}          plat=${plat}          storeId=${storeId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          #验证参数为空
          Pass Execution If          not ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          扣减流量          ${API_URL}          ${data}
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

地址生成二维码
          [Documentation]          *地址生成二维码*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          #数据库
          #请求
          ${responsedata}          地址生成二维码          ${API_URL}          ${storeId}
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

*** Keywords ***
