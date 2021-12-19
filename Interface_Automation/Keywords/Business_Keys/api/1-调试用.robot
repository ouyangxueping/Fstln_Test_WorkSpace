*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_ReviewApi.txt

*** Test Cases ***
数据库操作(模板)
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query1}          Query          select * from azt_distribution_person where MemberId="633"
          ${Query2}          Query          select UserName,LastLoginDate,Email,CellPhone from azt_members where id="633"
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
          ${list}          Create List          提交审核          已通过          不通过          #状态 1提交审核，2已通过，3不通过
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
          log          ${Validate_Value}

数据库操作(谭)
          ${Validate_Value}          查询          878
          ${Validate_Value}          Evaluate          str(${Validate_Value})
          Comment          ${Validate_Value}          判断          841
          Comment          log          ${Validate_Value}
          ${list}          Create List          2          7          21          30          #经验值翻倍的天数
          ${have_double_exp}          Run Keyword And Return Status          List Should Contain Value          ${list}          ${Validate_Value}          用户未达到经验值翻倍的条件！

接口模板(谭)
          [Documentation]          *XXXX*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${skuId}          Get From Dictionary          ${json_manager_content}          SkuId
          ${count}          Get Random Number String          1          #随机取个数量
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${sourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${sourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${data}          Create Dictionary          userId=${userId}          skuId=${skuId}          count=${count}          storeId=${storeId}          sourceType=${sourceType}
          ...          sourceId=${sourceId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          接口          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          Comment          （对应的条件组合顺序表）          真          假
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Get_CartList(NoPromotion).json          Get_CartList(NoProduct).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}
          Delete All Sessions

点赞评论（范例）
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${SourceName}          Get From Dictionary          ${json_manager_content}          SourceName
          ${data}          Create Dictionary          userId=${userId}          shopId=${shopId}          shopName=${shopName}          storeId=${storeId}          storeName=${storeName}
          ...          videoId=${videoId}          videoName=${videoName}          SourceType=${SourceType}          SourceId=${SourceId}          SourceName=${SourceName}
          ${status}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${shopId}          ${shopName}          ${storeId}          ${storeName}
          ...          ${videoId}          ${videoName}
          #数据库
          #请求
          ${responsedata}          评论点赞          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          True
          ${Success_list}          Create List          True          None
          ${Json_list}          Create List          Common_Temp(None).json          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${status}
          Validate Output Results          ${Success}          ${Success_list}          ${status}
          Validate Output Results          ${Json_list}          ${responsedata}          ${status}
          Delete All Sessions

Test
          ${json_user_content}          读取买家通用数据
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          #创建参数字典
          Comment          ${Phone}          Set Variable          1234567
          ${Phone}          Get From Dictionary          ${json_user_content}          Phone
          ${Email}          Get From Dictionary          ${json_user_content}          Email
          ${list1}          Create List          ${Phone}          ${Email}          #手机号或邮箱
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}

*** Keywords ***
判断
          [Arguments]          ${select}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_review where id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询
          [Arguments]          ${select}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query}          Query          select ContinuousSignInDays from azt_member_signin where date(SignInTime)<=date(now()) and MemberId="${select}" Order by SignInTime DESC
          Disconnect From Database
          ${Query}=          Set Variable If          ${Query}==[]          0          ${Query[0][0]}
          [Return]          ${Query}

校验
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
          ${list}          Create List          提交审核          已通过          不通过          #状态 1提交审核，2已通过，3不通过
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

接口
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          cart_add          ${API_URL}          ${header}
          ${response}          Post Request          cart_add          api/cart/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

接口2
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shopvipcard_list          ${API_URL}          ${header}
          ${response}          Get Request          shopvipcard_list          api/shopvipcard/list/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
