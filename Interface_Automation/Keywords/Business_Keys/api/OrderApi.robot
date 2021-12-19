*** Settings ***
Documentation           *订单相关API*
...
...                     *过滤标记：‘获取物流信息’*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_OrderApi.txt

*** Test Cases ***
立即购买下单
          [Documentation]          *立即购买下单*
          ...
          ...          *参数注意：(接口会检查用户的状态，比如：用户头像字段，如果为空则会抛出异常) 参数考虑的测试点为用户是否有效、商品是否存在、商品是否处于销售中、商品是否还有库存*
          ...
          ...          *备注：接口没有对收货地址的有效性进行验证*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${skuItemIds}          Set Variable          858_132_615_0
          ${skuItemIds}          Get From Dictionary          ${json_manager_content}          SkuId
          ${ProductName}          查询商品名称          ${skuItemIds}
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${counts}          Get Range Number String          1          5          #没考虑个数为0的情况
          ${integral}          Set Variable          0          #商品对应的积分，暂时这里直接取0，在组合api测试时再掉查询积分商品接口获得积分
          ${addressId}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${list1}          Create List          0          2          #0 不要发票，1 普通发票
          ${invoiceType}          Get Random Choice Number          ${list1}          #发票类型
          ${list2}          Create List          0          1          2          3          4
          ...          99          #PC = 0, WeiXin = 1, Android = 2, IOS = 3, Wap = 4, Mobile = 99
          ${platformType}          Get Random Choice Number          ${list2}
          ${list3}          Create List          0          1          2          #All = 0, Kaimai = 1, Kaimen = 2
          ${website}          Get Random Choice Number          ${list3}
          ${data}          Create Dictionary          userId=${userId}          skuItemIds=${skuItemIds}          counts=${counts}          invoiceType=${invoiceType}          integral=${integral}
          ...          addressId=${addressId}          storeId=${storeId}          videoId=${videoId}          platformType=${platformType}          website=${website}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${skuItemIds}
          ...          ${counts}          ${integral}          ${addressId}          ${storeId}          ${videoId}
          ${have_user}          查询用户是否存在          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          Pass Execution If          not ${have_user}          当用户无效时，这里不做验证，跳出case！
          #数据库
          ${stock}          查询商品库存          ${skuItemIds}
          ${hava_stock}          Set Variable If          ${counts} < ${stock}          True          False          #判断下库存是否够
          ${hava_stock}          Evaluate          bool(${hava_stock})
          ${have_product}          查询商品是否存在          ${skuItemIds}          SKU
          ${product_ok}          查询商品是否有效          ${skuItemIds}          SKU
          #请求
          ${responsedata}          立即购买下单          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          ${Result_Message}          Concate String          商品          ${SPACE}          ${ProductName}          ${SPACE}          库存不够,仅剩
          ...          ${stock}          件
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          None          订单中有失效的商品,请返回重新提交!          ${Result_Message}          订单中有失效的商品,请返回重新提交!ProductId:3674,SaleStatus:InStock,AuditStatus:WaitForAuditing          未找到对应的商品
          ...          未找到对应的商品          未找到对应的商品          未找到对应的商品
          ${Success_list}          Create List          True          False          False          False          False
          ...          False          False          False
          ${Json_list}          Create List          Order_SubmitOrderPost.json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json
          ...          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_product}          ${product_ok}          ${hava_stock}
          Validate Output Results          ${Success}          ${Success_list}          ${have_product}          ${product_ok}          ${hava_stock}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_product}          ${product_ok}          ${hava_stock}
          Delete All Sessions
          #连接数据库，做清理数据操作
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Buy_Now}          Query          select id from azt_orders where userid='${userId}' \ and storeId='${storeId}' \ and videoId='${videoId}' and OrderStatus="1" \ ORDER BY OrderDate DESC limit 1
          ${BuyNow_len}          Get Length          ${Buy_Now}
          Run Keyword If          ${BuyNow_len} != 0          Execute Sql String          delete from \ azt_orders \ where id='${Buy_Now[0][0]}'
          ...          ELSE          log          数据库无此记录无须删除！！
          Disconnect From Database

购物车下单
          [Documentation]          *从购物车下单*
          ...
          ...          *参数注意：(XXX)*
          ...
          ...          *备注：该case只能和加入购物车case做集成测试*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${skuItemIds}          Set Variable          858_132_615_0
          Comment          ${addressId}          Set Variable          1527
          ${skuItemIds}          Get From Dictionary          ${json_manager_content}          SkuId
          ${addressId}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${ProductName}          查询商品名称          ${skuItemIds}
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${integral}          Set Variable          0          #商品对应的积分，暂时这里直接取0，在组合api测试时再掉查询积分商品接口获得积分
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${cartItemIds}          Get From Dictionary          ${json_user_content}          User_ShoppingCartsID          #这里取的是动态的，加入购物车接口已经动态更新了基础数据
          ${list1}          Create List          0          2          #0 不要发票，1 普通发票
          ${invoiceType}          Get Random Choice Number          ${list1}          #发票类型
          ${list2}          Create List          0          1          2          3          4
          ...          99          #PC = 0, WeiXin = 1, Android = 2, IOS = 3, Wap = 4, Mobile = 99
          ${platformType}          Get Random Choice Number          ${list2}
          ${list3}          Create List          0          1          2          #All = 0, Kaimai = 1, Kaimen = 2
          ${website}          Get Random Choice Number          ${list3}
          ${data}          Create Dictionary          userId=${userId}          integral=${integral}          addressId=${addressId}          storeId=${storeId}          videoId=${videoId}
          ...          cartItemIds=${cartItemIds}          website=${website}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${integral}
          ...          ${addressId}          ${storeId}          ${videoId}          ${cartItemIds}
          ${have_user}          查询用户是否存在          ${userId}
          ${have_address}          查询收货地址是否存在          ${addressId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          Pass Execution If          not ${have_user}          当用户无效时，这里不做验证，跳出case！
          Pass Execution If          not ${have_address}          当收货地址无效时，这里不做验证，跳出case！
          #数据库
          ${stock}          查询商品库存          ${skuItemIds}
          ${cartItemCount}          Get From Dictionary          ${json_user_content}          User_ShoppingCartsCount          #数据来自加入购物车接口
          ${hava_stock}          Set Variable If          ${cartItemCount} < ${stock}          True          False          #判断下库存是否够
          ${hava_stock}          Evaluate          bool(${hava_stock})
          Pass Execution If          not ${hava_stock}          当商品库存不足时，这里不做验证
          ${have_product}          查询商品是否存在          ${skuItemIds}          SKU
          ${product_ok}          查询商品是否有效          ${skuItemIds}          SKU
          ${have_cart_product}          查询购物车内是否存在商品          ${userId}          ${skuItemIds}
          #请求
          ${responsedata}          购物车下单          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          ${Result_Message}          Concate String          商品          ${SPACE}          ${ProductName}          ${SPACE}          库存不够,仅剩0件
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          None          未找到对应的商品          订单中有失效的商品,请返回重新提交!ProductId:3674,SaleStatus:InStock,AuditStatus:WaitForAuditing          未找到对应的商品          您已经从购物车提交过订单!
          ...          您已经从购物车提交过订单!          您已经从购物车提交过订单!          您已经从购物车提交过订单!
          ${Success_list}          Create List          True          False          False          False          False
          ...          False          False          False
          ${Json_list}          Create List          Order_SubmitOrderPost.json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json
          ...          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json          Order_SubmitOrderPost(ERR).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_cart_product}          ${have_product}          ${product_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_cart_product}          ${have_product}          ${product_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_cart_product}          ${have_product}          ${product_ok}
          Delete All Sessions
          #          收货地址无效

计算单个商品运费(GET)
          [Documentation]          *单商品，计算运费,满额减*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${counts}          Get Range Number String          1          10          #没考虑个数为0的情况
          ${addressId}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${skuId}          ${counts}
          ...          ${addressId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          Comment          ${have_ProductId}          查询商品的sku是否存在
          Comment          Execute Sql String
          #请求
          ${responsedata}          计算单个商品运费(GET)          ${API_URL}          ${skuId}          ${counts}          ${addressId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Order_GetSingleFreight.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

计算单个商品运费(POST)
          [Documentation]          *单商品，计算运费,满额减*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${counts}          Get Range Number String          1          10          #没考虑个数为0的情况
          ${addressId}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${skuId}          ${counts}
          ...          ${addressId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          计算单个商品运费(POST)          ${API_URL}          ${skuId}          ${counts}          ${addressId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Order_GetSingleFreight.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

计算整店商品运费(GET)
          [Documentation]          *整店商品，计算运费,满额减*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${addressId}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${cartItemIds}          Get From Dictionary          ${json_user_content}          User_ShoppingCartsID          #这里必须动态获取，先调加入购物车接口
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${addressId}
          ...          ${cartItemIds}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          计算整店商品运费(GET)          ${API_URL}          ${cartItemIds}          ${userId}          ${addressId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Order_GetShopFreight.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

计算整店商品运费(POST)
          [Documentation]          *整店商品，计算运费,满额减*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${addressId}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${cartItemIds}          Get From Dictionary          ${json_user_content}          User_ShoppingCartsID          #这里必须动态获取，先调加入购物车接口
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${addressId}
          ...          ${cartItemIds}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          计算整店商品运费(POST)          ${API_URL}          ${cartItemIds}          ${userId}          ${addressId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Order_GetShopFreight.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

我的订单列表(GET)
          [Documentation]          *我的订单列表(GET)*
          ...
          ...          *参数注意：(GET方法)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          1          2          3          4          5
          ...          #待付款、待发货、待收货、已关闭、已完成
          ${Status}          Get Random Choice Number          ${list}
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${Status}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_orders}          查询用户是否存在订单          ${UserID}          ${Status}
          #请求
          ${responsedata}          我的订单列表(GET)          ${API_URL}          ${UserID}          ${Status}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          ${Total}          Get From Dictionary          ${responsedata}          Total
          #验证数据库订单总数与服务
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          select count(1) from azt_orders where userid="${userId}" and OrderStatus="${Status}" and Website="1"
          Disconnect From Database
          log          ${Count[0][0]}
          Run Keyword If          '${Count[0][0]}'=='${Total}'          log          数据库订单数据与服务器返回数据一致
          ...          ELSE          log          数据库订单数据与服务器返回数据不一致!
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          获取成功          暂无数据
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Order_List.json          Order_List(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_orders}
          Validate Output Results          ${Success}          ${Success_list}          ${have_orders}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_orders}
          Delete All Sessions

我的订单列表(POST)
          [Documentation]          *我的订单列表(POST)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          990
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          1          2          3          4          5
          ...          #待付款、待发货、待收货、已关闭、已完成
          ${Status}          Get Random Choice Number          ${list}
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${Status}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_orders}          查询用户是否存在订单          ${UserID}          ${Status}
          #请求
          ${responsedata}          我的订单列表(POST)          ${API_URL}          ${UserID}          ${Status}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          ${Total}          Get From Dictionary          ${responsedata}          Total
          #验证数据库订单总数与服务
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          select count(1) from azt_orders where userid="${userId}" and OrderStatus="${Status}" and Website="1"
          Disconnect From Database
          log          ${Count[0][0]}
          Run Keyword If          '${Count[0][0]}'=='${Total}'          log          数据库订单数据与服务器返回数据一致
          ...          ELSE          log          数据库订单数据与服务器返回数据不一致!
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          获取成功          暂无数据
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          True
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Order_List.json          Order_List(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_orders}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_orders}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_orders}
          Delete All Sessions

查询订单详情(GET)
          [Documentation]          *查询订单详情(GET)*
          ...
          ...          *参数注意：(GET方法)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${Order_OK}          查询订单是否有效          ${User_OrderId}
          #请求
          ${responsedata}          查询订单详情(GET)          ${API_URL}          ${User_OrderId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          None          获取用户订单数据失败
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          False
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Order_Detail.json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${Order_OK}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${Order_OK}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${Order_OK}
          Delete All Sessions

查询订单详情(POST)
          [Documentation]          *查询订单详情(POST)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${Order_OK}          查询订单是否有效          ${User_OrderId}
          #请求
          ${responsedata}          查询订单详情(POST)          ${API_URL}          ${User_OrderId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          None          获取用户订单数据失败
          ${Success_list}          Create List          ${EMPTY}          ${EMPTY}          True          False
          ${Json_list}          Create List          ${EMPTY}          ${EMPTY}          Order_Detail.json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${Order_OK}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${Order_OK}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${Order_OK}
          Delete All Sessions

取消订单(GET)
          [Documentation]          *取消订单(GET)*
          ...
          ...          *参数注意：(接口逻辑为：先判断用户是否存在该订单、如果存在则再判断该订单是否处于待付款状态)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${User_OrderId}          Set Variable          2016101728805213
          Comment          ${userId}          Set Variable          780
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${Order_status_ok}          查询订单状态是否正确          ${User_OrderId}          1
          #请求
          ${responsedata}          取消订单(GET)          ${API_URL}          ${User_OrderId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          取消成功          只有待付款状态的订单才能进行取消操作          取消失败，该订单已删除或者不属于当前用户！          取消失败，该订单已删除或者不属于当前用户！
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${Order_status_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${Order_status_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${Order_status_ok}
          Delete All Sessions

取消订单(POST)
          [Documentation]          *取消订单(POST)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${Order_status_ok}          查询订单状态是否正确          ${User_OrderId}          1
          #请求
          ${responsedata}          取消订单(POST)          ${API_URL}          ${User_OrderId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          取消成功          只有待付款状态的订单才能进行取消操作          取消失败，该订单已删除或者不属于当前用户！          取消失败，该订单已删除或者不属于当前用户！
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${Order_status_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${Order_status_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${Order_status_ok}
          Delete All Sessions

确认收货(GET)
          [Documentation]          *确认收货(GET)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${Order_status_ok}          查询订单状态是否正确          ${User_OrderId}          1
          #请求
          ${responsedata}          确认收货(GET)          ${API_URL}          ${User_OrderId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          操作成功          只有等待收货状态的订单才能进行确认操作          操作失败，该订单已删除或者不属于当前用户！          操作失败，该订单已删除或者不属于当前用户！
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${Order_status_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${Order_status_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${Order_status_ok}
          Delete All Sessions

确认收货(POST)
          [Documentation]          *确认收货(POST)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${Order_status_ok}          查询订单状态是否正确          ${User_OrderId}          1
          #请求
          ${responsedata}          确认收货(POST)          ${API_URL}          ${User_OrderId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          操作成功          只有等待收货状态的订单才能进行确认操作          操作失败，该订单已删除或者不属于当前用户！          操作失败，该订单已删除或者不属于当前用户！
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${Order_status_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${Order_status_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${Order_status_ok}
          Delete All Sessions

查询微信支付订单(GET)
          [Documentation]          *查询微信支付订单(GET)*
          ...
          ...          *参数注意：(没具体测试过，不确定能用)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          0          1          #0普通商品查询，1直播购票查询
          ${sourceType}          Get Random Choice Number          ${list}
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          查询微信支付订单(GET)          ${API_URL}          ${sourceType}          ${User_OrderId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Order_weixinpayOrderQuery.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

查询微信支付订单(POST)
          [Documentation]          *查询微信支付订单(POST)*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${list}          Create List          0          1          #0普通商品查询，1直播购票查询
          ${sourceType}          Get Random Choice Number          ${list}
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          查询微信支付订单(POST)          ${API_URL}          ${sourceType}          ${User_OrderId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Order_weixinpayOrderQuery.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取物流信息
          [Documentation]          *获取物流信息*
          ...
          ...          *参数注意：(这个接口可能没实现，目前应该还没有物流相关数据)*
          ...
          ...          *备注：暂时标记该接口为 filter*
          [Tags]          filter
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${User_OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${User_OrderId}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${Order_status_ok}          查询订单状态是否正确          ${User_OrderId}          1
          #请求
          ${responsedata}          获取物流信息          ${API_URL}          ${User_OrderId}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          None          None          None          None
          ${Success_list}          Create List          True          True          False          False
          ${Json_list}          Create List          Access to_logistics.json          Access to_logistics(DataNone).json          Access to_logistics(DataNone).json          Access to_logistics(DataNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${Order_status_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${Order_status_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${Order_status_ok}
          Delete All Sessions

APP微信支付
          [Documentation]          *APP微信支付-后台支持*
          ...
          ...          *参数注意：（这个接口暂时不清楚具体的传参含义）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Set Variable          ${EMPTY}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Ids}          Query          select id from \ azt_orders \ \ where Website="1"
          Disconnect From Database
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${IdList}          ${Ids}
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          APP微信支付          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List
          ${Success_list}          Create List
          ${Json_list}          Create List
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

APP支付宝支付
          [Documentation]          *APP支付宝支付-后台生成签名*
          ...
          ...          *参数注意：（这个接口暂时不清楚具体的传参含义）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Set Variable          ${EMPTY}
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${IdList}          ${Ids}
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #请求
          ${responsedata}          APP支付宝支付          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

*** Keywords ***
