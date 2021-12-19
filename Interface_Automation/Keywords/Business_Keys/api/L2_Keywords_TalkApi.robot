*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
判断话题是否在线
          [Arguments]          ${id}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Equal To X          select * from azt_talk where OfflineTime>Now() and id="${id}"          1
          Disconnect From Database
          [Return]          ${status}

获取话题列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          talk_list          ${API_URL}          ${header}
          ${response}          Post Request          talk_list          api/talk/list          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取话题的评论回复列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          talk_reviewlist          ${API_URL}          ${header}
          ${response}          Post Request          talk_reviewlist          api/talk/reviewlist          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取话题详情评论列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          talk_detaillist          ${API_URL}          ${header}
          ${response}          Post Request          talk_detaillist          api/talk/detaillist          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取话题详情
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          talk_detail          ${API_URL}          ${header}
          ${response}          Post Request          talk_detail          api/talk/detail          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

添加话题点赞
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          talk_addpraised          ${API_URL}          ${header}
          ${response}          Post Request          talk_addpraised          api/talk/addpraised          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

添加话题评论
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          talk_addreview          ${API_URL}          ${header}
          ${response}          Post Request          talk_addreview          api/talk/addreview          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

验证接口返回的图片地址是否为金山云地址
          [Arguments]          ${Data[0]}          ${ImageServerUrl}
          [Documentation]          *${Data}表示接口返回的列表 \ \ \ \ \ \ ${name}表示取列表中的某一个字段*
          ${ImagePath}          Get From Dictionary          ${Data[0]}          ImagePath
          ${ImagePath}          Split String          ${ImagePath}          /Storage          0
          Run Keyword If          '${ImagePath}'=='${ImageServerUrl}'          log          图片地址为金山云地址
          ...          ELSE          fail          接口返回地址不是金山云地址！！

验证接口返回total是否与数据库相同
          [Arguments]          ${Count}          ${Total}
          Run Keyword If          ${Count}==${Total}          log          查询结果一致
          ...          ELSE          fail          数据库中查询和接口返回的话题评论总数不一致！！
