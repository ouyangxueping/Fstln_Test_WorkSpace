*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
判断达人推荐是否正常
          [Arguments]          ${id}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_talent_show where AdminStatus="2" and id="${id}"          1
          Disconnect From Database
          [Return]          ${status}

获取达人推荐列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          TalentShow_list          ${API_URL}          ${header}
          ${response}          Post Request          TalentShow_list          api/TalentShow/List          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取达人推荐详情评论列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          TalentShow_DetailReview          ${API_URL}          ${header}
          ${response}          Post Request          TalentShow_DetailReview          api/TalentShow/DetailReview          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取达人推荐详情
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          TalentShow_Detail          ${API_URL}          ${header}
          ${response}          Post Request          TalentShow_Detail          api/TalentShow/Detail          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

发布达人推荐
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          TalentShow_AddShow          ${API_URL}          ${header}
          ${response}          Post Request          TalentShow_AddShow          api/TalentShow/AddShow          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户的达人推荐列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          TalentShow_GetShowListUser          ${API_URL}          ${header}
          ${response}          Post Request          TalentShow_GetShowListUser          api/TalentShow/GetShowListUser          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

删除用户的达人推荐
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          TalentShow_Delete          ${API_URL}          ${header}
          ${response}          Post Request          TalentShow_Delete          api/TalentShow/Delete          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
