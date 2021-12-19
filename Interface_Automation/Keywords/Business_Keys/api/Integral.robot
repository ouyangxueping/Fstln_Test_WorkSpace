*** Settings ***
Documentation           *积分商城相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_IntegralAPI.txt

*** Test Cases ***
获取积分商品(GET)
          [Documentation]          *测试方法及步骤：*
          ...
          ...          *1、获取输入参数，并存入字典变量。（输入参数来自数据库 或 来自数据文件）*
          ...
          ...          *2、准备构造测试用例，设想组合测试用例的状态变量，尽量在3个变量的组合正交内，否则用例会变得很复杂*
          ...
          ...          *3、构造完测试用例所需的用例参数后，校验输入参数字典，获得相应的状态变量。这些状态变量即可作为输出结果的验证条件（单个变量为空、输入参数字典为空、参数正交组合等）*
          ...
          ...          *4、以第上一步获得的状态变量，查询数据库。获得输入参数中的数据有效性变量即可作为输入结果的验证条件 （用户是否存在、商品是否存在、是否为积分商品）*
          ...
          ...          *5、获取有效状态下的数据库积分商品信息*
          ...
          ...          *6、获取任何状态下的服务器响应内容*
          ...
          ...          *7、分别验证不同输入参数条件下的不同响应内容结果。message、success、以及结果模板。*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${SkuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${ProductId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${data}          Create Dictionary          skuId=${SkuId}          userId=${userId}
          ${not_skuId}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${SkuId}          #判断输入参数是否为空
          ${not_userId}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${userId}          #判断输入参数是否为空
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${have_product}          查询商品是否存在          ${SkuId}          SKU
          ${is_integralproduct}          查询是否为积分商品          ${ProductId}
          ${get_integralproduct}          Validate Input Parameters          P
          ...          AND          True          ${have_user}          ${have_product}          ${is_integralproduct}
          ${Validate_Value}          Run Keyword If          ${get_integralproduct}          查询用户对应的积分商品数据          ${SkuId}          ${userId}          #只有当用户有效、SKU存在、是积分商品时才获取验证数据
          #请求
          ${responsedata}          获取积分商品(GET)          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message          #取出返回值里Message的信息
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value          #SalePrice 居然返回的是个 float类型，所以模板中修改为number
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          查询成功          无此SKU商品          不是积分商品          无此SKU商品          不是合法的用户!
          ...          无此SKU商品          不是积分商品          无此SKU商品
          ${Success_list}          Create List          True          False          False          False          False
          ...          False          False          False
          ${JsonTemp_list}          Create List          GetIntegralProduct.json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          StackTrace_Temp.json
          ...          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json
          #验证message
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${have_product}          ${is_integralproduct}          #验证用户是否存在
          ...          # 商品是否存在          是否为积分商品
          #验证 success
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${have_product}          ${is_integralproduct}
          #验证json返回类型和数据值
          Validate Json By Condition          ${JsonTemp_list}          ${responsedata}          ${have_user}          ${have_product}          ${is_integralproduct}
          Run Keyword If          ${get_integralproduct}          Dictionaries Should Be Equal          ${Validate_Value}          ${Value}          Value值验证失败！返回的Value值与数据库查询不一致！          #如果参数都正确则验证返回值与数据库查询是否一致
          Delete All Sessions

获取积分商品(POST)
          [Documentation]          *测试方法及步骤：*
          ...
          ...          *1、获取输入参数，并存入字典变量。（输入参数来自数据库 或 来自数据文件）*
          ...
          ...          *2、准备构造测试用例，设想组合测试用例的状态变量，尽量在3个变量的组合正交内，否则用例会变得很复杂*
          ...
          ...          *3、构造完测试用例所需的用例参数后，校验输入参数字典，获得相应的状态变量。这些状态变量即可作为输出结果的验证条件（单个变量为空、输入参数字典为空、参数正交组合等）*
          ...
          ...          *4、以第上一步获得的状态变量，查询数据库。获得输入参数中的数据有效性变量即可作为输入结果的验证条件 （用户是否存在、商品是否存在、是否为积分商品）*
          ...
          ...          *5、获取有效状态下的数据库积分商品信息*
          ...
          ...          *6、获取任何状态下的服务器响应内容*
          ...
          ...          *7、分别验证不同输入参数条件下的不同响应内容结果。message、success、以及结果模板。*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${SkuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${ProductId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${data}          Create Dictionary          skuId=${SkuId}          userId=${userId}
          ${not_skuId}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${SkuId}          #判断输入参数是否为空
          ${not_userId}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${userId}          #判断输入参数是否为空
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${have_product}          查询商品是否存在          ${SkuId}          SKU
          ${is_integralproduct}          查询是否为积分商品          ${ProductId}
          ${get_integralproduct}          Validate Input Parameters          P
          ...          AND          True          ${have_user}          ${have_product}          ${is_integralproduct}
          ${Validate_Value}          Run Keyword If          ${get_integralproduct}          查询用户对应的积分商品数据          ${SkuId}          ${userId}          #只有当用户有效、SKU存在、是积分商品时才获取验证数据
          #请求
          ${responsedata}          获取积分商品(POST)          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message          #取出返回值里Message的信息
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value          #SalePrice 居然返回的是个 float类型，所以模板中修改为number
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          查询成功          无此SKU商品          不是积分商品          无此SKU商品          不是合法的用户!
          ...          无此SKU商品          不是积分商品          无此SKU商品
          ${Success_list}          Create List          True          False          False          False          False
          ...          False          False          False
          ${JsonTemp_list}          Create List          GetIntegralProduct.json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          StackTrace_Temp.json
          ...          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json
          #验证message
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${have_product}          ${is_integralproduct}          #验证用户是否存在
          ...          # 商品是否存在          是否为积分商品
          #验证 success
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${have_product}          ${is_integralproduct}
          #验证json返回类型和数据值
          Validate Json By Condition          ${JsonTemp_list}          ${responsedata}          ${have_user}          ${have_product}          ${is_integralproduct}
          Run Keyword If          ${get_integralproduct}          Dictionaries Should Be Equal          ${Validate_Value}          ${Value}          Value值验证失败！返回的Value值与数据库查询不一致！          #如果参数都正确则验证返回值与数据库查询是否一致
          Delete All Sessions

获取轮播图配置数据
          ${responsedata}          获取轮播图配置数据          ${API_URL}          #这个接口不带参数
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          获取数据成功
          ${Success_list}          Create List          True
          ${Json_list}          Create List          GetIntegralConfig.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取精品推荐数据列表
          [Documentation]          *根据页数和页码获取用户已分销的商品*
          ...
          ...          *参数注意：接口只做了是否有参数的校验，userid没有做是否为分销商的有效性检查。PageNo参数必须大于0*
          #创建参数字典
          ${PageNo}          Get Range Number String          1          1
          ${PageSize}          Get Range Number String          1          10
          ${list}          Create List          0          1          #排序类型：0=兑换排行，1=积分排行
          ${Type}          Get Random Choice Number          ${list}          #随机选
          ${data}          Create Dictionary          PageNo=${PageNo}          PageSize=${PageSize}          Type=${Type}          #          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          #请求
          ${responsedata}          获取精品推荐数据列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          获取数据成功          获取数据成功
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp(Data).json          GetTopProductList.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

*** Keywords ***
