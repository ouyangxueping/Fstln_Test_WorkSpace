*** Settings ***
Documentation           *购物车相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_CartApi.txt

*** Test Cases ***
加入购物车
          [Documentation]          *商品加入购物车*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          清空购物车          ${userId}          #数据库清除下当前用户的购物车
          Comment          ${skuId}          Set Variable          858_132_615_0
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${count}          Get Range Number String          1          5          #没考虑个数为0的情况
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${sourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${sourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${data}          Create Dictionary          userId=${userId}          skuId=${skuId}          count=${count}          storeId=${storeId}          sourceType=${sourceType}
          ...          sourceId=${sourceId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          加入购物车          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par[1]}          Should Be True          ${Success} == False
          Run Keyword If          ${have_not_par[1]}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par[1]}          当参数为空时，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Cart_Add.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions
          #更新用户购物车id到公共数据文件
          ${result}          查询用户购物车信息          ${userId}          ${skuId}
          Set To Dictionary          ${json_user_content}          User_ShoppingCartsID=${result[0]}
          Set To Dictionary          ${json_user_content}          User_ShoppingCartsCount=${result[1]}
          Create_Common_Arg          ${json_user_content}          Common_Arg(User).json          #重新写入公共数据文件

获取购物车列表
          [Documentation]          *获取购物车列表*
          ...
          ...          *参数注意：有几种状态需要考虑：1、购物车内没有商品 \ 2、购物车内只有活动商品 \ 3、购物车内只有非活动商品 4、购物车有既有活动商品又有非活动商品*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          userId=${userId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${is_promotion_product}          查询是否为活动商品          ${skuId}          SKU
          #请求
          ${responsedata}          获取购物车列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Get_CartList(Promotion).json          Get_CartList(NoPromotion).json
          Validate Output Results          ${Message}          ${Message_list}          ${is_promotion_product}
          Validate Output Results          ${Success}          ${Success_list}          ${is_promotion_product}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_promotion_product}
          Delete All Sessions

购物车删除商品
          [Documentation]          *从购物车中删除商品*
          ...
          ...          *参数注意：有几种状态需要考虑：1、活动商品 \ 2、非活动商品*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${data}          Create Dictionary          userId=${userId}          skuIds=${skuId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          购物车删除商品          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par[1]}          Should Be True          ${Success} == True
          Run Keyword If          ${have_not_par[1]}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par[1]}          当参数为空时，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Cart_Add.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

购物车中更新购买数量
          [Documentation]          *购物车中更新商品的购买数量*
          ...
          ...          *参数注意：有几种状态需要考虑：1、活动商品 \ 2、非活动商品*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${count}          Get Random Number String          1          #随机取个数量
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${data}          Create Dictionary          userId=${userId}          skuId=${skuId}          count=${count}          storeId=${storeId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          购物车中更新购买数量          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par[1]}          Should Be True          ${Success} == False
          Run Keyword If          ${have_not_par[1]}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par[1]}          当参数为空时，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Cart_Add.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions
