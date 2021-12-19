*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户平台公告是否已读
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query}          Query          select status from azt_platformnotice_user where MemberId="${userId}"
          Comment          ${Query[0][0]}          Evaluate          str(${Query[0][0]})
          ${status}          Run Keyword And Return Status          Should Be Equal          ${Query[0][0]}          1
          Disconnect From Database
          [Return]          ${status}

获取买家收到的平台公告列表
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          platformnotice_list          ${API_URL}          ${header}
          ${response}          Get Request          platformnotice_list          api/platformnotice/list/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取公告详细信息
          [Arguments]          ${API_URL}          ${user_platformnotice_id}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          platformnotice_detail          ${API_URL}          ${header}
          ${response}          Get Request          platformnotice_detail          api/platformnotice/detail/${user_platformnotice_id}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

批量设置平台公告为已读
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          platformnotice_read          ${API_URL}          ${header}
          ${response}          Post Request          platformnotice_read          api/platformnotice/read          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

批量删除平台公告
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          platformnotice_delete          ${API_URL}          ${header}
          ${response}          Post Request          platformnotice_delete          api/platformnotice/delete          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
