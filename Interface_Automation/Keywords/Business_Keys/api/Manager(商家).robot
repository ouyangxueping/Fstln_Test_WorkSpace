*** Settings ***
Documentation           *XXXXXXXXX*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ReadAndWriteExcel
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Test Cases ***
POST_api_seller_FindPassWord_SendCode
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
          \          ${businessCode}          Set Variable          ${In_Parame[0]}
          \          ${destination}          Set Variable          ${In_Parame[1]}
          \          ${pluginId}          Set Variable          ${In_Parame[2]}
          \          ${data}          Create Dictionary          businessCode=${businessCode}          destination=${destination}          pluginId=${pluginId}          sign=${sign}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_FindPassWord_SendCode          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_FindPassWord_SendCode          api/seller/FindPassWord/SendCode          data=${data}
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

POST_api_seller_login
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
          \          ${password}          Set Variable          ${In_Parame[0]}
          \          ${userName}          Set Variable          ${In_Parame[1]}
          \          ${data}          Create Dictionary          password=${password}          sign=${sign}          userName=${userName}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_login          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_login          api/seller/login          data=${data}
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

POST_api_seller_FindPassWord_CheckCode
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
          \          ${businessCode}          Set Variable          ${In_Parame[0]}
          \          ${code}          获取手机验证码(商家)
          \          ${destination}          Set Variable          ${In_Parame[1]}
          \          ${pluginId}          Set Variable          ${In_Parame[2]}
          \          ${data}          Create Dictionary          businessCode=${businessCode}          code=${code}          destination=${destination}          pluginId=${pluginId}
          \          ...          sign=${sign}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_FindPassWord_CheckCode          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_FindPassWord_CheckCode          api/seller/FindPassWord/CheckCode          data=${data}
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

POST_api_Seller_ChangePassWord
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
          \          ${memberId}          Set Variable          ${In_Parame[0]}
          \          ${oldPassword}          Set Variable          ${In_Parame[1]}
          \          ${password}          Set Variable          ${In_Parame[2]}
          \          ${data}          Create Dictionary          memberId=${memberId}          oldPassword=${oldPassword}          password=${password}          sign=${sign}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_Seller_ChangePassWord          ${API_URL}          ${header}
          \          ${response}          Post Request          api_Seller_ChangePassWord          api/Seller/ChangePassWord          data=${data}
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

POST_api_Seller_FindPassword_ChangeNewPassword
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
          \          ${destination}          Set Variable          ${In_Parame[0]}
          \          ${password}          Set Variable          ${In_Parame[1]}
          \          ${pluginId}          Set Variable          ${In_Parame[2]}
          \          ${data}          Create Dictionary          destination=${destination}          password=${password}          pluginId=${pluginId}          sign=${sign}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_Seller_FindPassword_ChangeNewPassword          ${API_URL}          ${header}
          \          ${response}          Post Request          api_Seller_FindPassword_ChangeNewPassword          api/Seller/FindPassword/ChangeNewPassword          data=${data}
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
