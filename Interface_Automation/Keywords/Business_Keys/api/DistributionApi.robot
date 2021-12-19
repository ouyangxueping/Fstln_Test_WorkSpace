*** Settings ***
Documentation           *分销类API*
...
...                     *过滤标记：‘申请集客分销商’、‘完成提现’*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_DistributionApi.txt

*** Test Cases ***
获取当前用户详情
          [Documentation]          *根据 userId 获取当前用户详情*
          ...
          ...          *参数注意：用户id分为参数为空和用户非分销商账号两种情况*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          UserId=${userId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${is_distribution}          查询用户是否提交过申请资质          ${userId}
          ${have_user}          查询用户是否存在          ${userId}
          ${par_Validate}          Validate Input Parameters          P
          ...          AND          True          ${have_user}          ${is_distribution}
          ${Validate_Value}          Run Keyword If          ${par_Validate}          查询用户当前详情信息          ${userId}          #只有参数有符合时才获取验证数据
          #请求
          ${responsedata}          获取当前用户详情          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #验证参数为空
          Run Keyword If          ${have_not_par[1]}          Should Be True          "${Message}" == "参数错误"
          Run Keyword If          ${have_not_par[1]}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_not_par[1]}          Validate Json          ParameterError_Temp(Value).json          ${responsedata}
          Pass Execution If          ${have_not_par[1]}          当参数为空时，验证成功！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          获取数据成功          未申请过分销商          ${EMPTY}          未申请过分销商
          ${Success_list}          Create List          True          True          ${EMPTY}          True
          ${Json_list}          Create List          UserBaseInfo.json          Common_Temp.json          ${EMPTY}          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${is_distribution}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${is_distribution}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${is_distribution}
          Comment          Run Keyword If          ${par_Validate}          Dictionaries Should Be Equal          ${Validate_Value}          ${Value}          Value值验证失败！返回的Value值与数据库查询不一致！
          ...          #如果参数都正确则验证返回值与数据库查询是否一致
          Delete All Sessions

更新用户银行账户信息
          [Documentation]          *更新用户的银行账户信息*
          ...
          ...          *Id：分销商ID，如果传入的是个空则报参数错误，如果是个不存在的ID则依然提示成功！但不会保存数据*
          ...
          ...          *其余参数可为空，且数据超出会自动截断*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${distributionID}          Get From Dictionary          ${json_user_content}          DistributionID          #分销商ID
          ${BankAccountNumber}          Get Random Number String          20          #随机数
          ${BankAccountName}          Get Random Chinese String          5          #随机数
          ${BankName}          Get Random Chinese String          10          #随机数
          ${data}          Create Dictionary          Id=${distributionID}          BankAccountNumber=${BankAccountNumber}          BankAccountName=${BankAccountName}          BankName=${BankName}          sign=${Sign}
          ${not_distributionID}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${distributionID}          #判断输入参数是否为空
          #数据库
          #请求
          ${responsedata}          更新用户银行账户信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          保存成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${not_distributionID}
          Validate Output Results          ${Success}          ${Success_list}          ${not_distributionID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${not_distributionID}
          Delete All Sessions

新增银行账户
          [Documentation]          *资质审核：新增用户银行账户*
          ...
          ...          *userid没有做已存在验证,重复调用接口，会生成同个userid的多条记录*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ID}          Get Random Number String          3          #自增ID
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${userName}          Get From Dictionary          ${json_user_content}          UserName
          ${ContactEmail}          Set Variable          23767682@qq.com
          ${ContactPhone}          Set Variable          13025428825
          ${RealName}          Get From Dictionary          ${json_user_content}          UserName
          ${CardId}          Get Random Idcard String          18          20          50          #随机生成身份证号码
          ${Mobile}          Set Variable          13025428825
          ${BankAccountNumber}          Get Random Number String          20          #随机数
          ${BankAccountName}          Get Random Chinese String          5          #随机数
          ${BankName}          Get Random Chinese String          10          #随机数
          ${Photo1}          Get Image StreamString          ${CURDIR}\\Files\\Photo1.jpg
          ${responsedata_upload1}          上传图片(话题接口)          ${API_URL}          ${Photo1}          #先调上传图片接口得到服务器的图片保存地址
          ${Photo1_path}          Get From Dictionary          ${responsedata_upload1}          Value
          ${Photo2}          Get Image StreamString          ${CURDIR}\\Files\\Photo2.jpg
          ${responsedata_upload2}          上传图片(话题接口)          ${API_URL}          ${Photo2}          #先调上传图片接口得到服务器的图片保存地址
          ${Photo2_path}          Get From Dictionary          ${responsedata_upload2}          Value
          ${Photo3}          Get Image StreamString          ${CURDIR}\\Files\\Photo3.jpg
          ${responsedata_upload3}          上传图片(话题接口)          ${API_URL}          ${Photo3}          #先调上传图片接口得到服务器的图片保存地址
          ${Photo3_path}          Get From Dictionary          ${responsedata_upload3}          Value
          ${data}          Create Dictionary          Id=${ID}          MemberId=${userId}          UserName=${userName}          ContactEmail=${ContactEmail}          ContactPhone=${ContactPhone}
          ...          RealName=${RealName}          CardId=${CardId}          Mobile=${Mobile}          BankAccountNumber=${BankAccountNumber}          BankAccountName=${BankAccountName}          BankName=${BankName}
          ...          Photo1=${Photo1_path}          Photo2=${Photo2_path}          Photo3=${Photo3_path}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          #请求
          ${responsedata}          新增用户银行账户          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          新增银行账户成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

用户是否已经绑定手机和邮箱
          [Documentation]          *检查用户是否已经绑定了手机和邮箱*
          ...
          ...          *参数注意：userid没有做是否为分销商的有效性检查 *
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${userId}          Set Variable          881
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          UserId=${userId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${ValidBindCellAndEmail}          查询用户是否已绑定手机和邮箱          ${userId}
          #请求
          ${responsedata}          用户是否已经绑定手机和邮箱          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          参数错误          ${EMPTY}          请先在电脑端绑定邮箱、手机再进行分销相关操作
          ${Success_list}          Create List          ${EMPTY}          False          True          False
          ${Json_list}          Create List          ${EMPTY}          ParameterError_Temp(NoValue).json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}          ${ValidBindCellAndEmail}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}          ${ValidBindCellAndEmail}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}          ${ValidBindCellAndEmail}
          Delete All Sessions

已分销商品
          [Documentation]          *根据页数和页码获取用户已分销的商品*
          ...
          ...          *参数注意：接口只做了是否有参数的校验，userid没有做是否为分销商的有效性检查。PageNo参数必须大于0*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          9
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          UserId=${userId}          PageNo=${PageNo}          PageSize=${PageSize}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          #请求
          ${responsedata}          已分销商品          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          获取数据成功!
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          GetProductDistributionEd.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

可分销商品
          [Documentation]          *根据页数和页码获取用户可分销的商品。既全部的分销商品*
          ...
          ...          *参数注意：userid并不是必须参数。PageNo参数必须大于0*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          9
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          UserId=${userId}          PageNo=${PageNo}          PageSize=${PageSize}          sign=${Sign}
          ${have_zero_par}          Validate Input Parameters          P
          ...          AND          0          ${PageNo}          #判断输入参数PageNo是否等于0
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageNo}          ${PageSize}          #判断输入参数是否等于空
          #数据库
          #请求
          ${responsedata}          可分销商品          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为【真--假】的情况
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Contain          ${Message}          必须具有非负值
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_zero_par} and not ${have_not_par}          验证参数为【真--假】的情况 ，验证成功！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          参数错误          （触发了异常，单独处理！）          参数错误          获取数据成功!
          ${Success_list}          Create List          False          （触发了异常，单独处理！）          False          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          （触发了异常，单独处理！）          ParameterError_Temp(Data).json          GetProductDistribution.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_zero_par}          ${have_not_par}          #只校验为0或为空的参数
          Validate Output Results          ${Success}          ${Success_list}          ${have_zero_par}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_zero_par}          ${have_not_par}
          Delete All Sessions

添加分销商品
          [Documentation]          *用户添加分销商品*
          ...
          ...          *参数注意：分别验证勾选了集客分销商和未勾选集客分销商的情况。两种情况的输入参数不同*
          ...
          ...          *未勾选集客分销商：只需要验证用户是否为分销商、是否已经分销过该商品*
          ...
          ...          *勾选了集客分销商：需要验证用户是否为分销商、用户是否为集客分销商、用户是否已经分销过该商品*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${productId}          Get From Dictionary          ${json_manager_content}          ProductId
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${list}          Create List          0          1          #集客分销商。 0.不开启 1.开启
          ${checkDistributor}          Get Random Choice Number          ${list}          #随机选
          ${data}          Create Dictionary          userId=${userId}          productId=${productId}          shopId=${shopId}          checkDistributor=${checkDistributor}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${userId}          ${productId}          ${shopId}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${is_distribution}          查询用户是否为分销商          ${userId}
          ${is_check_distribution}          查询用户是否为集客分销商          ${userId}          ${shopId}
          ${have_distribution_product}          查询用户是否已分销过商品          ${userId}          ${productId}
          ${have_product}          查询商品是否存在          ${productId}          Product
          #请求
          ${responsedata}          添加分销商品          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par} or not ${have_product}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_not_par} or not ${have_product}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par} or not ${have_product}          当参数有为空时，服务端返回异常！验证成功！
          #验证没勾选集客分销商的情况
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list1}          Create List          商品已经分销过          分销成功          不是分销商          不是分销商
          ${Success_list1}          Create List          True          True          True          True
          ${Json_list1}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          #验证已勾选集客分销商的情况
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list2}          Create List          商品已经分销过          商品已经分销过          分销成功          您不是该商家的集客分销商          不是分销商
          ...          不是分销商          不是分销商          不是分销商
          ${Success_list2}          Create List          True          True          True          True          True
          ...          True          True          True
          ${Json_list2}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Run Keyword If          ${checkDistributor} == 0          验证未勾选集客分销商          ${Message}          ${Message_list1}          ${Success}          ${Success_list1}
          ...          ${responsedata}          ${Json_list1}          ${is_distribution}          ${have_distribution_product}
          Run Keyword If          ${checkDistributor} == 1          验证已勾选集客分销商          ${Message}          ${Message_list2}          ${Success}          ${Success_list2}
          ...          ${responsedata}          ${Json_list2}          ${is_distribution}          ${is_check_distribution}          ${have_distribution_product}
          Delete All Sessions

申请集客分销商
          [Documentation]          *用户申请集客分销商*
          ...
          ...          *参数注意：参数中未判断用户是否分销商的有效性，只要用户id和shopid不为空即可申请，并写入数据库*
          ...
          ...          *备注：该接口已经不用了，暂时标记为 filter*
          [Tags]          filter
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${data}          Create Dictionary          userId=${userId}          shopId=${shopId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${userId}          ${shopId}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          ${is_check_distribution}          查询用户是否已申请过集客分销商          ${userId}          ${shopId}
          #请求
          ${responsedata}          申请集客分销商          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为空
          Run Keyword If          ${have_not_par}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_par}          当参数有为空时，服务端返回异常！验证成功！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          你已经申请过，请等待商家处理          申请成功
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${is_check_distribution}
          Validate Output Results          ${Success}          ${Success_list}          ${is_check_distribution}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_check_distribution}
          Delete All Sessions

分销商品批量下架
          [Documentation]          *分销商品批量下架*
          ...
          ...          *参数注意：ids:商品ID,多个用，分开*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Ids}          Get From Dictionary          ${json_user_content}          Distribution_Products_ID
          Pass Execution If          "${Ids}" == ""          分销商品ID为空，改case本次不执行！
          ${Ids}          Split String          ${Ids}          [          1          #取到的字符串带[ ]，这里去掉先
          ${Ids}          Split String          ${Ids}          ]          0
          ${data}          Create Dictionary          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Ids}
          #数据库
          #请求
          ${responsedata}          分销商品批量下架          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          批量下架成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

分销订单管理
          [Documentation]          *获取用户的订单信息*
          ...
          ...          *参数注意：PageNo参数必须大于0*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          9
          ${PageSize}          Get Range Number String          1          9
          ${list}          Create List          1          2          3          4          5
          ...          #订单状态: 1：待付款 2：待发货 3：待收货 4：已关闭 5：已完成
          ${OrderStatus}          Get Random Choice Number          ${list}          #随机选
          ${data}          Create Dictionary          UserId=${UserID}          PageNo=${PageNo}          PageSize=${PageSize}          OrderStatus=${OrderStatus}          sign=${Sign}
          ${have_zero_par}          Validate Input Parameters          P
          ...          AND          0          ${PageNo}          #判断输入参数PageNo是否等于0
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}          ${PageNo}          ${PageSize}          #判断输入参数是否等于空
          #数据库
          #请求
          ${responsedata}          分销订单管理          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为【真--假】的情况
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Contain          ${Message}          必须具有非负值
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_zero_par} and not ${have_not_par}          验证参数为【真--假】的情况 ，验证成功！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          参数错误          （触发了异常，单独处理！）          参数错误          获取数据成功!
          ${Success_list}          Create List          False          （触发了异常，单独处理！）          False          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          （触发了异常，单独处理！）          ParameterError_Temp(Data).json          GetOrderDistribution.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_zero_par}          ${have_not_par}          #只校验为0或为空的参数
          Validate Output Results          ${Success}          ${Success_list}          ${have_zero_par}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_zero_par}          ${have_not_par}
          Delete All Sessions

退款记录
          [Documentation]          *获取用户的退款记录信息*
          ...
          ...          *参数注意：PageNo参数必须大于0*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          Comment          ${PageNo}          Set Variable          0
          ${PageNo}          Get Range Number String          1          9
          ${PageSize}          Get Range Number String          1          9
          ${list}          Create List          1          2          3          4          5
          ...          #订单状态: 1：待付款 2：待发货 3：待收货 4：已关闭 5：已完成
          ${OrderStatus}          Get Random Choice Number          ${list}          #随机选
          ${data}          Create Dictionary          UserId=${UserID}          PageNo=${PageNo}          PageSize=${PageSize}          OrderStatus=${OrderStatus}          sign=${Sign}
          ${have_zero_par}          Validate Input Parameters          P
          ...          AND          0          ${PageNo}          #判断输入参数PageNo是否等于0
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}          ${PageNo}          ${PageSize}          #判断输入参数是否等于空
          #数据库
          #请求
          ${responsedata}          分销退款记录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为【真--假】的情况
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Contain          ${Message}          必须具有非负值
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_zero_par} and not ${have_not_par}          验证参数为【真--假】的情况 ，验证成功！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          参数错误          （触发了异常，单独处理！）          参数错误          获取数据成功！
          ${Success_list}          Create List          False          （触发了异常，单独处理！）          False          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          （触发了异常，单独处理！）          ParameterError_Temp(Data).json          GetOrderDistribution.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_zero_par}          ${have_not_par}          #只校验为0或为空的参数
          Validate Output Results          ${Success}          ${Success_list}          ${have_zero_par}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_zero_par}          ${have_not_par}
          Delete All Sessions

分销收益统计
          [Documentation]          *用户分销收益统计*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${pageIndex}          Get Range Number String          1          9
          ${pageSize}          Get Range Number String          1          9
          ${list}          Create List          0          1          #收益统计 0:未结账，1:已结账
          ${status}          Get Random Choice Number          ${list}          #随机选
          ${data}          Create Dictionary          userId=${userId}          pageIndex=${pageIndex}          pageSize=${pageSize}          status=${status}          sign=${Sign}
          ${have_zero_par}          Validate Input Parameters          P
          ...          AND          0          ${pageIndex}          #判断输入参数PageNo是否等于0
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${userId}          ${pageIndex}          ${pageSize}          #判断输入参数是否有空值
          #数据库
          #请求
          ${responsedata}          分销收益统计          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数为【真--假】的情况
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Contain          ${Message}          必须具有非负值
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Should Be True          ${Success} == 0
          Run Keyword If          ${have_zero_par} and not ${have_not_par}          Validate Json          StackTrace_Temp.json          ${responsedata}
          Pass Execution If          ${have_zero_par} and not ${have_not_par}          验证参数为【真--假】的情况 ，验证成功！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          （触发了异常，单独处理！）          ${EMPTY}          获取数据成功!
          ${Success_list}          Create List          ${EMPTY}          （触发了异常，单独处理！）          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          （触发了异常，单独处理！）          ${EMPTY}          GetOrderDistribution.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_zero_par}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_zero_par}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_zero_par}          ${have_not_par}
          Delete All Sessions

获取分销提现数据
          [Documentation]          *提现：获取提现数据*
          ...
          ...          *参数注意：userid没有做是否为分销商的有效性检查。*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          UserId=${userId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          获取分销提现数据          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          查询成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          GetWithDrawData.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

提交分销提现
          [Documentation]          *提现：提交分销提现申请*
          ...
          ...          *参数注意：userid没有做有效性检查。*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${userName}          Get From Dictionary          ${json_user_content}          UserName
          ${WithdrawAmount}          Get Random Number String          2
          ${data}          Create Dictionary          MemberId=${userId}          MemberName=${userName}          WithdrawAmount=${WithdrawAmount}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          提交分销提现          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          提现成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

完成提现
          [Documentation]          *提现：完成提现*
          ...
          ...          *参数注意：*
          ...
          ...          *暂时tag标记为 filter , 似乎接口还有点问题，调试时一直报异常*
          [Tags]          filter
          Fail          *似乎接口还有点问题，调试时一直报异常*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Set Variable          674
          Comment          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          memberId=${userId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          完成提现          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          参数错误          查询成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(NoValue).json          GetWithDrawData.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

*** Keywords ***
