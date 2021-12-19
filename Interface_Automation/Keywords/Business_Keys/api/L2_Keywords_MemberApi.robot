*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询用户是否当天已经签到
          [Arguments]          ${userId}
          [Documentation]          *查询参数：用户ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          SELECT * from azt_member_signin where date(SignInTime)=date(now()) and MemberId="${userId}"          0          #判断用户是不是当天已经签到过
          Disconnect From Database
          [Return]          ${status}

查询用户最近的连续签到天数
          [Arguments]          ${select}
          [Documentation]          *查询参数：用户ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query}          Query          select ContinuousSignInDays from azt_member_signin where date(SignInTime)<=date(now()) and MemberId="${select}" Order by SignInTime DESC LIMIT 1
          Disconnect From Database
          ${Query}=          Set Variable If          ${Query}==[]          0          ${Query[0][0]}
          [Return]          ${Query}

查询用户的等级
          [Arguments]          ${select}
          [Documentation]          *查询参数：用户ID*
          ...
          ...          *返回：用户所拥有的经验对应的【最大等级】和【等级名称】*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Query}          Query          SELECT Grade,GradeName from azt_memberexp INNER JOIN azt_membergrade ON azt_memberexp.Exp<=azt_membergrade.Exp where MemberId="${select}"
          Disconnect From Database
          [Return]          ${Query[0]}

查询手机号是否存在
          [Arguments]          ${select}
          [Documentation]          *参数：手机号码*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_members where CellPhone="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询收货地址是否存在
          [Arguments]          ${select}
          [Documentation]          *参数：收货地址id*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_shippingaddresses where Id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

查询发票抬头信息是否存在
          [Arguments]          ${select}
          [Documentation]          *参数：发票抬头ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_invoicetitle where Id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

用户签到
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          User_Sign          ${API_URL}          ${header}
          ${response}          Post Request          User_Sign          api/member/SignIn          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          log          ${responsedata}
          [Return]          ${responsedata}

获取用户签到信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          GetSignInDetail          ${API_URL}          ${header}
          ${response}          Post Request          GetSignInDetail          api/member/GetSignInDetail          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户的等级信息
          [Arguments]          ${API_URL}          ${memberId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_grade          ${API_URL}          ${header}
          ${response}          Get Request          member_grade          api/member/grade/${memberId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户经验值列表信息
          [Arguments]          ${API_URL}          ${memberId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_exp          ${API_URL}          ${header}
          ${response}          Get Request          member_exp          api/member/exp/${memberId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

Flash用户登录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_login          ${API_URL}          ${header}
          ${response}          Post Request          member_login          api/member/login          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

移动端用户登录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_phonelogin          ${API_URL}          ${header}
          ${response}          Post Request          member_phonelogin          api/member/phonelogin          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

发送手机验证码1
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_sendlogincode          ${API_URL}          ${header}
          ${response}          Post Request          member_sendlogincode          api/member/sendlogincode          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

发送手机验证码2
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_postSendCode          ${API_URL}          ${header}
          ${response}          Post Request          member_postSendCode          api/member/postSendCode          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

发送手机验证码3
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_sendCode          ${API_URL}          ${header}
          ${response}          Post Request          member_sendCode          api/member/sendCode          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

手机短信验证码检查
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_postCheckCode          ${API_URL}          ${header}
          ${response}          Post Request          member_postCheckCode          api/member/postCheckCode          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

验证码检查
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_checkCode          ${API_URL}          ${header}
          ${response}          Post Request          member_checkCode          api/member/checkCode          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

用户注册
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_postRegisterUser          ${API_URL}          ${header}
          ${response}          Post Request          member_postRegisterUser          api/member/postRegisterUser          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

更改密码
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_changepassword          ${API_URL}          ${header}
          ${response}          Post Request          member_changepassword          api/member/changepassword          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

找回密码
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_findpassword          ${API_URL}          ${header}
          ${response}          Post Request          member_findpassword          api/member/findpassword          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

增加收货地址
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          address_add          ${API_URL}          ${header}
          ${response}          Post Request          address_add          api/address/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

修改收货地址
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          address_update          ${API_URL}          ${header}
          ${response}          Post Request          address_update          api/address/update          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

删除收货地址
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          address_delete          ${API_URL}          ${header}
          ${response}          Post Request          address_delete          api/address/delete          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收货地址
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          address_get          ${API_URL}          ${header}
          ${response}          Post Request          address_get          api/address/get          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

设置默认收货地址
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          address_setdefault          ${API_URL}          ${header}
          ${response}          Post Request          address_setdefault          api/address/setdefault          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

上传用户头像
          [Arguments]          ${API_URL}          ${UserId}          ${ImageStreamString}
          [Documentation]          *上传用户头像*
          ...
          ...          *参数：1、API地址 \ 2、用户ID \ 3、待上传的图片流 \ *
          ...
          ...          *返回：服务端响应内容*
          ${data}          Create Dictionary          UserId=${UserId}          ImageStreamString=${ImageStreamString}          sign=${Sign}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_headimage          ${API_URL}          ${header}
          ${response}          Post Request          member_headimage          api/member/headimage          data=${data}
          ${responsedata}          To Json          ${response.content}
          Log          ${responsedata}
          [Return]          ${responsedata}

修改个人信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_updateInfo          ${API_URL}          ${header}
          ${response}          Post Request          member_updateInfo          api/member/updateInfo          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

第三方登录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_thirdPartyLogin          ${API_URL}          ${header}
          ${response}          Post Request          member_thirdPartyLogin          api/member/thirdPartyLogin          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

绑定第三方账号
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_binding          ${API_URL}          ${header}
          ${response}          Post Request          member_binding          api/member/binding          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

新增发票抬头信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          invoice_title_add          ${API_URL}          ${header}
          ${response}          Post Request          invoice_title_add          api/invoice/title/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

删除发票抬头信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          invoice_title_delete          ${API_URL}          ${header}
          ${response}          Post Request          invoice_title_delete          api/invoice/title/delete          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

修改发票抬头信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          invoice_title_update          ${API_URL}          ${header}
          ${response}          Post Request          invoice_title_update          api/invoice/title/update          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取发票内容列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          invoice_context_list          ${API_URL}          ${header}
          ${response}          Post Request          invoice_context_list          api/invoice/context/list          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户的发票抬头列表
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          invoice_title_get          ${API_URL}          ${header}
          ${response}          Post Request          invoice_title_get          api/invoice/title/get          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

添加用户播放器浏览记录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_addbrowsedstores          ${API_URL}          ${header}
          ${response}          Post Request          member_addbrowsedstores          api/member/addbrowsedstores          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

批量删除用户播放器浏览记录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_deletebrowsedstores          ${API_URL}          ${header}
          ${response}          Post Request          member_deletebrowsedstores          api/member/deletebrowsedstores          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户播放器浏览记录
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          member_browsedstores          ${API_URL}          ${header}
          ${response}          Post Request          member_browsedstores          api/member/browsedstores          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
