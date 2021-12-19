*** Settings ***
Documentation           *XXXXXXXXX*
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Variables ***
${Var}                  Var          #XXXXXXXXXXX

*** Test Cases ***
POST_report_AddReportOrderCloseReturn
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
          Create Session          api_report_AddReportOrderCloseReturn          ${API_URL}          ${header}
          ${response}          Post Request          api_report_AddReportOrderCloseReturn          api/report/AddReportOrderCloseReturn          data=${data}
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
