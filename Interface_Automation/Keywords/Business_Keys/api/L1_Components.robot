*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt

*** Keywords ***
上传图片(保存视频)
          [Arguments]          ${imageStreamString}          ${shopId}
          ${data}          Create Dictionary          imageStreamString=${imageStreamString}          shopId=${shopId}          sign=${sign}
          #请求
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          api_seller_saveimage          ${API_URL}          ${header}
          ${response}          Post Request          api_seller_saveimage          api/seller/saveimage          data=${data}
          [Return]          ${response}

上传图片(保存商品)
          [Arguments]          ${imageStreamString}          ${shopId}
          ${data}          Create Dictionary          imageStreamString=${imageStreamString}          shopId=${shopId}          sign=${sign}
          #请求
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Api_Seller_Product_UploadImages          ${API_URL}          ${header}
          ${response}          Post Request          Api_Seller_Product_UploadImages          Api/Seller/Product/UploadImages          data=${data}
          [Return]          ${response}

获取手机验证码(商家)
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Code}          Query          SELECT MessageContent FROM \ azt_messagelog ORDER BY sendtime DESC LIMIT 1
          Disconnect From Database
          ${Code1}          Format String          ${Code[0][0]}
          ${Code}          Split String          ${Code1}          验证码是          1
          ${Code}          Split String          ${Code}          ,请在页面填          0
          Should Not Contain          ${Code}          @          获取的验证码不对，可能是没生成验证码。请检查原因。。。
          [Return]          ${Code}

数据库获取验证码
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=192.168.1.205;Port=3306;Database=test_mall_v03;User=azttest;Password=azttest;"
          ${Code}          Query          SELECT MessageContent FROM \ azt_messagelog ORDER BY sendtime DESC LIMIT 1
          Disconnect From Database
          ${Code1}          Format String          ${Code[0][0]}
          ${Code}          Split String          ${Code1}          验证码是          1
          ${Code}          Split String          ${Code}          ,请在页面填          0
          Should Not Contain          ${Code}          @          获取的验证码不对，可能是没生成验证码。请检查原因。。。
          [Return]          ${Code}

查询店铺是否被冻结
          [Arguments]          ${store_id}
          [Documentation]          *查询参数：shop ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_shops where Id="${store_id}" and ShopStatus="6"          0
          Disconnect From Database
          [Return]          ${status}

查询视频店铺是否存在
          [Arguments]          ${select}
          [Documentation]          *查询参数：store ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from (t_sysmgr_store_video INNER JOIN t_sysmgr_video ON t_sysmgr_store_video.video_id=t_sysmgr_video.id) INNER JOIN t_sysmgr_store ON t_sysmgr_store_video.store_id=t_sysmgr_store.Id where t_sysmgr_store.Id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询视频店铺是否有效
          [Arguments]          ${store_id}
          [Documentation]          *查询参数：store ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from t_sysmgr_store_video where store_id="${store_id}"          0
          Disconnect From Database
          [Return]          ${status}

查询视频店铺是否在线
          [Arguments]          ${select}
          [Documentation]          *查询参数：store ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from t_sysmgr_store where id="${select}" and status="1"          0
          Disconnect From Database
          [Return]          ${status}

查询视频店铺下是否存在商品
          [Arguments]          ${select}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from t_sysmgr_store_product INNER JOIN azt_products ON t_sysmgr_store_product.product_id=azt_products.id where t_sysmgr_store_product.store_id="${select}" and azt_products.EditStatus="0" and azt_products.SaleStatus="1" and azt_products.AuditStatus="2"          0
          Disconnect From Database
          [Return]          ${status}

查询商家是否存在
          [Arguments]          ${select}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_shops where Id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询用户是否已绑定手机和邮箱
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query}          Query          select Email,CellPhone from azt_members where id="${userId}"
          ${status1}          Set Variable If          "${Query[0][0]}" == "None" or "${Query[0][0]}" == ""          True          False
          ${status2}          Set Variable If          "${Query[0][1]}" == "None" or "${Query[0][1]}" == ""          True          False
          ${status}          Set Variable If          ${status1}==False and ${status2}==False          True          False
          #还要查询azt_membercontacts表
          ${Query}          Query          select id from azt_membercontacts where UserId="${userId}"
          ${Query_len}          Get Length          ${Query}
          ${status}          Set Variable If          ${status} == True and ${Query_len} > 1          True          False
          ${status}          Evaluate          bool(${status})
          Disconnect From Database
          [Return]          ${status}

查询用户是否存在
          [Arguments]          ${user}          ${select_type}=ID
          [Documentation]          *验证用户是否存在*
          ...
          ...          *参数：user*
          ...
          ...          *参数：select_type: 查询的类型,表示按什么字段来查询用户。可选值：ID（默认） 、 Name*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${select_type}" == "ID"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_members where id="${user}"          0
          ...          ELSE IF          "${select_type}" == "Name"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_members where UserName="${user}"          0
          Disconnect From Database
          [Return]          ${status}

查询用户是否已点赞
          [Arguments]          ${MemberId}          ${SourceType}          ${SourceId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_praisedpublic where MemberId="${MemberId}" and SourceType="${SourceType}" and SourceId="${SourceId}"          0
          Disconnect From Database
          [Return]          ${status}

查询用户是否存在订单
          [Arguments]          ${userId}          ${order_status}
          [Documentation]          *查询用户是否存在订单*
          ...
          ...          *参数：userID、order_status*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_orders where userid="${userId}" and OrderStatus="${order_status}"          0
          Disconnect From Database
          [Return]          ${status}

查询商品是否存在
          [Arguments]          ${Id}          ${Id_type}
          [Documentation]          *验证商品是否存在*
          ...
          ...          *参数：Id: 待查询的ID值*
          ...
          ...          *参数：Id_type: 待查询的ID类型,表示按什么来查询验证商品。可选值：Product 、 SKU*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${Id_type}" == "SKU"          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_skus where id="${Id}"          0
          ...          ELSE IF          "${Id_type}" == "Product"          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_products where id="${Id}"          0
          ...          ELSE          Fail          查询商品出错！！可能是参数有误
          ${status}          Evaluate          not ${status}
          Disconnect From Database
          [Return]          ${status}

查询商品是否有效
          [Arguments]          ${Id}          ${Id_type}
          [Documentation]          *查询商品是否正在销售中*
          ...
          ...          *参数：Id: 待查询的ID值*
          ...
          ...          *参数：Id_type: 待查询的ID类型,表示按什么来查询验证商品。可选值：Product 、 SKU*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${Id_type}" == "SKU"          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_skus INNER JOIN azt_products ON azt_skus.ProductId = azt_products.Id where azt_skus.Id="${Id}" and azt_products.SaleStatus="1" and azt_products.EditStatus="0"          1
          ...          ELSE IF          "${Id_type}" == "Product"          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_products where id="${Id}" and SaleStatus="1" \ and EditStatus="0"          1
          ...          ELSE          Fail          查询商品出错！！可能是参数有误
          Disconnect From Database
          [Return]          ${status}

查询是否为活动商品
          [Arguments]          ${Id}          ${Id_type}
          [Documentation]          *查询是否为活动商品*
          ...
          ...          *参数：Id: 待查询的ID值*
          ...
          ...          *参数：Id_type: 待查询的ID类型,表示按什么来查询验证商品。可选值：Product 、 SKU*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${Id_type}" == "SKU"          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_skus INNER JOIN azt_shoppromotion_products ON azt_skus.ProductId=azt_shoppromotion_products.ProductId where azt_skus.Id="${Id}" and azt_shoppromotion_products.EndTime>Now() and azt_shoppromotion_products.StartTime<Now()          0
          ...          ELSE IF          "${Id_type}" == "Product"          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_shoppromotion_products where ProductId="${Id}" and azt_shoppromotion_products.EndTime>Now() and azt_shoppromotion_products.StartTime<Now()          0
          ...          ELSE          Fail          查询活动商品出错！！可能是参数有误
          ${status}          Evaluate          not ${status}
          Disconnect From Database
          [Return]          ${status}

查询商品库存
          [Arguments]          ${select}
          [Documentation]          *查询商品库存*
          ...
          ...          *参数：SkuItemId*
          ...
          ...          *返回： 库存*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Stock}          Query          select Stock from azt_skus where id="${select}"
          ${Stock_len}          Get Length          ${Stock}
          ${Stock}          Set Variable If          ${Stock_len} == 0          0          ${Stock[0][0]}
          ${Stock}          Convert To String          ${Stock}
          Disconnect From Database
          [Return]          ${Stock}

查询商品名称
          [Arguments]          ${select}
          [Documentation]          *查询商品名称*
          ...
          ...          *参数：SkuItemId*
          ...
          ...          *返回： 商品名称*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${ProductName}          Query          select ProductName from azt_products INNER JOIN azt_skus ON azt_products.id=azt_skus.ProductId where azt_skus.id="${select}"
          ${ProductName_len}          Get Length          ${ProductName}
          ${ProductName}          Set Variable If          ${ProductName_len} == 0          ${EMPTY}          ${ProductName[0][0]}
          Disconnect From Database
          [Return]          ${ProductName}

查询订单的购买数量
          [Arguments]          ${OrderId}
          [Documentation]          *查询订单的购买数量*
          ...
          ...          *参数：OrderId*
          ...
          ...          *返回： 订单金额*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Quantity}          Query          select Quantity from azt_orderitems where orderid="${OrderId}"
          ${ReturnQuantity_len}          Get Length          ${Quantity}
          ${Quantity}          Set Variable If          ${ReturnQuantity_len} == 0          ${EMPTY}          ${Quantity[0][0]}
          Disconnect From Database
          [Return]          ${Quantity}

查询订单的实付金额
          [Arguments]          ${OrderId}
          [Documentation]          *查询订单的实付金额*
          ...
          ...          *参数：OrderId*
          ...
          ...          *返回： 订单金额*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${RealTotalPrice}          Query          select RealTotalPrice from azt_orderitems where orderid="${OrderId}"
          ${Amount_len}          Get Length          ${RealTotalPrice}
          ${RealTotalPrice}          Set Variable If          ${Amount_len} == 0          ${EMPTY}          ${RealTotalPrice[0][0]}
          Disconnect From Database
          [Return]          ${RealTotalPrice}

查询订单是否有效
          [Arguments]          ${OrderId}
          [Documentation]          *查询订单是否有效*
          ...
          ...          *参数：OrderId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_orders where id="${OrderId}"          1
          Disconnect From Database
          [Return]          ${status}

查询订单状态是否正确
          [Arguments]          ${OrderId}          ${order_status}
          [Documentation]          *查询订单状态是否正确*
          ...
          ...          *参数：OrderId、order_status*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_orders where id="${OrderId}" and OrderStatus="${order_status}"          1
          Disconnect From Database
          [Return]          ${Status}

查询用户店铺订单是否有效
          [Arguments]          ${OrderId}          ${ShopId}          ${UserId}
          [Documentation]          *查询用户店铺订单是否有效*
          ...
          ...          *参数：OrderId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_orders where id="${OrderId}" and ShopId="${ShopId}" and UserId="${UserId}"          1
          Disconnect From Database
          [Return]          ${status}

查询店铺下是否存在视频
          [Arguments]          ${select}
          [Documentation]          *查询参数：shop ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from t_sysmgr_store_video where shop_id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

读取卖家通用数据
          ${json_manager_content}          Read Joson Content          Common_Arg(Manager).json
          ${json_manager_content}          To Json          ${json_manager_content}          #先将读取出来的字符串转成字典
          [Return]          ${json_manager_content}

读取买家通用数据
          ${json_user_content}          Read Joson Content          Common_Arg(User).json
          ${json_user_content}          To Json          ${json_user_content}          #先将读取出来的字符串转成字典
          [Return]          ${json_user_content}

上传图片(话题接口)
          [Arguments]          ${API_URL}          ${ImageStreamString}
          [Documentation]          *上传图片*
          ...
          ...          *参数：1、API地址 \ \ 2、待上传的图片流*
          ...
          ...          *返回：服务端响应内容*
          ${data}          Create Dictionary          ImageStreamString=${ImageStreamString}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          saveimage          ${API_URL}          ${header}
          ${response}          Post Request          saveimage          api/talk/saveimage          data=${data}
          ${responsedata}          To Json          ${response.content}
          Log          ${responsedata}
          [Return]          ${responsedata}

获取移动端首页配置信息
          [Arguments]          ${API_URL}          ${shopID}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          mobilesetttings_home          ${API_URL}          ${header}
          ${response}          Get Request          mobilesetttings_home          api/mobilesetttings/home/${shopID}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取APP版本信息
          [Arguments]          ${API_URL}          ${app_type}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          get_appversion          ${API_URL}          ${header}
          ${response}          Get Request          get_appversion          api/appversion/${app_type}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取专题列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          special_list          ${API_URL}          ${header}
          ${response}          Post Request          special_list          api/special/list          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取专题详情
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          special_detail          ${API_URL}          ${header}
          ${response}          Post Request          special_detail          api/special/detail          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取开卖吧Logo(GET)
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          get_sitesetting_logo          ${API_URL}          ${header}
          ${response}          Get Request          get_sitesetting_logo          api/sitesetting/logo/get
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取开卖吧Logo(POST)
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          post_sitesetting_logo          ${API_URL}          ${header}
          ${response}          Post Request          post_sitesetting_logo          api/sitesetting/logo/get
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
