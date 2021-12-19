*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户是否提交过申请资质
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is 0          select * from azt_distribution_person where MemberId="${userId}"
          Disconnect From Database
          ${status}          Evaluate          not ${status}
          [Return]          ${status}

查询用户当前详情信息
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query1}          Query          select * from azt_distribution_person where MemberId="${userId}"
          ${Query2}          Query          select UserName,LastLoginDate,Email,CellPhone from azt_members where id="${userId}"
          ${Query3}          Query          select value from azt_appsettings where `Key`="ImageServerUrl"          #key为mysql关键字不能直接用，需要转义。(键盘的~这个键)
          ${Validate_Value}          Create Dictionary
          Set To Dictionary          ${Validate_Value}          Id=${Query1[0][0]}
          Set To Dictionary          ${Validate_Value}          MemberId=${Query1[0][1]}
          Set To Dictionary          ${Validate_Value}          UserName=${Query2[0][0]}
          ${Query2[0][1]}          Convert To String          ${Query2[0][1]}
          ${Query2[0][1]}          Split String          ${Query2[0][1]}          ${SPACE}          0
          Set To Dictionary          ${Validate_Value}          LastLoginTime=${Query2[0][1]}
          Set To Dictionary          ${Validate_Value}          ContactEmail=${Query2[0][2]}
          Set To Dictionary          ${Validate_Value}          ContactPhone=${Query2[0][3]}
          Set To Dictionary          ${Validate_Value}          RealName=${Query1[0][2]}
          Set To Dictionary          ${Validate_Value}          CardId=${Query1[0][3]}
          Set To Dictionary          ${Validate_Value}          Mobile=${Query1[0][4]}
          Set To Dictionary          ${Validate_Value}          Photo1=${Query1[0][5]}
          Set To Dictionary          ${Validate_Value}          FaceOfIdCard=${Query3[0][0]}${Query1[0][5]}
          Set To Dictionary          ${Validate_Value}          Photo2=${Query1[0][6]}
          Set To Dictionary          ${Validate_Value}          BackOfIdCard=${Query3[0][0]}${Query1[0][6]}
          Set To Dictionary          ${Validate_Value}          Photo3=${Query1[0][7]}
          Set To Dictionary          ${Validate_Value}          HandheldIDCard=${Query3[0][0]}${Query1[0][7]}
          Set To Dictionary          ${Validate_Value}          AuditStatus=${Query1[0][11]}
          ${list}          Create List          待审核          已通过          不通过          #状态 1提交审核，2已通过，3不通过
          ${index}          Evaluate          int(${Query1[0][11]}) - 1
          ${Status}          Get From List          ${list}          ${index}
          Set To Dictionary          ${Validate_Value}          Status=${Status}
          Set To Dictionary          ${Validate_Value}          RefuseReason=${Query1[0][12]}
          Set To Dictionary          ${Validate_Value}          BankAccountNumber=${Query1[0][8]}
          Set To Dictionary          ${Validate_Value}          BankAccountName=${Query1[0][9]}
          Set To Dictionary          ${Validate_Value}          BankName=${Query1[0][10]}
          ${Query1[0][14]}          Convert To String          ${Query1[0][14]}
          ${Query1[0][14]}          Replace String          ${Query1[0][14]}          ${SPACE}          T
          Set To Dictionary          ${Validate_Value}          AuditTime=${Query1[0][14]}
          ${Query1[0][13]}          Convert To String          ${Query1[0][13]}
          ${Query1[0][13]}          Replace String          ${Query1[0][13]}          ${SPACE}          T
          Set To Dictionary          ${Validate_Value}          CreateTime=${Query1[0][13]}
          ${Query1[0][13]}          Convert To String          ${Query1[0][13]}
          ${Query1[0][13]}          Split String          ${Query1[0][13]}          T          0
          Set To Dictionary          ${Validate_Value}          CreateTimeDisplay=${Query1[0][13]}
          Disconnect From Database
          [Return]          ${Validate_Value}

查询用户是否为分销商
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is 0          select * from azt_distribution_person where MemberId="${userId}" and AuditStatus="2"          #判断用户是否为分销商
          Disconnect From Database
          ${status}          Evaluate          not ${status}
          [Return]          ${status}

查询用户是否为集客分销商
          [Arguments]          ${userId}          ${shopId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is 0          select * from azt_shop_distributor where MemberId="${userId}" and ShopId="${shopId}" and STATUS="1"          #判断用户是否为店铺的集客分销商
          Disconnect From Database
          ${status}          Evaluate          not ${status}
          [Return]          ${status}

查询用户是否已申请过集客分销商
          [Arguments]          ${userId}          ${shopId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is 0          select * from azt_shop_distributor where MemberId="${userId}" and ShopId="${shopId}" and STATUS="0"          #判断用户是否为店铺的集客分销商
          Disconnect From Database
          ${status}          Evaluate          not ${status}
          [Return]          ${status}

查询用户是否已分销过商品
          [Arguments]          ${userId}          ${productId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is 0          select * from azt_distribution_product where MemberId="${userId}" and ProductId="${productId}"          #判断用户是否已分销过该商品
          Disconnect From Database
          ${status}          Evaluate          not ${status}
          [Return]          ${status}

验证未勾选集客分销商
          [Arguments]          ${Message}          ${Message_list}          ${Success}          ${Success_list}          ${responsedata}          ${Json_list}
          ...          ${is_distribution}          ${have_distribution_product}
          [Documentation]          *参数说明：(按顺序依次)*
          ...
          ...          *Message、Message列表、Success、Success列表、responsedata、json模板列表、是否为分销商变量、是否已经分销过商品变量*
          Validate Output Results          ${Message}          ${Message_list}          ${is_distribution}          ${have_distribution_product}
          Validate Output Results          ${Success}          ${Success_list}          ${is_distribution}          ${have_distribution_product}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_distribution}          ${have_distribution_product}

验证已勾选集客分销商
          [Arguments]          ${Message}          ${Message_list}          ${Success}          ${Success_list}          ${responsedata}          ${Json_list}
          ...          ${is_distribution}          ${is_check_distribution}          ${have_distribution_product}
          [Documentation]          *参数说明：(按顺序依次)*
          ...
          ...          *Message、Message列表、Success、Success列表、responsedata、json模板列表、是否为分销商变量、是否为集客分销商变量、是否已经分销过商品变量*
          Validate Output Results          ${Message}          ${Message_list}          ${is_distribution}          ${is_check_distribution}          ${have_distribution_product}
          Validate Output Results          ${Success}          ${Success_list}          ${is_distribution}          ${is_check_distribution}          ${have_distribution_product}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_distribution}          ${is_check_distribution}          ${have_distribution_product}

用户是否已经绑定手机和邮箱
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          DistributionEnter          ${API_URL}          ${header}
          ${response}          Post Request          DistributionEnter          api/Distribution/DistributionEnter          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

已分销商品
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ProductDistributionEd          ${API_URL}          ${header}
          ${response}          Post Request          ProductDistributionEd          api/Distribution/ProductDistributionEd          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

可分销商品
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ProductDistribution          ${API_URL}          ${header}
          ${response}          Post Request          ProductDistribution          api/Distribution/ProductDistribution          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

添加分销商品
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          AddDistributionProduct          ${API_URL}          ${header}
          ${response}          Post Request          AddDistributionProduct          api/Distribution/AddDistributionProduct          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

申请集客分销商
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ApplyForDistributor          ${API_URL}          ${header}
          ${response}          Post Request          ApplyForDistributor          api/Distribution/ApplyForDistributor          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

分销订单管理
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          OrderDistribution          ${API_URL}          ${header}
          ${response}          Post Request          OrderDistribution          api/Distribution/OrderDistribution          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

分销退款记录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          RefundDistribution          ${API_URL}          ${header}
          ${response}          Post Request          RefundDistribution          api/Distribution/RefundDistribution          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

分销收益统计
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          IncomeStatistics          ${API_URL}          ${header}
          ${response}          Post Request          IncomeStatistics          api/Distribution/IncomeStatistics          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取分销提现数据
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          GetWithDrawData          ${API_URL}          ${header}
          ${response}          Post Request          GetWithDrawData          api/Distribution/GetWithDrawData          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

提交分销提现
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          SubmitWithdraw          ${API_URL}          ${header}
          ${response}          Post Request          SubmitWithdraw          api/Distribution/SubmitWithdraw          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

完成提现
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ConfirmWithdraw          ${API_URL}          ${header}
          ${response}          Post Request          ConfirmWithdraw          api/Distribution/ConfirmWithdraw          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取当前用户详情
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          get_UserBaseInfo          ${API_URL}          ${header}
          ${response}          Post Request          get_UserBaseInfo          api/Distribution/UserBaseInfo          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

更新用户银行账户信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Update_BankAccount          ${API_URL}          ${header}
          ${response}          Post Request          Update_BankAccount          api/Distribution/UpdateBankAccount          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

新增用户银行账户
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          AddAccount          ${API_URL}          ${header}
          ${response}          Post Request          AddAccount          api/Distribution/AddAccount          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

分销商品批量下架
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          DeleteDistributionProduct          ${API_URL}          ${header}
          ${response}          Post Request          DeleteDistributionProduct          api/Distribution/DeleteDistributionProduct          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
