*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户是否已收藏商品
          [Arguments]          ${select1}          ${select2}
          [Documentation]          *参数：1、用户ID \ \ 2、商品ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_favorites where UserId="${select1} " and ProductId="${select2}"          0
          Disconnect From Database
          [Return]          ${status}

计算商品会员价和活动价(GET)
          [Arguments]          ${API_URL}          ${productIds}          ${shopId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_GetMemberPrice          ${API_URL}          ${header}
          ${response}          Get Request          product_GetMemberPrice          api/product/GetMemberPrice/${productIds}/${shopId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

计算商品会员价和活动价(POST)
          [Arguments]          ${API_URL}          ${productIds}          ${shopId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_GetMemberPrice          ${API_URL}          ${header}
          ${response}          Post Request          product_GetMemberPrice          api/product/GetMemberPrice/${productIds}/${shopId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

商品统计
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          report_product          ${API_URL}          ${header}
          ${response}          Post Request          report_product          api/report/product          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商品详情(GET)
          [Arguments]          ${API_URL}          ${productId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_detail          ${API_URL}          ${header}
          ${response}          Get Request          product_detail          api/product/detail/${productId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商品详情(POST)
          [Arguments]          ${API_URL}          ${productId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_detail          ${API_URL}          ${header}
          ${response}          Post Request          product_detail          api/product/detail/${productId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

搜索商品
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_GetSearchProduct          ${API_URL}          ${header}
          ${response}          Post Request          product_GetSearchProduct          api/product/GetSearchProduct          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商品关联的播放器和视频(GET)
          [Arguments]          ${API_URL}          ${productId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_GetGetStoreViedoId          ${API_URL}          ${header}
          ${response}          Get Request          product_GetGetStoreViedoId          api/product/GetGetStoreViedoId/${productId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商品关联的播放器和视频(POST)
          [Arguments]          ${API_URL}          ${productId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_GetGetStoreViedoId          ${API_URL}          ${header}
          ${response}          Post Request          product_GetGetStoreViedoId          api/product/GetGetStoreViedoId/${productId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商品SKU详情(GET)
          [Arguments]          ${API_URL}          ${skuId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          productsku_detail          ${API_URL}          ${header}
          ${response}          Get Request          productsku_detail          api/productsku/detail/${skuId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商品SKU详情(POST)
          [Arguments]          ${API_URL}          ${skuId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          productsku_detail          ${API_URL}          ${header}
          ${response}          Post Request          productsku_detail          api/productsku/detail/${skuId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

批量添加收藏
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_add          ${API_URL}          ${header}
          ${response}          Post Request          product_favorite_add          api/product/favorite/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

批量取消收藏
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_cancel          ${API_URL}          ${header}
          ${response}          Post Request          product_favorite_cancel          api/product/favorite/cancel          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收藏列表-不分页(GET)
          [Arguments]          ${API_URL}          ${userId}          ${website}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_list          ${API_URL}          ${header}
          ${response}          Get Request          product_favorite_list          api/product/favorite/list/${userId}/${website}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收藏列表-不分页(POST)
          [Arguments]          ${API_URL}          ${userId}          ${website}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_list          ${API_URL}          ${header}
          ${response}          Post Request          product_favorite_list          api/product/favorite/list/${userId}/${website}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收藏列表-分页(GET)
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}          ${website}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_pageList          ${API_URL}          ${header}
          ${response}          Get Request          product_favorite_pageList          api/product/favorite/pageList/${userId}/${pageNo}/${pageSize}/${website}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收藏列表-分页(POST)
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}          ${website}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_pageList          ${API_URL}          ${header}
          ${response}          Post Request          product_favorite_pageList          api/product/favorite/pageList/${userId}/${pageNo}/${pageSize}/${website}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

判断收藏商品(GET)
          [Arguments]          ${API_URL}          ${userId}          ${productId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_GetFavoritesUser          ${API_URL}          ${header}
          ${response}          Get Request          product_favorite_GetFavoritesUser          api/product/favorite/GetFavoritesUser/${userId}/${productId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

判断收藏商品(POST)
          [Arguments]          ${API_URL}          ${userId}          ${productId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          product_favorite_GetFavoritesUser          ${API_URL}          ${header}
          ${response}          Post Request          product_favorite_GetFavoritesUser          api/product/favorite/GetFavoritesUser/${userId}/${productId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
