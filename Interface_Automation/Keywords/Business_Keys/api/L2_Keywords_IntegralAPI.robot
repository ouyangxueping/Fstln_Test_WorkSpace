*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询是否为积分商品
          [Arguments]          ${ProductId}
          [Documentation]          *验证是否为积分商品*
          ...
          ...          *参数：ProductId：商品ID*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_memberintegralproduct where ProductId="${ProductId}"          0
          ${status}          Evaluate          not ${status}
          Disconnect From Database
          [Return]          ${status}

查询用户对应的积分商品数据
          [Arguments]          ${SkuId}          ${userId}
          [Documentation]          *分别从多个数据库表中获取数据，组成一个字典*
          ...
          ...          *参数：SkuId：SkuID \ userId:用户ID*
          ...
          ...          *返回：用户对对应的积分商品数据*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query1}          Query          select Grade from azt_memberexp INNER JOIN azt_membergrade ON azt_memberexp.Exp >= azt_membergrade.Exp where MemberId="${userId}" ORDER BY Grade DESC
          ${Query2}          Query          select ExchangeGrade,azt_skus.ProductId,ProductName,ExchangeNum-ExchangeedNum,Stock,SalePrice from ((azt_memberintegralproduct INNER JOIN azt_products ON azt_products.id = azt_memberintegralproduct.ProductId) INNER JOIN azt_skus ON azt_skus.ProductId = azt_products.id) where azt_skus.id="${SkuId}"
          ${Query3}          Query          select IntegralPerMoney from azt_memberintegralexchangerules
          ${Query4}          Query          select AvailableIntegrals from azt_memberintegral where MemberId="${userId}"
          ${Validate_Value}          Create Dictionary
          Set To Dictionary          ${Validate_Value}          UserGrade=${Query1[0][0]}
          Set To Dictionary          ${Validate_Value}          ExchangeGrade=${Query2[0][0]}
          Set To Dictionary          ${Validate_Value}          ProductId=${Query2[0][1]}
          Set To Dictionary          ${Validate_Value}          ProductName=${Query2[0][2]}
          Set To Dictionary          ${Validate_Value}          ExchangeNum=${Query2[0][3]}
          Set To Dictionary          ${Validate_Value}          Quantity=${Query2[0][4]}
          Set To Dictionary          ${Validate_Value}          SalePrice=${Query2[0][5]}
          Set To Dictionary          ${Validate_Value}          IntegralPerMoney=${Query3[0][0]}
          Set To Dictionary          ${Validate_Value}          UserIntegral=${Query4[0][0]}
          Disconnect From Database
          [Return]          ${Validate_Value}

获取积分商品(GET)
          [Arguments]          ${API_URL}          ${data}
          ${skuId}          Get From Dictionary          ${data}          skuId
          ${userId}          Get From Dictionary          ${data}          userId
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          getIntegralProduct          ${API_URL}          ${header}          #建立连接
          ${response}          Get Request          getIntegralProduct          api/integral/getIntegralProduct/${skuId}/${userId}          #发送post请求
          ${responsedata}          To Json          ${response.content}          #取出返回值内容转化为joson格式
          [Return]          ${responsedata}

获取积分商品(POST)
          [Arguments]          ${API_URL}          ${data}
          ${skuId}          Get From Dictionary          ${data}          skuId
          ${userId}          Get From Dictionary          ${data}          userId
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          getIntegralProduct          ${API_URL}          ${header}          #建立连接
          ${response}          Post Request          getIntegralProduct          api/integral/getIntegralProduct/${skuId}/${userId}          #发送post请求
          ${responsedata}          To Json          ${response.content}          #取出返回值内容转化为joson格式
          [Return]          ${responsedata}

获取轮播图配置数据
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          GetIntegralConfig          ${API_URL}          ${header}          #建立连接
          ${response}          Post Request          GetIntegralConfig          api/Integral/GetIntegralConfig          #发送post请求
          ${responsedata}          To Json          ${response.content}          #取出返回值内容转化为joson格式
          [Return]          ${responsedata}

获取精品推荐数据列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          GetTopProductList          ${API_URL}          ${header}
          ${response}          Post Request          GetTopProductList          api/Integral/GetTopProductList          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
