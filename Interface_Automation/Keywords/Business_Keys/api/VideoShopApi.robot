*** Settings ***
Documentation           *视频店铺相关API*
...
...                     *过滤标记：’写评论(GET)‘、’写评论(POST)‘、获取店铺评论列表(GET)、获取店铺评论列表(POST)*
Force Tags              API-Automated
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                L1_Components.txt
Resource                ../../../Generic_Profiles.txt
Resource                L2_Keywords_VideoShopApi.txt

*** Test Cases ***
获取店铺基本信息
          [Documentation]          *获取店铺基本信息*
          ...
          ...          *参数注意：所有该类API，需要考虑 视频店铺的冻结状态*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${ShopId}          Set Variable          284
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${data}          Create Dictionary          shopId=${ShopId}          userId=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          输入字符串的格式不正确。          #如果参数为空，直接Pass掉
          #数据库
          ${is_shop}          查询商家是否存在          ${ShopId}
          ${shop_is_frozen}          查询店铺是否被冻结          ${ShopId}
          #请求
          ${responsedata}          获取店铺基本信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          店铺被冻结！          None          没有相关店铺信息！          没有相关店铺信息！
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          Common_Temp(ValueNone).json          VideoShop_BaseInfo1.json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${is_shop}          ${shop_is_frozen}
          Validate Output Results          ${Success}          ${Success_list}          ${is_shop}          ${shop_is_frozen}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_shop}          ${shop_is_frozen}
          Delete All Sessions

获取店铺首页
          [Documentation]          *获取店铺首页*
          ...
          ...          *参数注意：(POST方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${ShopId}          Set Variable          279
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${data}          Create Dictionary          shopId=${ShopId}          userId=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          输入字符串的格式不正确。          #如果参数为空，直接Pass掉
          #数据库
          ${is_shop}          查询商家是否存在          ${ShopId}
          ${shop_is_frozen}          查询店铺是否被冻结          ${ShopId}
          #请求
          ${responsedata}          获取店铺首页          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          店铺被冻结！          None          没有相关店铺信息！          没有相关店铺信息！
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          Common_Temp(ValueNone).json          VideoShop_Home.json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${is_shop}          ${shop_is_frozen}
          Validate Output Results          ${Success}          ${Success_list}          ${is_shop}          ${shop_is_frozen}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_shop}          ${shop_is_frozen}
          Delete All Sessions

获取店铺视频页
          [Documentation]          *获取店铺视频页*
          ...
          ...          *参数注意：(POST方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${ShopId}          Set Variable          2791
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${isAsc}          Set Variable          0
          ${orderBy}          Set Variable          0
          ${PageNo}          Get Range Number String          1          2
          ${PageSize}          Get Range Number String          1          2
          ${data}          Create Dictionary          shopId=${ShopId}          userId=${UserID}          isAsc=${isAsc}          orderBy=${orderBy}          pageNo=${PageNo}
          ...          pageSize=${PageSize}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          输入字符串的格式不正确。          #如果参数为空，直接Pass掉
          #数据库
          ${is_shop}          查询商家是否存在          ${ShopId}
          ${shop_is_frozen}          查询店铺是否被冻结          ${ShopId}
          #请求
          ${responsedata}          获取店铺视频页          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          店铺被冻结！          None          没有相关店铺信息！          没有相关店铺信息！
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          VideoShop_Temp(None).json          VideoShop_Video.json          VideoShop_Temp(None).json          VideoShop_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${is_shop}          ${shop_is_frozen}
          Validate Output Results          ${Success}          ${Success_list}          ${is_shop}          ${shop_is_frozen}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_shop}          ${shop_is_frozen}
          Delete All Sessions

获取店铺商品页
          [Documentation]          *获取店铺商品页*
          ...
          ...          *参数注意：(POST方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${isAsc}          Set Variable          0
          ${orderBy}          Set Variable          0
          ${PageNo}          Get Range Number String          1          2
          ${PageSize}          Get Range Number String          1          2
          ${data}          Create Dictionary          shopId=${ShopId}          userId=${UserID}          isAsc=${isAsc}          orderBy=${orderBy}          pageNo=${PageNo}
          ...          pageSize=${PageSize}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          输入字符串的格式不正确。          #如果参数为空，直接Pass掉
          #数据库
          ${is_shop}          查询商家是否存在          ${ShopId}
          ${shop_is_frozen}          查询店铺是否被冻结          ${ShopId}
          #请求
          ${responsedata}          获取店铺商品页          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          店铺被冻结！          None          没有相关店铺信息！          没有相关店铺信息！
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          VideoShop_Temp(None).json          VideoShop_Product.json          VideoShop_Temp(None).json          VideoShop_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${is_shop}          ${shop_is_frozen}
          Validate Output Results          ${Success}          ${Success_list}          ${is_shop}          ${shop_is_frozen}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_shop}          ${shop_is_frozen}
          Delete All Sessions

获取店铺基本信息和播放器列表(GET)
          [Documentation]          *获取店铺基本信息及店铺下的播放器列表*
          ...
          ...          *参数注意：(GET方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_video}          查询店铺下是否存在视频          ${ShopId}
          #请求
          ${responsedata}          获取店铺基本信息和播放器列表(GET)          ${API_URL}          ${ShopId}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          #          假
          ${Message_list}          Create List          None          #          未将对象引用设置到对象的实例。
          ${Success_list}          Create List          True          #          False
          ${Json_list}          Create List          VideoShop_BaseInfo.json          #          VideoShop_BaseInfo(NoVideo).json
          Pass Execution If          not ${have_video}          过滤该场景！
          Validate Output Results          ${Message}          ${Message_list}          #          ${have_video}
          Validate Output Results          ${Success}          ${Success_list}          #          ${have_video}
          Validate Json By Condition          ${Json_list}          ${responsedata}          #          ${have_video}
          Delete All Sessions

获取店铺基本信息和播放器列表(POST)
          [Documentation]          *获取店铺基本信息及店铺下的播放器列表*
          ...
          ...          *参数注意：(POST方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_video}          查询店铺下是否存在视频          ${ShopId}
          #请求
          ${responsedata}          获取店铺基本信息和播放器列表(POST)          ${API_URL}          ${ShopId}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          未将对象引用设置到对象的实例。
          ${Success_list}          Create List          True          False
          ${Json_list}          Create List          VideoShop_BaseInfo.json          VideoShop_BaseInfo(NoVideo).json
          Pass Execution If          not ${have_video}          过滤该场景！
          Validate Output Results          ${Message}          ${Message_list}          ${have_video}
          Validate Output Results          ${Success}          ${Success_list}          ${have_video}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_video}
          Delete All Sessions

添加店铺关注
          [Documentation]          *添加店铺关注*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${ShopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${data}          Create Dictionary          userId=${userId}          shopId=${ShopId}          shopName=${ShopName}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          添加店铺关注          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          关注成功          关注失败：更新条目时出错。有关详细信息，请参阅内部异常。
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          False
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}          ${have_user}
          Delete All Sessions

取消店铺关注
          [Documentation]          *取消店铺关注*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${ShopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${data}          Create Dictionary          userId=${userId}          shopId=${ShopId}          shopName=${ShopName}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          取消店铺关注          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          取消成功          取消失败：更新条目时出错。有关详细信息，请参阅内部异常。
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          False
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}          ${have_user}
          Delete All Sessions

关注列表(GET_1)
          [Documentation]          * 获取用户的店铺关注列表*
          ...
          ...          *参数注意：(GET方法)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          关注列表(GET_1)          ${API_URL}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_ConcernList1.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

关注列表(GET_2)
          [Documentation]          * 获取用户的店铺关注列表*
          ...
          ...          *参数注意：(GET方法)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          关注列表(GET_2)          ${API_URL}          ${UserID}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          获取成功
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_ConcernList2.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

关注列表(POST)
          [Documentation]          * 获取用户的店铺关注列表*
          ...
          ...          *参数注意：(POST方法)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          关注列表(POST)          ${API_URL}          ${UserID}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          获取成功
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_ConcernList2.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取关注店铺的动态信息
          [Documentation]          * 获取关注店铺的动态信息（只返回店铺发布播放器的消息， 仅有APP使用）*
          ...
          ...          *参数注意：(GET方法)*
          ...
          ...          *备注：模板验证中去掉了StoreModel 的校验。*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Set Variable          633
          Comment          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          获取关注店铺的动态信息          ${API_URL}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_ConcernList3.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取店铺评论列表(GET)
          [Documentation]          *获取店铺评论列表(该店铺下全部视频的评论汇总)*
          ...
          ...          *参数注意：(GET方法)*
          ...
          ...          *接口暂时未用到、其实现其实也有问题，一些参数有报错*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${PageNo}          Get Range Number String          1          2
          ${PageSize}          Get Range Number String          1          2
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          获取店铺评论列表(GET)          ${API_URL}          ${UserID}          ${ShopId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_ReviewList.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取店铺评论列表(POST)
          [Documentation]          *获取店铺评论列表(该店铺下全部视频的评论汇总)*
          ...
          ...          *参数注意：(POST方法)*
          ...
          ...          *接口暂时未用到、其实现其实也有问题，一些参数有报错*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ShopId}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          获取店铺评论列表(POST)          ${API_URL}          ${UserID}          ${ShopId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_ReviewList.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

写评论(GET)
          [Documentation]          *参数这么多？要不要这么变态*
          ...
          ...          接口暂时未用到
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ReviewUserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${ReviewUserName}          Get From Dictionary          ${json_user_content}          UserName
          ${AtRId}          Set Variable          0
          ${Content}          Get Random Chinese String          10
          ${data}          Create Dictionary          Content=${Content}          ReviewUserId=${ReviewUserId}          StoreId=${StoreId}          AtRId=${AtRId}          ReviewUserName=${ReviewUserName}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${StoreId}
          ${have_not_ID}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ReviewUserId}
          #请求
          ${responsedata}          写评论(Get)          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          StoreId错误          StoreId错误          ReviewUserId错误          添加成功
          ${Success_list}          Create List          False          False          False          True
          ${Json_list}          Create List          VideoShop_Review.json          VideoShop_Review.json          VideoShop_Review.json          VideoShop_Review.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_ID}          ${have_not_ID}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_not_ID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_not_ID}
          Delete All Sessions

写评论(POST)
          [Documentation]          *参数这么多？要不要这么变态*
          ...
          ...
          ...          接口暂时未用到
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ReviewUserId}          Get From Dictionary          ${json_user_content}          UserID
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${ReviewUserName}          Get From Dictionary          ${json_user_content}          UserName
          ${list}          Create List          0
          ${AtRId}          Get Random Choice Number          ${list}
          ${Content}          Get Random Chinese String          10
          ${data}          Create Dictionary          content=${Content}          storeId=${StoreId}          atRId=${AtRId}          reviewUserId=${ReviewUserId}          reviewUserName=${ReviewUserName}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${StoreId}
          ${have_not_ID}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ReviewUserId}
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #请求
          ${responsedata}          写评论(Post)          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          StoreId错误          StoreId错误          ReviewUserId错误          添加成功
          ${Success_list}          Create List          False          False          False          True
          ${Json_list}          Create List          VideoShop_Review.json          VideoShop_Review.json          VideoShop_Review.json          VideoShop_Review.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_not_ID}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_not_ID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_not_ID}
          Delete All Sessions

获取店铺公告列表
          [Documentation]          *获取店铺公告列表*
          ...
          ...          *参数注意：(GET方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${ShopId}          Set Variable          264
          ${ShopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${ShopId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          获取店铺公告列表          ${API_URL}          ${ShopId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_Notice_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取店铺公告详情
          [Documentation]          *获取店铺公告详情*
          ...
          ...          *参数注意：(GET方法)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${ShopNotice_Id}          Set Variable          2
          ${ShopNotice_Id}          Get From Dictionary          ${json_manager_content}          ShopNotice_Id
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${ShopNotice_Id}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          获取店铺公告详情          ${API_URL}          ${ShopNotice_Id}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          VideoShop_Notice_Detail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions
