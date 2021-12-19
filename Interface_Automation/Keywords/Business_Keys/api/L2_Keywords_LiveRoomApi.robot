*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询直播是否存在
          [Arguments]          ${select}
          [Documentation]          *查询参数：直播ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_liverooms where id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询用户是否已订阅直播
          [Arguments]          ${userId}          ${liveroomId}
          [Documentation]          *查询参数：用户id 、直播id*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_liverooms_subscribe where UserId="${userId}" and LiveRoomId="${liveroomId}"          0
          Disconnect From Database
          [Return]          ${status}

查询订阅直播的价格
          [Arguments]          ${select}
          [Documentation]          *查询参数：订阅id*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${query}          Query          select TicketPrice from azt_liverooms_subscribe where id="${select}"
          Disconnect From Database
          [Return]          ${query}

查询直播订阅ID是否存在
          [Arguments]          ${select}
          [Documentation]          *查询参数：订阅id*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_liverooms_subscribe where id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询直播退票ID是否存在
          [Arguments]          ${select}          ${Id_type}
          [Documentation]          *查询参数：订阅id或者退票id*
          ...
          ...          *参数：Id: 待查询的ID值*
          ...
          ...          *参数：Id_type: 待查询的ID类型,表示按什么来查询。可选值：ID 、 SubscribeId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${Id_type}" == "ID"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_liverooms_subscribe_refund where Id="${select}"          0
          ...          ELSE IF          "${Id_type}" == "SubscribeId"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_liverooms_subscribe_refund where SubscribeId="${select}"          0
          ...          ELSE          Fail          查询直播退票信息出错！！可能是参数有误
          Disconnect From Database
          [Return]          ${status}

查询订阅直播退票的ID
          [Arguments]          ${select}
          [Documentation]          *查询参数：订阅id*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${query}          Query          select id from azt_liverooms_subscribe_refund where SubscribeId="${select}"
          Disconnect From Database
          [Return]          ${query}

获取直播列表
          [Arguments]          ${API_URL}          ${status}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_list          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_list          api/liveroom/list/${status}/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取直播间信息
          [Arguments]          ${API_URL}          ${liveRoomId}          ${batch}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_show          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_show          api/liveroom/show/${liveRoomId}/${batch}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取直播间主播发送的数据列表
          [Arguments]          ${API_URL}          ${liveRoomId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_anchor          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_anchor          api/liveroom/anchor/${liveRoomId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取直播间用户发送的弹幕列表
          [Arguments]          ${API_URL}          ${liveRoomId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_danmu          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_danmu          api/liveroom/danmu/${liveRoomId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

直播投诉
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_addcomplain          ${API_URL}          ${header}
          ${response}          Post Request          liveroom_addcomplain          api/liveroom/addcomplain          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

直播间订阅
          [Arguments]          ${API_URL}          ${liveRoomId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_subscribe          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_subscribe          api/liveroom/subscribe/${liveRoomId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

用户中心-订阅列表
          [Arguments]          ${API_URL}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_subscribelist          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_subscribelist          api/liveroom/subscribelist/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取直播购票的详细信息
          [Arguments]          ${API_URL}          ${subscribeId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_subscribedetail          ${API_URL}          ${header}
          ${response}          Get Request          liveroom_subscribedetail          api/liveroom/subscribedetail/${subscribeId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

直播间订阅付费提交 - 微信支付
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_weixinpay          ${API_URL}          ${header}
          ${response}          Post Request          liveroom_weixinpay          api/liveroom/weixinpay          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

直播间订阅付费提交 - 支付宝支付
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_alipay          ${API_URL}          ${header}
          ${response}          Post Request          liveroom_alipay          api/liveroom/alipay          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

申请直播退票
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_subscriberefund          ${API_URL}          ${header}
          ${response}          Post Request          liveroom_subscriberefund          api/liveroom/subscriberefund/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

重新申请直播退票
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          liveroom_subscriberefund_readd          ${API_URL}          ${header}
          ${response}          Post Request          liveroom_subscriberefund_readd          api/liveroom/subscriberefund/readd          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
