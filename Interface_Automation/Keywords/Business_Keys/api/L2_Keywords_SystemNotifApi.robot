*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询系统通知是否存在
          [Arguments]          ${id}
          [Documentation]          *查询系统通知是否存在*
          ...
          ...          *参数：ID*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_system_notice where id="${id}"          1
          Disconnect From Database
          [Return]          ${status}

获取系统通知列表
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          systemnotice_list          ${API_URL}          ${header}
          ${response}          Get Request          systemnotice_list          api/systemnotice/list/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

系统消息批量更新已读
          [Arguments]          ${API_URL}          ${ids}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          systemnotice_updatestatus          ${API_URL}          ${header}
          ${response}          Get Request          systemnotice_updatestatus          api/systemnotice/updatestatus/${ids}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

删除系统消息
          [Arguments]          ${API_URL}          ${ids}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          systemnotice_delete          ${API_URL}          ${header}
          ${response}          Get Request          systemnotice_delete          api/systemnotice/delete/${ids}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取系统通知详情
          [Arguments]          ${API_URL}          ${id}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          systemnotice_details          ${API_URL}          ${header}
          ${response}          Get Request          systemnotice_details          api/systemnotice/details/${id}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
