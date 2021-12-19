*** Settings ***
Documentation           *POST api/Seller/Order/OrderRefund \ 退款、退货处理*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ReadAndWriteExcel
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Test Cases ***
POST_api_Seller_Order_OrderManagement
          [Documentation]          *XXXXXX*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${count}          ${result}          Get Number Of Match Cells          Sheet1          1          ${TEST_NAME}
          : FOR          ${row_num}          IN RANGE          ${count}
          \          #创建参数字典
          \          ${In_Parame}          Parse Cell Content          ${result[${row_num}]["In_Parame"]}          &
          \          ${Out_Parame}          Parse Cell Content          ${result[${row_num}]["Out_Parame"]}          &
          \          ${id}          Set Variable          ${In_Parame[0]}
          \          ${pageNo}          Set Variable          ${In_Parame[1]}
          \          ${pageSize}          Set Variable          ${In_Parame[2]}
          \          ${status}          Set Variable          ${In_Parame[3]}
          \          ${data}          Create Dictionary          id=${id}          pageNo=${pageNo}          pageSize=${pageSize}          sign=${sign}
          \          ...          status=${status}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_Seller_Order_OrderManagement          ${API_URL}          ${header}
          \          ${response}          Post Request          api_Seller_Order_OrderManagement          api/Seller/Order/OrderManagement          data=${data}
          \          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          \          Log          ${responsedata}
          \          ${Success}          Get From Dictionary          ${responsedata}          Success
          \          ${Message}          Get From Dictionary          ${responsedata}          Message
          \          ${Success}          Convert To String          ${Success}
          \          ${Message}          Convert To String          ${Message}
          \          #校验预期结果和实际结果
          \          Should Be Equal          ${Out_Parame[0]}          ${Message}
          \          Should Be Equal          ${Out_Parame[1]}          ${Success}
          \          Diff Verify Json          ${TEST_NAME}          ${response.content}
          \          Delete All Sessions

POST_api_Seller_Order_OrderOverView
          [Documentation]          *XXXXXX*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${count}          ${result}          Get Number Of Match Cells          Sheet1          1          ${TEST_NAME}
          : FOR          ${row_num}          IN RANGE          ${count}
          \          #创建参数字典
          \          ${In_Parame}          Parse Cell Content          ${result[${row_num}]["In_Parame"]}          &
          \          ${Out_Parame}          Parse Cell Content          ${result[${row_num}]["Out_Parame"]}          &
          \          ${id}          Set Variable          ${In_Parame[0]}
          \          ${status}          Set Variable          ${In_Parame[1]}
          \          ${type}          Set Variable          ${In_Parame[2]}
          \          ${data}          Create Dictionary          id=${id}          sign=${sign}          status=${status}          type=${type}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_Seller_Order_OrderOverView          ${API_URL}          ${header}
          \          ${response}          Post Request          api_Seller_Order_OrderOverView          api/Seller/Order/OrderOverView          data=${data}
          \          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          \          Log          ${responsedata}
          \          ${Success}          Get From Dictionary          ${responsedata}          Success
          \          ${Message}          Get From Dictionary          ${responsedata}          Message
          \          ${Success}          Convert To String          ${Success}
          \          ${Message}          Convert To String          ${Message}
          \          #校验预期结果和实际结果
          \          Should Be Equal          ${Out_Parame[0]}          ${Message}
          \          Should Be Equal          ${Out_Parame[1]}          ${Success}
          \          Diff Verify Json          ${TEST_NAME}          ${response.content}
          \          Delete All Sessions
