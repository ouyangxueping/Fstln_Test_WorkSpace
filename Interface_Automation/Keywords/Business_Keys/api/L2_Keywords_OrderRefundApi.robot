*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户是否可以退款申请
          [Arguments]          ${userId}          ${OrderId}=
          [Documentation]          *验证用户是否可以退款申请(如果给定 OrderId参数则进一步过滤订单，否则不过滤（默认不过滤）)*
          ...
          ...          *参数：userID、OrderId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${OrderId}" == "${EMPTY}"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_orderrefunds where UserId="${userId}" and SellerAuditStatus !="5"          0
          ...          ELSE          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_orderrefunds where UserId="${userId}" and OrderId="${OrderId}" and SellerAuditStatus !="5"          0
          Disconnect From Database
          [Return]          ${status}

查询用户是否存在退款记录
          [Arguments]          ${userId}          ${OrderId}=
          [Documentation]          *验证用户是否存在退款记录(如果给定 OrderId参数则进一步过滤订单，否则不过滤（默认不过滤）)*
          ...
          ...          *参数：userID、OrderId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword If          "${OrderId}" == "${EMPTY}"          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_orderrefunds where UserId="${userId}"          0
          ...          ELSE          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_orderrefunds where UserId="${userId}" and OrderId="${OrderId}"          0
          Disconnect From Database
          [Return]          ${status}

查询用户的退款记录是否存在
          [Arguments]          ${userId}          ${OrderRetundId}
          [Documentation]          *验证用户的退款记录是否存在*
          ...
          ...          *参数：userID、OrderRetundId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_orderrefunds where id="${OrderRetundId}" and UserId="${userId}"          1
          Disconnect From Database
          [Return]          ${status}

查询退款订单是否为待发货状态
          [Arguments]          ${OrderRetundId}
          [Documentation]          *验证用户是否存在退款记录*
          ...
          ...          *参数：OrderRetundId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_orderrefunds where id="${OrderRetundId}" and SellerAuditStatus="2"          1
          Disconnect From Database
          [Return]          ${status}

获取退款列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordertefund_list          ${API_URL}          ${header}
          ${response}          Post Request          ordertefund_list          api/ordertefund/list          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取退款详情
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordertefund_detail          ${API_URL}          ${header}
          ${response}          Post Request          ordertefund_detail          api/ordertefund/detail          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

提交退款申请
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordertefund_refundapply          ${API_URL}          ${header}
          ${response}          Post Request          ordertefund_refundapply          api/ordertefund/refundapply          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

提交退款信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordertefund_add          ${API_URL}          ${header}
          ${response}          Post Request          ordertefund_add          api/ordertefund/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

确认寄货
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          ordertefund_confirmrefundgood          ${API_URL}          ${header}
          ${response}          Post Request          ordertefund_confirmrefundgood          api/ordertefund/confirmrefundgood          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
