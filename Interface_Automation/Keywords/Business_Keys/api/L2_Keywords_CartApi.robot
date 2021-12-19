*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户购物车信息
          [Arguments]          ${UserId}          ${SkuItemId}
          [Documentation]          *查询用户购物车ID*
          ...
          ...          *参数：UserId、SkuItemId*
          ...
          ...          *返回： 用户加入购物车的购物车id和商品数量*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${query}          Query          select id,Quantity from azt_shoppingcarts where SkuId="${SkuItemId}" and UserId="${UserId}"
          ${query_len}          Get Length          ${query}
          ${User_ShoppingCartsID}          Set Variable If          ${query_len} == 0          ${EMPTY}          ${query[0][0]}
          ${User_ShoppingCartsCount}          Set Variable If          ${query_len} == 0          ${EMPTY}          ${query[0][1]}
          Disconnect From Database
          [Return]          ${User_ShoppingCartsID}          ${User_ShoppingCartsCount}

清空购物车
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          Execute Sql String          delete from azt_shoppingcarts where UserId="${userId}"
          Disconnect From Database

获取购物车列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          cart_list          ${API_URL}          ${header}
          ${response}          Post Request          cart_list          api/cart/list          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

加入购物车
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          cart_add          ${API_URL}          ${header}
          ${response}          Post Request          cart_add          api/cart/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

购物车删除商品
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          cart_remove          ${API_URL}          ${header}
          ${response}          Post Request          cart_remove          api/cart/remove          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

购物车中更新购买数量
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          cart_updatecount          ${API_URL}          ${header}
          ${response}          Post Request          cart_updatecount          api/cart/updatecount          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
