*** Settings ***
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ../../API_Lib/Image_Recognition.py
Library                 ../../API_Lib/Create_Common_Arg.py

*** Test Cases ***
liveroom_danmu
          [Documentation]          *XXXXXX*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          ${data}          Create Dictionary          sign=${Sign}
          #数据库
          #请求
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          api_liveroom_danmu_          ${API_URL}          ${header}
          ${response}          Get Request          api_liveroom_danmu_          api/liveroom/danmu/1044
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Message}          Get From Dictionary          ${responsedata}          Message
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List
          ${Success_list}          Create List          True
          ${Json_list}          Create List
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

liveroom_anchor
          [Documentation]          *XXXXXX*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          ${data}          Create Dictionary          sign=${Sign}
          #数据库
          #请求
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          api_liveroom_anchor_          ${API_URL}          ${header}
          ${response}          Get Request          api_liveroom_anchor_          api/liveroom/anchor/
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Message}          Get From Dictionary          ${responsedata}          Message
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List
          ${Success_list}          Create List
          ${Json_list}          Create List
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions
