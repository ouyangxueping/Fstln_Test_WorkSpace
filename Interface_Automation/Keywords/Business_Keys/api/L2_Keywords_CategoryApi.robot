*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询商品分类是否存在
          [Arguments]          ${categoryId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_categories where id="${categoryId}"          1
          Disconnect From Database
          [Return]          ${status}

获得商品一级分类
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Category_list          ${API_URL}          ${header}
          ${response}          Get Request          Category_list          api/Category/list
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获得商品分类详情
          [Arguments]          ${API_URL}          ${categoryId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Category_detail          ${API_URL}          ${header}
          ${response}          Get Request          Category_detail          api/Category/detail/${categoryId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获得视频一级分类
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          category_all          ${API_URL}          ${header}
          ${response}          Post Request          category_all          api/category/all          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获得视频分类详情
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          category_detailinfo          ${API_URL}          ${header}
          ${response}          Post Request          category_detailinfo          api/category/detailinfo          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
