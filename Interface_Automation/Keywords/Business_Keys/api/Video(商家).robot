*** Settings ***
Documentation           *XXXXXXXXX*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ReadAndWriteExcel
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Variables ***
${ImageSrc}             ${EMPTY}          # 服务器返回的上传图片地址，保存视频时用

*** Test Cases ***
POST_api_seller_Video_GetShopVideo
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
          \          ${money}          Set Variable          ${In_Parame[1]}
          \          ${status}          Set Variable          ${In_Parame[2]}
          \          ${type}          Set Variable          ${In_Parame[3]}
          \          ${data}          Create Dictionary          id=${id}          money=${money}          sign=${sign}          status=${status}
          \          ...          type=${type}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_Video_GetShopVideo          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_Video_GetShopVideo          api/seller/Video/GetShopVideo          data=${data}
          \          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          \          Log          ${responsedata}
          \          ${Success}          Get From Dictionary          ${responsedata}          Success
          \          ${Message}          Get From Dictionary          ${responsedata}          Message
          \          ${Success}          Convert To String          ${Success}
          \          ${Message}          Convert To String          ${Message}
          \          #校验预期结果和实际结果
          \          Should Be Equal          ${Out_Parame[1]}          ${Success}
          \          Diff Verify Json          ${TEST_NAME}          ${response.content}
          \          Delete All Sessions

POST_api_seller_saveimage
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
          \          ${imageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\uploads.jpg
          \          ${shopId}          Set Variable          ${In_Parame[0]}
          \          ${response}          上传图片(保存视频)          ${imageStreamString}          ${shopId}
          \          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          \          Log          ${responsedata}
          \          ${Success}          Get From Dictionary          ${responsedata}          Success
          \          ${Message}          Get From Dictionary          ${responsedata}          Message
          \          ${Value}          Get From Dictionary          ${responsedata}          Value
          \          ${Success}          Convert To String          ${Success}
          \          ${Message}          Convert To String          ${Message}
          \          #校验预期结果和实际结果
          \          ${ImageSrc}          Set Variable          ${Value}
          \          Set Global Variable          ${ImageSrc}
          \          Should Be Equal          ${Out_Parame[0]}          ${Message}
          \          Should Be Equal          ${Out_Parame[1]}          ${Success}
          \          Diff Verify Json          ${TEST_NAME}          ${response.content}
          \          Delete All Sessions

POST_api_seller_savevideo
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
          \          ${category}          Set Variable          ${In_Parame[0]}
          \          ${descript}          Set Variable          ${In_Parame[1]}
          \          ${guid}          Set Variable          ${In_Parame[2]}
          \          ${shop_id}          Set Variable          ${In_Parame[3]}
          \          ${originImageSrc}          Set Variable          ${ImageSrc}          #全局变量
          \          ${tagsIds}          Set Variable          ${In_Parame[4]}
          \          ${title}          Set Variable          ${In_Parame[5]}
          \          ${user_id}          Set Variable          ${In_Parame[6]}
          \          ${vid}          Set Variable          ${In_Parame[7]}
          \          ${videoAccessUrl_Original}          Set Variable          ${In_Parame[8]}
          \          ${data}          Create Dictionary          category=${category}          descript=${descript}          guid=${guid}          originImageSrc=${originImageSrc}
          \          ...          shop_id=${shop_id}          sign=${sign}          tagsIds=${tagsIds}          title=${title}          user_id=${user_id}
          \          ...          vid=${vid}          videoAccessUrl_Original=${videoAccessUrl_Original}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_savevideo          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_savevideo          api/seller/savevideo          data=${data}
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

POST_api_seller_video_category_all
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
          \          Create Session          api_seller_video_category_all          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_video_category_all          api/seller/video/category/all          data=${data}
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

POST_api_seller_video_tags_list
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
          \          Create Session          api_seller_video_tags_list          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_video_tags_list          api/seller/video/tags/list          data=${data}
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

POST_api_seller_getvideosign
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
          \          Create Session          api_seller_getvideosign          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_getvideosign          api/seller/getvideosign          data=${data}
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

POST_api_seller_DeleteVideo
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
          \          ${money}          Set Variable          ${In_Parame[1]}
          \          ${status}          Set Variable          ${In_Parame[2]}
          \          ${type}          Set Variable          ${In_Parame[3]}
          \          ${data}          Create Dictionary          id=${id}          money=${money}          sign=${sign}          status=${status}
          \          ...          type=${type}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_DeleteVideo          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_DeleteVideo          api/seller/DeleteVideo          data=${data}
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
