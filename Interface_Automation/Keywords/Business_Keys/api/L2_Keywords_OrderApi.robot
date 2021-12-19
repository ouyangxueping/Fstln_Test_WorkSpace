*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询购物车内是否存在商品
          [Arguments]          ${userId}          ${skuID}
          [Documentation]          *查询购物车内是否存在商品*
          ...
          ...          *参数：userID、skuID*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select id from azt_shoppingcarts where UserId="${userId}" and skuid="${skuID}"          1
          Disconnect From Database
          [Return]          ${status}

查询收货地址是否存在
          [Arguments]          ${select}
          [Documentation]          *查询参数：收货地址ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_shippingaddresses where id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询商品的sku是否存在
          [Arguments]          ${select_type}={ProductId}
          [Documentation]          *查询商品的skuid*
          ...
          ...          *参数：skuid*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "{Id_type}]= ="${ProductId}"          Run Keyword And Return Status          Row Count Is Equal To X          select id from azt_skus \ where id='${ProductId}'          1
          Disconnect From Database
          [Return]          ${status}

查询用户订单存在数量
          [Arguments]          ${userId}          ${order_status}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          select * from azt_orders where userid="${userId}" and OrderStatus="${order_status}" and Website="1"
          ${Count}          Set Variable          ${Count[0][0]}
          Disconnect From Database

立即购买下单
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          SubmitOrderPost          ${API_URL}          ${header}
          ${response}          Post Request          SubmitOrderPost          api/Order/SubmitOrderPost          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

购物车下单
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          SubmitOrderByCart          ${API_URL}          ${header}
          ${response}          Post Request          SubmitOrderByCart          api/Order/SubmitOrderByCart          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

计算单个商品运费(GET)
          [Arguments]          ${API_URL}          ${skuId}          ${counts}          ${addressId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_GetSingleFreight_get          ${API_URL}          ${header}
          ${response}          Get Request          Order_GetSingleFreight_get          api/Order/GetSingleFreight/${skuId}/${counts}/${addressId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

计算单个商品运费(POST)
          [Arguments]          ${API_URL}          ${skuId}          ${counts}          ${addressId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_GetSingleFreight_post          ${API_URL}          ${header}
          ${response}          Post Request          Order_GetSingleFreight_post          api/Order/GetSingleFreight/${skuId}/${counts}/${addressId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

计算整店商品运费(GET)
          [Arguments]          ${API_URL}          ${cartItemIds}          ${userId}          ${addressId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_GetShopFreight_get          ${API_URL}          ${header}
          ${response}          Get Request          Order_GetShopFreight_get          api/Order/GetShopFreight/${cartItemIds}/${userId}/${addressId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

计算整店商品运费(POST)
          [Arguments]          ${API_URL}          ${cartItemIds}          ${userId}          ${addressId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_GetShopFreight_post          ${API_URL}          ${header}
          ${response}          Post Request          Order_GetShopFreight_post          api/Order/GetShopFreight/${cartItemIds}/${userId}/${addressId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

我的订单列表(GET)
          [Arguments]          ${API_URL}          ${UserId}          ${Status}          ${PageNo}          ${PageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_List_get          ${API_URL}          ${header}
          ${response}          Get Request          Order_List_get          api/Order/List/${UserId}/${Status}/${PageNo}/${PageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

我的订单列表(POST)
          [Arguments]          ${API_URL}          ${UserId}          ${Status}          ${PageNo}          ${PageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_List_post          ${API_URL}          ${header}
          ${response}          Post Request          Order_List_post          api/Order/List/${UserId}/${Status}/${PageNo}/${PageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

查询订单详情(GET)
          [Arguments]          ${API_URL}          ${orderId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_Detail_get          ${API_URL}          ${header}
          ${response}          Get Request          Order_Detail_get          api/Order/Detail/${orderId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

查询订单详情(POST)
          [Arguments]          ${API_URL}          ${orderId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_Detail_post          ${API_URL}          ${header}
          ${response}          Post Request          Order_Detail_post          api/Order/Detail/${orderId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

取消订单(GET)
          [Arguments]          ${API_URL}          ${orderId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_Cancel_get          ${API_URL}          ${header}
          ${response}          Get Request          Order_Cancel_get          api/Order/Cancel/${orderId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

取消订单(POST)
          [Arguments]          ${API_URL}          ${orderId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_Cancel_post          ${API_URL}          ${header}
          ${response}          Post Request          Order_Cancel_post          api/Order/Cancel/${orderId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

确认收货(GET)
          [Arguments]          ${API_URL}          ${orderId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_ConfirmReceipt_get          ${API_URL}          ${header}
          ${response}          Get Request          Order_ConfirmReceipt_get          api/Order/ConfirmReceipt/${orderId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

确认收货(POST)
          [Arguments]          ${API_URL}          ${orderId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Order_ConfirmReceipt_post          ${API_URL}          ${header}
          ${response}          Post Request          Order_ConfirmReceipt_post          api/Order/ConfirmReceipt/${orderId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

查询微信支付订单(GET)
          [Arguments]          ${API_URL}          ${sourceType}          ${orderIds}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          weixinpayOrderQuery_get          ${API_URL}          ${header}
          ${response}          Get Request          weixinpayOrderQuery_get          api/weixinpayOrderQuery/${sourceType}/${orderIds}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

查询微信支付订单(POST)
          [Arguments]          ${API_URL}          ${sourceType}          ${orderIds}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          weixinpayOrderQuery_post          ${API_URL}          ${header}
          ${response}          Post Request          weixinpayOrderQuery_post          api/weixinpayOrderQuery/${sourceType}/${orderIds}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取物流信息
          [Arguments]          ${API_URL}          ${orderId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          order_Express          ${API_URL}          ${header}
          ${response}          Get Request          order_Express          api/order/Express/${orderId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

APP微信支付
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          weixinapppay          ${API_URL}          ${header}
          ${response}          Post Request          weixinapppay          api/weixinapppay          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

APP支付宝支付
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          aliapppay          ${API_URL}          ${header}
          ${response}          Post Request          aliapppay          api/aliapppay          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
