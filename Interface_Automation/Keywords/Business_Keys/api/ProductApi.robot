*** Settings ***
Documentation           *商品相关API*
...
...                     *过滤标记：’商品统计‘*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_ProductApi.txt

*** Test Cases ***
计算商品会员价和活动价(GET)
          [Documentation]          *计算商品会员价和活动价(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productIds}          Get From Dictionary          ${json_manager_content}          ProductId
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productIds}          ${shopId}
          ...          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          计算商品会员价和活动价(GET)          ${API_URL}          ${productIds}          ${shopId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_GetMemberPrice.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

计算商品会员价和活动价(POST)
          [Documentation]          *计算商品会员价和活动价(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productIds}          Get From Dictionary          ${json_manager_content}          ProductId
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productIds}          ${shopId}
          ...          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          计算商品会员价和活动价(POST)          ${API_URL}          ${productIds}          ${shopId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_GetMemberPrice.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

商品统计
          [Documentation]          *商品统计报表*
          ...
          ...
          ...          *参数注意：(接口测试时还有点疑问，暂时待定)*
          ...
          ...          *tag标记为filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${SharePlatform}
          ${ProductIdList}          Get From Dictionary          ${json_manager_content}          ProductId
          ${ProductNameList}          Get From Dictionary          ${json_manager_content}          ProductName
          ${OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${CountType}
          ${SystemPlatform}
          ${data}          Create Dictionary          ShopId=${shopId}          ShopName=${shopName}          StoreId=${storeId}          StoreName=${storeName}          VideoId=${videoId}
          ...          VideoName=${videoName}          SharePlatform=${SharePlatform}          ProductIdList=${ProductIdList}          ProductNameList=${ProductNameList}          OrderId=${OrderId}          CountType=${CountType}
          ...          SystemPlatform=${SystemPlatform}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}
          #数据库
          #请求
          ${responsedata}          商品统计          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_GetMemberPrice.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取商品详情(GET)
          [Documentation]          *计算商品会员价和活动价(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取商品详情(GET)          ${API_URL}          ${productId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_Detail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取商品详情(POST)
          [Documentation]          *获取商品详情(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取商品详情(POST)          ${API_URL}          ${productId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_Detail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

搜索商品
          [Documentation]          *搜索商品*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：orderType 所谓的排序类型参数说明的不清楚不确定取什么值*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${keywords}          Set Variable          测试
          ${orderType}          Set Variable          2_2
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          userId=${UserID}          keywords=${keywords}          orderType=${orderType}          pageNo=${PageNo}          pageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${orderType}          ${PageNo}
          ...          ${PageSize}
          #数据库
          #请求
          ${responsedata}          搜索商品          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          Product_GetSearchProduct.json
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取商品关联的播放器和视频(GET)
          [Documentation]          *获取商品关联的播放器和视频(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取商品关联的播放器和视频(GET)          ${API_URL}          ${productId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_GetGetStoreViedoId.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取商品关联的播放器和视频(POST)
          [Documentation]          *获取商品关联的播放器和视频(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取商品关联的播放器和视频(POST)          ${API_URL}          ${productId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_GetGetStoreViedoId.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取商品SKU详情(GET)
          [Documentation]          *获取商品SKU详情(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${skuId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取商品SKU详情(GET)          ${API_URL}          ${skuId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_SkuDetail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取商品SKU详情(POST)
          [Documentation]          *获取商品SKU详情(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${skuId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取商品SKU详情(POST)          ${API_URL}          ${skuId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Product_SkuDetail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

批量添加收藏
          [Documentation]          *批量添加收藏*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：（接口描述有误，这个接口应该只是用于收藏商品，并不用于收藏播放器）*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productIds}          Get From Dictionary          ${json_manager_content}          ProductId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${website}          Set Variable          1
          ${data}          Create Dictionary          productIds=${productIds}          userId=${UserID}          website=${website}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productIds}          ${UserID}
          ...          ${website}
          #数据库
          #请求
          ${responsedata}          批量添加收藏          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

批量取消收藏
          [Documentation]          *批量取消收藏*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${productIds}          Get From Dictionary          ${json_manager_content}          ProductId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${website}          Set Variable          1
          ${data}          Create Dictionary          productIds=${productIds}          userId=${UserID}          website=${website}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${productIds}          ${UserID}
          ...          ${website}
          #数据库
          #请求
          ${responsedata}          批量取消收藏          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取收藏列表-不分页(GET)
          [Documentation]          *获取收藏列表-不分页(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          1          2          #用户登录站点类型。1：开卖吧；2：开门吧
          ${website}          Get Random Choice Number          ${list}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${website}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取收藏列表-不分页(GET)          ${API_URL}          ${userId}          ${website}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Product_FavoriteList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取收藏列表-不分页(POST)
          [Documentation]          *获取收藏列表-不分页(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          1          2          #用户登录站点类型。1：开卖吧；2：开门吧
          ${website}          Get Random Choice Number          ${list}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${website}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取收藏列表-不分页(POST)          ${API_URL}          ${userId}          ${website}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Product_FavoriteList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取收藏列表-分页(GET)
          [Documentation]          *获取收藏列表-分页(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${list}          Create List          1          2          #用户登录站点类型。1：开卖吧；2：开门吧
          ${website}          Get Random Choice Number          ${list}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${website}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取收藏列表-分页(GET)          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}          ${website}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Product_FavoriteList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取收藏列表-分页(POST)
          [Documentation]          *获取收藏列表-分页(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${list}          Create List          1          2          #用户登录站点类型。1：开卖吧；2：开门吧
          ${website}          Get Random Choice Number          ${list}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${website}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取收藏列表-分页(POST)          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}          ${website}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Product_FavoriteList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

判断收藏商品(GET)
          [Documentation]          *判断收藏商品(GET)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${productId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_Favorite}          查询用户是否已收藏商品          ${userId}          ${productId}
          #请求
          ${responsedata}          判断收藏商品(GET)          ${API_URL}          ${userId}          ${productId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          True          False
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          ParameterError_Temp(Data).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_Favorite}
          Validate Output Results          ${Success}          ${Success_list}          ${have_Favorite}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_Favorite}
          Delete All Sessions

判断收藏商品(POST)
          [Documentation]          *判断收藏商品(POST)*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${productId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_Favorite}          查询用户是否已收藏商品          ${userId}          ${productId}
          #请求
          ${responsedata}          判断收藏商品(POST)          ${API_URL}          ${userId}          ${productId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          True          False
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          ParameterError_Temp(Data).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_Favorite}
          Validate Output Results          ${Success}          ${Success_list}          ${have_Favorite}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_Favorite}
          Delete All Sessions
