*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
获取店铺的活动列表
          [Arguments]          ${API_URL}          ${shopId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shoppromotion_list          ${API_URL}          ${header}
          ${response}          Get Request          shoppromotion_list          api/shoppromotion/list/${shopId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取活动详细信息
          [Arguments]          ${API_URL}          ${promotionId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shoppromotion_detail          ${API_URL}          ${header}
          ${response}          Get Request          shoppromotion_detail          api/shoppromotion/detail/${promotionId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

批量删除活动
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shoppromotion_delete          ${API_URL}          ${header}
          ${response}          Post Request          shoppromotion_delete          api/shoppromotion/delete          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
