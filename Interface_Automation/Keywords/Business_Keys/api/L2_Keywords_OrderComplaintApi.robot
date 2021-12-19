*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户是否存在投诉维权记录
          [Arguments]          ${userId}          ${Id}=          ${OrderId}=
          [Documentation]          *验证用户是否存在投诉维权记录(如果给定 OrderId和Id参数则进一步过滤订单，否则不过滤（默认只过滤 userID）)*
          ...
          ...          *参数：userID、Id、OrderId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${OrderId}" != "${EMPTY}" and "${Id}" == "${EMPTY}"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_ordercomplaints where UserId="${userId}" and OrderId="${OrderId}"          0
          ...          ELSE IF          "${Id}" != "${EMPTY}" and "${OrderId}" == "${EMPTY}"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_ordercomplaints where UserId="${userId}" and id="${Id}"          0
          ...          ELSE IF          "${Id}" != "${EMPTY}" and "${OrderId}" != "${EMPTY}"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_ordercomplaints where UserId="${userId}" and OrderId="${OrderId}" and id="${Id}"          0
          ...          ELSE IF          "${Id}" == "${EMPTY}" and "${OrderId}" == "${EMPTY}"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_ordercomplaints where UserId="${userId}"          0
          Disconnect From Database
          Comment          \          select * from azt_ordercomplaints where UserId="${userId}" and id="${Id}"          select * from azt_ordercomplaints where UserId="${userId}" and OrderId="${OrderId}" and id="${Id}"          select * from azt_ordercomplaints where UserId="${userId}" and OrderId="${OrderId}"          select * from azt_ordercomplaints where UserId="${userId}"
          [Return]          ${status}

查询用户是否符合投诉维权条件
          [Arguments]          ${userId}
          [Documentation]          *查询用户是否符合投诉维权条件（规则为订单表状态为 5，且不存在与投诉表中的记录）*
          ...
          ...          *参数：userID*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_orders LEFT JOIN azt_ordercomplaints ON azt_orders.id=azt_ordercomplaints.OrderId where azt_orders.OrderStatus="5" and azt_orders.UserId="${userId}" and azt_ordercomplaints.id is NULL          0
          Disconnect From Database
          [Return]          ${status}

获取投诉维权列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordercomplaint_list          ${API_URL}          ${header}
          ${response}          Post Request          ordercomplaint_list          api/ordercomplaint/list          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取投诉维权记录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordercomplaint_record          ${API_URL}          ${header}
          ${response}          Post Request          ordercomplaint_record          api/ordercomplaint/record          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

退货仲裁
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordercomplaint_addarbitration          ${API_URL}          ${header}
          ${response}          Post Request          ordercomplaint_addarbitration          api/ordercomplaint/addarbitration          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

投诉仲裁
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordercomplaint_applyarbitration          ${API_URL}          ${header}
          ${response}          Post Request          ordercomplaint_applyarbitration          api/ordercomplaint/applyarbitration          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
