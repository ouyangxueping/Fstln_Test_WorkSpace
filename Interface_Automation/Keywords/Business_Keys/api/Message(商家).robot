*** Settings ***
Documentation           *POST api/seller/Message/CommentList \ \ 评论*
...
...                     *POST api/seller/Message/PraisedReviewList \ 点赞*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ReadAndWriteExcel
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Test Cases ***
POST_api_seller_Message_MessageCount
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
          \          Create Session          api_seller_Message_MessageCount          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_MessageCount          api/seller/Message/MessageCount          data=${data}
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

POST_api_seller_Message_SysMessageList
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
          \          ${userName}          Set Variable          ${In_Parame[3]}
          \          ${data}          Create Dictionary          id=${id}          sign=${sign}          status=${status}          type=${type}
          \          ...          userName=${userName}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_Message_SysMessageList          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_SysMessageList          api/seller/Message/SysMessageList          data=${data}
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

POST_api_seller_Message_PlatFormMessageList
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
          \          Create Session          api_seller_Message_PlatFormMessageList          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_PlatFormMessageList          api/seller/Message/PlatFormMessageList          data=${data}
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

POST_api_seller_Message_SetToReadSystemMsg
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
          \          ${ids}          Set Variable          ${In_Parame[0]}
          \          ${ids}          Parse Cell Content          ${ids}          ，
          \          ${status}          Set Variable          ${In_Parame[1]}
          \          ${data}          Create Dictionary          ids=${ids}          sign=${sign}          status=${status}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_Message_SetToReadSystemMsg          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_SetToReadSystemMsg          api/seller/Message/SetToReadSystemMsg          data=${data}
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

POST_api_seller_Message_DeletePlatFormMsg
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
          \          ${ids}          Set Variable          ${In_Parame[0]}
          \          ${ids}          Parse Cell Content          ${ids}          ，
          \          ${status}          Set Variable          ${In_Parame[1]}
          \          ${data}          Create Dictionary          ids=${ids}          sign=${sign}          status=${status}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_Message_DeletePlatFormMsg          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_DeletePlatFormMsg          api/seller/Message/DeletePlatFormMsg          data=${data}
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

POST_api_seller_Message_SetPlatFormMessageToRead
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
          \          ${ids}          Set Variable          ${In_Parame[0]}
          \          ${ids}          Parse Cell Content          ${ids}          ，
          \          ${status}          Set Variable          ${In_Parame[1]}
          \          ${data}          Create Dictionary          ids=${ids}          sign=${sign}          status=${status}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_Message_SetPlatFormMessageToRead          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_SetPlatFormMessageToRead          api/seller/Message/SetPlatFormMessageToRead          data=${data}
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

POST_api_seller_Message_DeleteSystemMsg
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
          \          ${ids}          Set Variable          ${In_Parame[0]}
          \          ${ids}          Parse Cell Content          ${ids}          ，
          \          ${status}          Set Variable          ${In_Parame[1]}
          \          ${data}          Create Dictionary          ids=${ids}          sign=${sign}          status=${status}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_Message_DeleteSystemMsg          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Message_DeleteSystemMsg          api/seller/Message/DeleteSystemMsg          data=${data}
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
