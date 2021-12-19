*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
领取店铺会员卡
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shopvipcard_activate          ${API_URL}          ${header}
          ${response}          Post Request          shopvipcard_activate          api/shopvipcard/activate          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户店铺会员卡列表(GET)
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shopvipcard_list          ${API_URL}          ${header}
          ${response}          Get Request          shopvipcard_list          api/shopvipcard/list/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户店铺会员卡列表(POST)
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shopvipcard_list          ${API_URL}          ${header}
          ${response}          Post Request          shopvipcard_list          api/shopvipcard/list/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
