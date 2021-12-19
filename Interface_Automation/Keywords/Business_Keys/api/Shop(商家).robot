*** Settings ***
Documentation           *POST api/seller/ConfirmWithdrawShop \ \ 提现完成 确定按键*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ReadAndWriteExcel
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt

*** Test Cases ***
POST_api_seller_shopmember
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
          \          Create Session          api_seller_shopmember          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopmember          api/seller/shopmember          data=${data}
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

POST_api_seller_saveshop
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
          \          ${account}          Set Variable          ${In_Parame[0]}
          \          ${bankAccountName}          Set Variable          ${In_Parame[1]}
          \          ${bankAccountNumber}          Set Variable          ${In_Parame[2]}
          \          ${bankName}          Set Variable          ${In_Parame[3]}
          \          ${bankRegionId}          Set Variable          ${In_Parame[4]}
          \          ${businessCategory}          Set Variable          ${In_Parame[5]}
          \          ${businessCategory}          Parse Cell Content          ${businessCategory}          ，          #解析后得到列表
          \          ${businessCategory[0]}          To Json          ${businessCategory[0]}          \          #解析后得到字典
          \          ${businessCategory[1]}          To Json          ${businessCategory[1]}
          \          ${businessCategory[2]}          To Json          ${businessCategory[2]}
          \          ${businessCategory}          Create List          ${businessCategory[0]}          ${businessCategory[1]}          ${businessCategory[2]}          #重新装填进列表
          \          ${businessLicenceEnd}          Set Variable          ${In_Parame[6]}
          \          ${businessLicenceNumber}          Set Variable          ${In_Parame[7]}
          \          ${businessLicenceNumberPhoto}          Set Variable          ${In_Parame[8]}
          \          ${businessLicenceRegionId}          Set Variable          ${In_Parame[9]}
          \          ${businessLicenceStart}          Set Variable          ${In_Parame[10]}
          \          ${companyAddress}          Set Variable          ${In_Parame[11]}
          \          ${companyEmployeeCount}          Set Variable          ${In_Parame[12]}
          \          ${companyFoundingDate}          Set Variable          ${In_Parame[13]}
          \          ${companyName}          Set Variable          ${In_Parame[14]}
          \          ${companyPhone}          Set Variable          ${In_Parame[15]}
          \          ${companyRegion}          Set Variable          ${In_Parame[16]}
          \          ${companyRegisteredCapital}          Set Variable          ${In_Parame[17]}
          \          ${concertedTotal}          Set Variable          ${In_Parame[18]}
          \          ${contactsEmail}          Set Variable          ${In_Parame[19]}
          \          ${contactsName}          Set Variable          ${In_Parame[20]}
          \          ${contactsPhone}          Set Variable          ${In_Parame[21]}
          \          ${endDate}          Set Variable          ${In_Parame[22]}
          \          ${generalTaxpayerPhot}          Set Variable          ${In_Parame[23]}
          \          ${id}          Set Variable          ${In_Parame[24]}
          \          ${isSelf}          Set Variable          ${In_Parame[25]}
          \          ${legalPerson}          Set Variable          ${In_Parame[26]}
          \          ${logo}          Set Variable          ${In_Parame[27]}
          \          ${name}          Set Variable          ${In_Parame[28]}
          \          ${newBankRegionId}          Set Variable          ${In_Parame[29]}
          \          ${newCompanyRegionId}          Set Variable          ${In_Parame[30]}
          \          ${organizationCodePhoto}          Set Variable          ${In_Parame[31]}
          \          ${qQIDKey}          Set Variable          ${In_Parame[32]}
          \          ${shopGrade}          Set Variable          ${In_Parame[33]}
          \          ${status}          Set Variable          ${In_Parame[34]}
          \          ${taxRegistrationCertificate}          Set Variable          ${In_Parame[35]}
          \          ${taxRegistrationCertificatePhoto}          Set Variable          ${In_Parame[36]}
          \          ${taxpayerId}          Set Variable          ${In_Parame[37]}
          \          ${data}          Create Dictionary          account=${account}          bankAccountName=${bankAccountName}          bankAccountNumber=${bankAccountNumber}          bankName=${bankName}
          \          ...          bankRegionId=${bankRegionId}          businessCategory=${businessCategory}          businessLicenceEnd=${businessLicenceEnd}          businessLicenceNumber=${businessLicenceNumber}          businessLicenceNumberPhoto=${businessLicenceNumberPhoto}
          \          ...          businessLicenceRegionId=${businessLicenceRegionId}          businessLicenceStart=${businessLicenceStart}          companyAddress=${companyAddress}          companyEmployeeCount=${companyEmployeeCount}          companyFoundingDate=${companyFoundingDate}
          \          ...          companyName=${companyName}          companyPhone=${companyPhone}          companyRegion=${companyRegion}          companyRegisteredCapital=${companyRegisteredCapital}          concertedTotal=${concertedTotal}
          \          ...          contactsEmail=${contactsEmail}          contactsName=${contactsName}          contactsPhone=${contactsPhone}          endDate=${endDate}          generalTaxpayerPhot=${generalTaxpayerPhot}
          \          ...          id=${id}          isSelf=${isSelf}          legalPerson=${legalPerson}          logo=${logo}          name=${name}
          \          ...          newBankRegionId=${newBankRegionId}          newCompanyRegionId=${newCompanyRegionId}          organizationCodePhoto=${organizationCodePhoto}          qQIDKey=${qQIDKey}          shopGrade=${shopGrade}
          \          ...          sign=${sign}          status=${status}          taxRegistrationCertificate=${taxRegistrationCertificate}          taxRegistrationCertificatePhoto=${taxRegistrationCertificatePhoto}          taxpayerId=${taxpayerId}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_saveshop          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_saveshop          api/seller/saveshop          data=${data}
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

POST_api_seller_shopaccount
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
          \          Create Session          api_seller_shopaccount          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopaccount          api/seller/shopaccount          data=${data}
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

POST_api_seller_shopaccountdetail
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
          \          ${endDate}          Set Variable          ${In_Parame[0]}
          \          ${pageNo}          Set Variable          ${In_Parame[1]}
          \          ${pageSize}          Set Variable          ${In_Parame[2]}
          \          ${shopId}          Set Variable          ${In_Parame[3]}
          \          ${startDate}          Set Variable          ${In_Parame[4]}
          \          ${status}          Set Variable          ${In_Parame[5]}
          \          ${website}          Set Variable          ${In_Parame[6]}
          \          ${data}          Create Dictionary          endDate=${endDate}          pageNo=${pageNo}          pageSize=${pageSize}          shopId=${shopId}
          \          ...          sign=${sign}          startDate=${startDate}          status=${status}          website=${website}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_shopaccountdetail          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopaccountdetail          api/seller/shopaccountdetail          data=${data}
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

POST_api_seller_shopsubmitwithdraw
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
          \          ${data}          Create Dictionary          id=${id}          money=${money}          sign=${sign}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_shopsubmitwithdraw          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopsubmitwithdraw          api/seller/shopsubmitwithdraw          data=${data}
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

POST_api_seller_shopfreight
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
          \          Create Session          api_seller_shopfreight          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopfreight          api/seller/shopfreight          data=${data}
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

POST_api_seller_shopwithdraw
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
          \          Create Session          api_seller_shopwithdraw          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopwithdraw          api/seller/shopwithdraw          data=${data}
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

POST_api_seller_saveshopmember
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
          \          ${createTime}          Set Variable          ${In_Parame[0]}
          \          ${description}          Set Variable          ${In_Parame[1]}
          \          ${id}          Set Variable          ${In_Parame[2]}
          \          ${lastUpdateTime}          Set Variable          ${In_Parame[3]}
          \          ${normalCredit}          Set Variable          ${In_Parame[4]}
          \          ${normalDiscount}          Set Variable          ${In_Parame[5]}
          \          ${mediumCredit}          Set Variable          ${In_Parame[6]}
          \          ${mediumDiscount}          Set Variable          ${In_Parame[7]}
          \          ${premiumCredit}          Set Variable          ${In_Parame[8]}
          \          ${premiumDiscount}          Set Variable          ${In_Parame[9]}
          \          ${shopId}          Set Variable          ${In_Parame[10]}
          \          ${shopName}          Set Variable          ${In_Parame[11]}
          \          ${userId}          Set Variable          ${In_Parame[12]}
          \          ${userName}          Set Variable          ${In_Parame[13]}
          \          ${data}          Create Dictionary          createTime=${createTime}          description=${description}          id=${id}          lastUpdateTime=${lastUpdateTime}
          \          ...          mediumCredit=${mediumCredit}          mediumDiscount=${mediumDiscount}          normalCredit=${normalCredit}          normalDiscount=${normalDiscount}          premiumCredit=${premiumCredit}
          \          ...          premiumDiscount=${premiumDiscount}          shopId=${shopId}          shopName=${shopName}          sign=${sign}          userId=${userId}
          \          ...          userName=${userName}
          \          #数据库
          \          #请求
          \          ${data}          Convert To Json          ${data}
          \          ${header}          Create Dictionary          Content-Type=application/json
          \          Create Session          api_seller_saveshopmember          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_saveshopmember          api/seller/saveshopmember          data=${data}
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

POST_api_seller_shopcard
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
          \          Create Session          api_seller_shopcard          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopcard          api/seller/shopcard          data=${data}
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

POST_api_seller_shopinfo
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
          \          Create Session          api_seller_shopinfo          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_shopinfo          api/seller/shopinfo          data=${data}
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

POST_api_seller_getshopreporthome
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
          \          Create Session          api_seller_getshopreporthome          ${API_URL}          ${header}
          \          ${response}          Post Request          api_seller_getshopreporthome          api/seller/getshopreporthome          data=${data}
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
