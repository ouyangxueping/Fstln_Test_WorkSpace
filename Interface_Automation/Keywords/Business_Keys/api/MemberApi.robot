*** Settings ***
Documentation           *会员经验,签到相关 API*
...
...                     *过滤标记：‘绑定第三方账号’、’验证码检查‘、’手机短信验证码检查‘、’发送手机验证码2‘、’发送手机验证码3‘*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_MemberApi.txt

*** Test Cases ***
用户签到
          [Documentation]          *用户签到*
          ...
          ...          *参数注意：1、接口只主要提供Id参数，其他参数不需要提供。这里其他参数没做测试 2、有多种签到的场景（普通签到、经验值加倍）3、当用户达到最顶级的时候，也要返回True（暂时case中未考虑这种情况）*
          ...
          ...          *备注：azt_member_signin*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          id=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          ${have_signin}          查询用户是否当天已经签到          ${UserID}
          #请求
          ${responsedata}          用户签到          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          ${SignInDays}          查询用户最近的连续签到天数          ${UserID}
          ${SignInDays}          Evaluate          str(${SignInDays})          #转换成字符类型
          ${list}          Create List          2          7          21          30          #经验值翻倍的天数
          ${have_double_exp}          Run Keyword And Return Status          List Should Contain Value          ${list}          ${SignInDays}          用户未达到经验值翻倍的条件！
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          当天已签到          经验值加倍          当天已签到          普通签到          非法用户Id
          ...          非法用户Id          非法用户Id          非法用户Id
          ${Success_list}          Create List          True          True          True          True          False
          ...          False          False          False
          ${Json_list}          Create List          Member_SignIn.json          Member_SignIn.json          Member_SignIn.json          Member_SignIn.json          Member_SignIn.json
          ...          Member_SignIn.json          Member_SignIn.json          Member_SignIn.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${have_signin}          ${have_double_exp}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${have_signin}          ${have_double_exp}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${have_signin}          ${have_double_exp}
          Delete All Sessions

获取用户签到信息
          [Documentation]          *获取用户签到信息*
          ...
          ...          *参数注意：接口只主要提供Id参数，其他参数不需要提供。这里其他参数没做测试*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          id=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          获取用户签到信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          0不是合法的用户!          0不是合法的用户!          None          ${UserID}不是合法的用户!
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Member_GetSignInDetail.json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

获取用户的等级信息
          [Documentation]          *获取用户的等级信息*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          获取用户的等级信息          ${API_URL}          ${userId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          ${UserID}不是合法的用户!
          ${Success_list}          Create List          True          False
          ${Json_list}          Create List          Member_Grade.json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}
          Delete All Sessions

获取用户经验值列表信息
          [Documentation]          *获取用户经验值列表信息*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${userId}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          获取用户经验值列表信息          ${API_URL}          ${userId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Member_Exp.json          Member_Exp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}
          Delete All Sessions

Flash用户登录
          [Documentation]          *Flash用户登录*
          ...
          ...          *参数注意：接口参数的验证顺序为：1、判断是否参数数量是否正确 2、如果步骤1存在，则判断用户名是否存在 3、如果步骤2存在，则判断用户名对应的密码是否正确 4、如果前3步都返回True，则断定用户和密码正确，返回响应*
          ...
          ...          *备注：(实际上只需要提供用户名和密码参数即可。主要是获得数据库内用户加密前的密码字符串，由于用
          ...          户密码已经过md5加密处理，所以加密前的密码需要自定义设置。用自定义设置的密码去比较数据库内加密后的密码字符串)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserName}          Get From Dictionary          ${json_user_content}          UserName
          ${Password_before}          Set Variable          123456          #加密前的密码字符串，取不到只能自定义
          ${Password_after}          Get From Dictionary          ${json_user_content}          Password          #加密后的可以从数据库内获取
          ${PasswordSalt}          Get From Dictionary          ${json_user_content}          PasswordSalt          #数据库密码字符串的加密盐
          ${data}          Create Dictionary          username=${UserName}          password=${Password_before}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserName}          ${Password_before}
          #数据库
          ${have_user}          查询用户是否存在          ${UserName}          Name
          ${CreatePassword}          Create Password DB Str          ${Password_before}          ${PasswordSalt}
          ${Password_ok}          Run Keyword And Return Status          Should Be Equal          ${CreatePassword}          ${Password_after}          #数据库内的密码字符串与生成的做比较
          #请求
          ${responsedata}          Flash用户登录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          参数错误          参数错误          参数错误          参数错误          登录成功
          ...          登录失败          用户名和密码不匹配          登录失败
          ${Success_list}          Create List          False          False          False          False          True
          ...          False          False          False
          ${Json_list}          Create List          Member_Login(ERR).json          Member_Login(ERR).json          Member_Login(ERR).json          Member_Login(ERR).json          Member_Login.json
          ...          Member_Login(ERR).json          Member_Login(ERR).json          Member_Login(ERR).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}          ${Password_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}          ${Password_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}          ${Password_ok}
          Delete All Sessions

发送手机验证码1
          [Documentation]          *发送手机验证码(App端手机登录时点击获取验证码按钮调用)*
          ...
          ...          *参数注意：*
          ...
          ...          *数据库操作：表 azt_messagelog，新增记录*
          ...
          ...          *备注：与后面的接口 “手机快捷登录” 组合使用*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${Phone}          Set Variable          13025428825
          ${Phone}          Get From Dictionary          ${json_user_content}          Phone
          ${data}          Create Dictionary          phone=${Phone}          sign=${Sign}
          #数据库
          #请求
          ${responsedata1}          发送手机验证码1          ${API_URL}          ${data}
          ${Message1}          Get From Dictionary          ${responsedata1}          Message
          ${Success1}          Get From Dictionary          ${responsedata1}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Success_list1}          Create List          True
          ${Json_list1}          Create List          Common_Temp.json
          Validate Output Results          ${Success1}          ${Success_list1}
          Validate Json By Condition          ${Json_list1}          ${responsedata1}
          Delete All Sessions
          #再次请求
          ${responsedata2}          发送手机验证码1          ${API_URL}          ${data}
          ${Message2}          Get From Dictionary          ${responsedata2}          Message
          ${Success2}          Get From Dictionary          ${responsedata2}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list2}          Create List          频繁调用（同一个IP对同一个API调用间隔为3秒）
          ${Success_list2}          Create List          False
          ${Json_list2}          Create List          Common_Temp.json
          Validate Output Results          ${Message2}          ${Message_list2}
          Validate Output Results          ${Success2}          ${Success_list2}
          Validate Json By Condition          ${Json_list2}          ${responsedata2}
          Delete All Sessions
          #更新验证码到公共数据文件
          ${code}          数据库获取验证码
          Set To Dictionary          ${json_user_content}          MessageCode1=${code}
          Create_Common_Arg          ${json_user_content}          Common_Arg(User).json          #重新写入公共数据文件

手机快捷登录
          [Documentation]          *手机快捷登录*
          ...
          ...          *参数注意：该接口的验证码参数必须先调用 ’发送手机验证码1‘接口后获取到验证码再来执行*
          ...
          ...          *备注：需要对比校验数据库中和数据文件中是否一致，避免重复调用时验证码不一致的问题*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${phone}          Set Variable          13025428825
          ${phone}          Get From Dictionary          ${json_user_content}          Phone
          ${apitoken}          Set Variable          ${EMPTY}
          ${id}          Set Variable          0
          ${code}          数据库获取验证码
          ${number}          Get From Dictionary          ${json_user_content}          MessageCode1
          ${password}          Set Variable          ${EMPTY}
          ${UserName}          Get From Dictionary          ${json_user_content}          UserName
          ${data}          Create Dictionary          username=${UserName}          password=${password}          id=${id}          number=${number}          phone=${phone}
          ...          apitoken=${apitoken}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${number}
          #数据库
          #请求
          ${responsedata}          移动端用户登录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          验证码不对          登录成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Member_Login(ERR).json          Member_Login.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

发送手机验证码2
          [Documentation]          *发送手机验证码(App端找回密码时点击获取验证码按钮调用)*
          ...
          ...          *参数注意：*
          ...
          ...          *注意：< 该接口并没有判断用户是否绑定手机号和邮箱 >*
          sleep          60
          ${json_user_content}          读取买家通用数据
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          #创建参数字典
          Comment          ${Phone}          Set Variable          1234567
          ${Phone}          Get From Dictionary          ${json_user_content}          Phone
          ${Email}          Get From Dictionary          ${json_user_content}          Email
          ${list1}          Create List          ${Phone}          #          ${Email}          找回密码功能app只有手机号找回
          ${destination}          Get Random Choice Number          ${list1}
          ${list2}          Create List          1002          #发送验证码的业务编码 1001:注册用户 1002:找回密码 1003:更改绑定时向旧邮箱或手机发送验证码 1004:更改绑定时向新邮箱或手机发送验证码 1005:更改分销绑定时向新邮箱或手机发送验证码          #暂时只针对找回密码功能
          ${businessCode}          Get Random Choice Number          ${list2}          #随机取一个业务编码
          ${pluginId}          Set Variable If          '${destination}' == '${Phone}'          Himall.Plugin.Message.SMS          Himall.Plugin.Message.Email          #验证码类型 "Himall.Plugin.Message.SMS":手机验证码 "Himall.Plugin.Message.Email":邮箱验证码
          ${data}          Create Dictionary          destination=${destination}          businessCode=${businessCode}          pluginId=${pluginId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          ${None}
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当有参数为空时，其实就是异常了！
          #数据库
          ${ValidBindCellAndEmail}          查询用户是否已绑定手机和邮箱          ${UserID}
          #请求
          ${responsedata1}          发送手机验证码2          ${API_URL}          ${data}
          ${Message1}          Get From Dictionary          ${responsedata1}          Message
          ${Success1}          Get From Dictionary          ${responsedata1}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list1}          Create List          None
          ${Success_list1}          Create List          True
          ${Json_list1}          Create List          Common_Temp(None).json
          Validate Output Results          ${Message1}          ${Message_list1}
          Validate Output Results          ${Success1}          ${Success_list1}
          Validate Json By Condition          ${Json_list1}          ${responsedata1}
          Delete All Sessions
          #更新验证码到公共数据文件
          Sleep          5
          Pass Execution If          ${have_not_par[1]}          发送验证码失败了，所以就不更新公共数据文件
          ${code}          数据库获取验证码
          Set To Dictionary          ${json_user_content}          MessageCode2=${code}
          Create_Common_Arg          ${json_user_content}          Common_Arg(User).json          #重新写入公共数据文件

手机短信验证码检查
          [Documentation]          *手机短信验证码检查(App端找回密码时校验验证码时调用)*
          ...
          ...          *参数注意：暂时还不确定怎么去组织参数 （待定）*
          ...
          ...          *备注：*
          [Tags]          filter
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${code}          Get From Dictionary          ${json_user_content}          MessageCode2
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Phone}          Get From Dictionary          ${json_user_content}          Phone
          ${Email}          Get From Dictionary          ${json_user_content}          Email
          ${list1}          Create List          ${Phone}          ${Email}          #手机号或邮箱
          ${destination}          Get Random Choice Number          ${list1}
          ${list2}          Create List          1001          1002          1003          1004          1005
          ...          #发送验证码的业务编码 1001:注册用户 1002:找回密码 1003:更改绑定时向旧邮箱或手机发送验证码 1004:更改绑定时向新邮箱或手机发送验证码 1005:更改分销绑定时向新邮箱或手机发送验证码
          ${businessCode}          Get Random Choice Number          ${list2}          #随机取一个业务编码
          ${pluginId}          Set Variable If          '${destination}' == '${Phone}'          Himall.Plugin.Message.SMS          Himall.Plugin.Message.Email          #验证码类型 "Himall.Plugin.Message.SMS":手机验证码 "Himall.Plugin.Message.Email":邮箱验证码
          Comment          ${list3}          Create List          Himall.Plugin.Message.SMS          Himall.Plugin.Message.Email          #验证码类型 "Himall.Plugin.Message.SMS":手机验证码 "Himall.Plugin.Message.Email":邮箱验证码
          Comment          ${pluginId}          Get Random Choice Number          ${list3}          #随机取一个验证类型
          ${data}          Create Dictionary          code=${code}          userId=${UserID}          pluginId=${pluginId}          destination=${destination}          businessCode=${businessCode}
          ...          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${code}          ${UserID}
          ...          ${pluginId}          ${destination}          ${businessCode}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          手机短信验证码检查          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          验证码不正确或者已经超时          0不是合法的用户!          None          ${UserID}不是合法的用户!
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

发送手机验证码3
          [Documentation]          *发送手机验证码*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          [Tags]          filter
          sleep          10
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Phone}          Get From Dictionary          ${json_user_content}          Phone
          ${Email}          Get From Dictionary          ${json_user_content}          Email
          ${list1}          Create List          ${Phone}          ${Email}          #手机号或邮箱
          ${destination}          Get Random Choice Number          ${list1}
          ${list2}          Create List          1001          1002          1003          1004          1005
          ...          #发送验证码的业务编码 1001:注册用户 1002:找回密码 1003:更改绑定时向旧邮箱或手机发送验证码 1004:更改绑定时向新邮箱或手机发送验证码 1005:更改分销绑定时向新邮箱或手机发送验证码
          ${businessCode}          Get Random Choice Number          ${list2}          #随机取一个业务编码
          ${list3}          Create List          Himall.Plugin.Message.SMS          Himall.Plugin.Message.Email          #验证码类型 "Himall.Plugin.Message.SMS":手机验证码 "Himall.Plugin.Message.Email":邮箱验证码
          ${pluginId}          Get Random Choice Number          ${list3}          #随机取一个验证类型
          ${data}          Create Dictionary          destination=${destination}          businessCode=${businessCode}          pluginId=${pluginId}          sign=${Sign}
          #数据库
          #请求
          ${responsedata1}          发送手机验证码3          ${API_URL}          ${data}
          ${Message1}          Get From Dictionary          ${responsedata1}          Message
          ${Success1}          Get From Dictionary          ${responsedata1}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list1}          Create List          已经被其它用户绑定
          ${Success_list1}          Create List          True
          ${Json_list1}          Create List          Common_Temp.json
          Validate Output Results          ${Message1}          ${Message_list1}
          Validate Output Results          ${Success1}          ${Success_list1}
          Validate Json By Condition          ${Json_list1}          ${responsedata1}
          Delete All Sessions
          #再次请求
          ${responsedata2}          发送手机验证码3          ${API_URL}          ${data}
          ${Message2}          Get From Dictionary          ${responsedata2}          Message
          ${Success2}          Get From Dictionary          ${responsedata2}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list2}          Create List          1分钟内只允许请求一次，请稍后重试!
          ${Success_list2}          Create List          False
          ${Json_list2}          Create List          Common_Temp.json
          Validate Output Results          ${Message2}          ${Message_list2}
          Validate Output Results          ${Success2}          ${Success_list2}
          Validate Json By Condition          ${Json_list2}          ${responsedata2}
          Delete All Sessions

验证码检查
          [Documentation]          *验证码检查*
          ...
          ...          *参数注意：暂时还不确定怎么去组织参数 （待定）*
          ...
          ...          *备注：*
          [Tags]          filter
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${code}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Phone}          Get From Dictionary          ${json_user_content}          Phone
          ${Email}          Get From Dictionary          ${json_user_content}          Email
          ${list1}          Create List          ${Phone}          ${Email}          #手机号或邮箱
          ${destination}          Get Random Choice Number          ${list1}
          ${list2}          Create List          1001          1002          1003          1004          1005
          ...          #发送验证码的业务编码 1001:注册用户 1002:找回密码 1003:更改绑定时向旧邮箱或手机发送验证码 1004:更改绑定时向新邮箱或手机发送验证码 1005:更改分销绑定时向新邮箱或手机发送验证码
          ${businessCode}          Get Random Choice Number          ${list2}          #随机取一个业务编码
          ${list3}          Create List          Himall.Plugin.Message.SMS          Himall.Plugin.Message.Email          #验证码类型 "Himall.Plugin.Message.SMS":手机验证码 "Himall.Plugin.Message.Email":邮箱验证码
          ${pluginId}          Get Random Choice Number          ${list3}          #随机取一个验证类型
          ${data}          Create Dictionary          code=${code}          userId=${UserID}          pluginId=${pluginId}          destination=${destination}          businessCode=${businessCode}
          ...          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${code}          ${UserID}
          ...          ${pluginId}          ${destination}          ${businessCode}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          验证码检查          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List
          ${Success_list}          Create List
          ${Json_list}          Create List
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

用户注册
          [Documentation]          *用户注册*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          ${Phone}          Get Random Number String          11
          ${UserName}          Get Random Chinese String          3
          ${Password}          Set Variable          123456
          ${data}          Create Dictionary          destination=${Phone}          username=${UserName}          password=${Password}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${Phone}          ${UserName}
          ...          ${Password}
          #数据库
          ${have_user}          查询用户是否存在          ${UserName}          Name
          ${have_Phone}          查询手机号是否存在          ${Phone}
          #请求
          ${responsedata}          用户注册          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          参数错误          参数错误          参数错误          参数错误          用户名 ${UserName} 已经被其它会员注册
          ...          电话 ${Phone} 已经被其它会员注册          用户名 ${UserName} 已经被其它会员注册          注册成功
          ${Success_list}          Create List          False          False          False          False          False
          ...          False          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}          ${have_Phone}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}          ${have_Phone}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}          ${have_Phone}
          Delete All Sessions

更改密码
          [Documentation]          *更改密码*
          ...
          ...          *参数注意：分别从参数数量、用户是否存在、初始密码正确、新密码长度方面测试*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Password_before}          Get From Dictionary          ${json_user_content}          Password          #加密后的可以从数据库内获取
          ${Password_after}          Set Variable          123456          #取不到只能自定义
          ${PasswordSalt}          Get From Dictionary          ${json_user_content}          PasswordSalt          #数据库密码字符串的加密盐
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          ${CreatePassword}          Create Password DB Str          ${Password_after}          ${PasswordSalt}
          ${Password_ok}          Run Keyword And Return Status          Should Be Equal          ${CreatePassword}          ${Password_before}          #数据库内的密码字符串与生成的做比较
          ${Password_before}          Run Keyword If          ${Password_ok}          Set Variable          123456
          ...          ELSE          Pass Execution          旧密码错误！          #如果相等则表示原密码就是123456
          ${length} =          Get Length          ${Password_after}          #设置的密码必须大于6个字符
          ${Password_length_ok}          Run Keyword And Return Status          Should Be True          ${length} >= 6
          #请求
          ${data}          Create Dictionary          userId=${UserID}          oldpassword=${Password_before}          password=${Password_after}          sign=${Sign}
          ${responsedata}          更改密码          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证密码长度
          Pass Execution If          not ${Password_length_ok}          密码长度不够6位，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          修改成功！          旧密码错误！          ${EMPTY}          旧密码错误！          该用户不存在！
          ...          该用户不存在！          该用户不存在！          该用户不存在！
          ${Success_list}          Create List          True          False          ${EMPTY}          False          False
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          ${EMPTY}          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${Password_ok}          ${Password_length_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${Password_ok}          ${Password_length_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${Password_ok}          ${Password_length_ok}
          Delete All Sessions
          #更改密码后重新更新密码信息到基础文件
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${query}          Query          select Password,PasswordSalt from azt_members where id="${UserID}"
          Disconnect From Database
          Set To Dictionary          ${json_user_content}          Password=${query[0][0]}
          Set To Dictionary          ${json_user_content}          PasswordSalt=${query[0][1]}
          Create_Common_Arg          ${json_user_content}          Common_Arg(User).json          #重新写入公共数据文件

找回密码
          [Documentation]          *找回密码*
          ...
          ...          *参数注意： type参数在app端取的是 “phone” *
          ...
          ...          *数据表操作： 验证用户是否存在时，需要同时查询表 azt_membercontacts *
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${type}          Set Variable          phone
          ${contact}          Get From Dictionary          ${json_user_content}          UserName          #账号
          ${Password_after}          Set Variable          123456          #取不到只能自定义
          ${data}          Create Dictionary          type=${type}          contact=${contact}          password=${Password_after}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${type}          ${contact}
          ...          ${Password_after}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          ${have_user}          查询用户是否存在          ${contact}          Name
          ${user_bind_ok}          查询用户是否已绑定手机和邮箱          ${UserID}
          Pass Execution If          not ${have_user}          当用户不存在时，其实就是异常了！
          Pass Execution If          not ${user_bind_ok}          当用户不存在时，其实就是异常了！
          #请求
          ${responsedata}          找回密码          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          设置成功！
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

增加收货地址
          [Documentation]          *增加收货地址*
          ...
          ...          *参数注意： 接口返回的message内容是个数据库id，所以测试时不验证message*
          ...
          ...          *备注：由于区域ID是由客户端生成的所以这里只能自定义写死区域ID*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShipTo}          Get Random Chinese String          3          #收货人
          ${RegionId}          Set Variable          102          #区域ID
          ${Phone}          Get Random Number String          11
          ${Address}          Get Random Chinese String          20
          ${data}          Create Dictionary          Address=${Address}          Phone=${Phone}          RegionId=${RegionId}          ShipTo=${ShipTo}          UserId=${UserID}
          ...          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          增加收货地址          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

修改收货地址
          [Documentation]          *修改收货地址*
          ...
          ...          *参数注意： 接口参数验证顺序为：1、检查收货地址id和用户id是否存在 \ 2、检查数据库中是否合法 *
          ...
          ...          *备注：由于区域ID是由客户端生成的所以这里只能自定义写死区域ID*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ID}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${ShipTo}          Get Random Chinese String          3          #收货人
          ${RegionId}          Set Variable          118          #区域ID
          ${Phone}          Get Random Number String          11
          ${Address}          Get Random Chinese String          20
          ${data}          Create Dictionary          Id=${ID}          Address=${Address}          Phone=${Phone}          RegionId=${RegionId}          ShipTo=${ShipTo}
          ...          UserId=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${ID}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          ${have_AddressID}          查询收货地址是否存在          ${ID}
          #请求
          ${responsedata}          修改收货地址          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          ${EMPTY}
          ...          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！
          ${Success_list}          Create List          False          False          False          False          True
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}          ${have_AddressID}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}          ${have_AddressID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}          ${have_AddressID}
          Delete All Sessions

删除收货地址
          [Documentation]          *删除收货地址*
          ...
          ...          *参数注意： 接口参数验证顺序为：1、检查收货地址id和用户id是否存在 \ 2、检查数据库中是否合法 *
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ID}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          id=${ID}          userId=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${ID}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          ${have_AddressID}          查询收货地址是否存在          ${ID}
          #请求
          ${responsedata}          删除收货地址          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          ${EMPTY}
          ...          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！          该收货地址不存在或已被删除！
          ${Success_list}          Create List          False          False          False          False          True
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}          ${have_AddressID}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}          ${have_AddressID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}          ${have_AddressID}
          Delete All Sessions

获取收货地址
          [Documentation]          *获取收货地址*
          ...
          ...          *参数注意： \ *
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          userId=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          #请求
          ${responsedata}          获取收货地址          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          输入字符串的格式不正确。          ${EMPTY}
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          Member_Address.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

设置默认收货地址
          [Documentation]          *设置默认收货地址*
          ...
          ...          *参数注意： 接口只验证地址id和用户id参数是否存在。并不验证数据库中是否合法*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ID}          Get From Dictionary          ${json_user_content}          User_AddressID
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          userId=${UserID}          id=${ID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${ID}          ${UserID}
          #数据库
          #请求
          ${responsedata}          设置默认收货地址          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          设置失败          None
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Comment          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

上传用户头像
          [Documentation]          *上传用户头像*
          ...
          ...          *参数注意： 1、用户头像图片取的是本地图片。虽然接口上传图片至云服务器且有写入数据库*
          ...
          ...          *2、接口上传的服务器路径跟页面上传的服务器路径是不同的 *
          ...
          ...          *3、图片上传的顺序为：temp目录--->Storage\\Member\\Head目录 --->云服务器*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ImageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\HeadImage.jpg
          Comment          ${UserID}          Set Variable          633
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          #数据库
          #请求
          ${responsedata}          上传用户头像          ${API_URL}          ${UserID}          ${ImageStreamString}
          ${str1}          Get From Dictionary          ${responsedata}          Message
          ${str2}          Get From Dictionary          ${responsedata}          Success
          ${image_path}          Get From Dictionary          ${responsedata}          Value
          Delete All Sessions

修改个人信息
          [Documentation]          *修改个人信息*
          ...
          ...          *参数注意： \ *
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${qqNum}          Get Random Number String          10          #qq号码
          ${realName}          Get Random Chinese String          3          #真实姓名
          ${nickName}          Get Random Character String          7          #昵称
          ${data}          Create Dictionary          userId=${UserID}          qqNum=${qqNum}          realName=${realName}          nickName=${nickName}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          修改个人信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          参数错误:用户Id为0          参数错误:用户Id为0          修改成功          未将对象引用设置到对象的实例。
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

第三方登录
          [Documentation]          *第三方登录*
          ...
          ...          *参数注意： （实际上就一个参数是最主要的，openid，其他参数可以不带。openid参数绑定后保存在azt_memberopenids表内）*
          ...
          ...          *备注：*
          [Tags]          filter
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${OpenId}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${HeadImage}
          ${ThirdPartyType}
          ${additionalMemberInfoSwitch}
          ${productIds}
          ${shopId}
          ${data}          Create Dictionary          OpenId=${OpenId}          UserId=${UserID}          HeadImage=${HeadImage}          ThirdPartyType=${ThirdPartyType}          additionalMemberInfoSwitch=${additionalMemberInfoSwitch}
          ...          productIds=${productIds}          shopId=${shopId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          第三方登录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List
          ${Success_list}          Create List
          ${Json_list}          Create List
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

绑定第三方账号
          [Documentation]          *绑定第三方账号*
          ...
          ...          *参数注意： \ （暂时还不确定怎么来获取参数，待定）*
          ...
          ...          *备注：*
          [Tags]          filter
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${OpenId}
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${HeadImage}
          ${ThirdPartyType}
          ${additionalMemberInfoSwitch}
          ${productIds}
          ${shopId}
          ${data}          Create Dictionary          OpenId=${OpenId}          UserId=${UserID}          HeadImage=${HeadImage}          ThirdPartyType=${ThirdPartyType}          additionalMemberInfoSwitch=${additionalMemberInfoSwitch}
          ...          productIds=${productIds}          shopId=${shopId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          绑定第三方账号          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List
          ${Success_list}          Create List
          ${Json_list}          Create List
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

新增发票抬头信息
          [Documentation]          *新增发票抬头信息*
          ...
          ...          *参数注意： \ 接口并未做用户有效性验证*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Name}          Get Random Chinese String          5          #发票title名称
          ${IsDefault}          Get Range Number String          -128          127          #是否为默认 title          #SByte 类型，取值范围为整型的 -128 到 127
          ${data}          Create Dictionary          UserId=${UserID}          Name=${Name}          IsDefault=${IsDefault}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          新增发票抬头信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

删除发票抬头信息
          [Documentation]          *删除发票抬头信息*
          ...
          ...          *参数注意： \ 接口只判断了发票抬头id，其他参数没什么意义*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ID}          Get From Dictionary          ${json_user_content}          User_InvoiceTitleID
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Name}          Get Random Chinese String          5          #发票title名称
          ${IsDefault}          Get Range Number String          -128          127          #是否为默认 title          #SByte 类型，取值范围为整型的 -128 到 127
          ${data}          Create Dictionary          Id=${ID}          UserId=${UserID}          Name=${Name}          IsDefault=${IsDefault}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ID}
          #数据库
          ${have_ID}          查询发票抬头信息是否存在          ${ID}
          #请求
          ${responsedata}          删除发票抬头信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          删除发票抬头信息失败!          删除发票抬头信息失败!          ${EMPTY}          删除发票抬头信息失败!
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_ID}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_ID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_ID}
          Delete All Sessions

修改发票抬头信息
          [Documentation]          *修改发票抬头信息*
          ...
          ...          *参数注意： \ 接口只判断了发票抬头id，其他参数只为了更新数据库字段*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${ID}          Get From Dictionary          ${json_user_content}          User_InvoiceTitleID
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Name}          Get Random Chinese String          5          #发票title名称
          ${IsDefault}          Get Range Number String          -128          127          #是否为默认 title          #SByte 类型，取值范围为整型的 -128 到 127
          ${data}          Create Dictionary          Id=${ID}          UserId=${UserID}          Name=${Name}          IsDefault=${IsDefault}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${ID}
          #数据库
          ${have_ID}          查询发票抬头信息是否存在          ${ID}
          #请求
          ${responsedata}          修改发票抬头信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          该发票抬头信息不存在或已被删除！          该发票抬头信息不存在或已被删除！          ${EMPTY}          该发票抬头信息不存在或已被删除！
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_ID}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_ID}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_ID}
          Delete All Sessions

获取发票内容列表
          [Documentation]          *获取发票内容列表*
          ...
          ...          *参数注意： 不明白这个接口的具体参数表示意义*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${shopIds}          Get From Dictionary          ${json_manager_content}          ShopId
          ${data}          Create Dictionary          shopIds=${shopIds}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${shopIds}
          #数据库
          #请求
          ${responsedata}          获取发票内容列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          InvoiceContext_List.json          InvoiceContext_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取用户的发票抬头列表
          [Documentation]          *获取用户的发票抬头列表*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${data}          Create Dictionary          userId=${UserID}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #数据库
          #请求
          ${responsedata}          获取用户的发票抬头列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          输入字符串的格式不正确。          ${EMPTY}
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          ParameterError_Temp(Data).json          InvoiceTitle_get.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

添加用户播放器浏览记录
          [Documentation]          *添加用户播放器浏览记录*
          ...
          ...          *参数注意： \ 接口只做了参数检查和用户id是否有效的检查，对于storeid和storename并未做检查, storename可以为空*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${data}          Create Dictionary          userId=${UserID}          storeId=${storeId}          storeName=${storeName}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${storeId}
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          #请求
          ${responsedata}          添加用户播放器浏览记录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          输入字符串的格式不正确。          输入字符串的格式不正确。          ${EMPTY}          更新条目时出错。有关详细信息，请参阅内部异常。
          ${Success_list}          Create List          False          False          True          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_user}
          Delete All Sessions

批量删除用户播放器浏览记录
          [Documentation]          *批量删除用户播放器浏览记录*
          ...
          ...          *参数注意： \ *
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${data}          Create Dictionary          userId=${UserID}          storeIds=${storeId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${storeId}
          #数据库
          #请求
          ${responsedata}          批量删除用户播放器浏览记录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          输入字符串的格式不正确。          ${EMPTY}
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取用户播放器浏览记录
          [Documentation]          *获取用户播放器浏览记录*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          userId=${UserID}          pageNo=${PageNo}          pageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${PageNo}
          ...          ${PageSize}
          #数据库
          #请求
          ${responsedata}          获取用户播放器浏览记录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          输入字符串的格式不正确。          ${EMPTY}
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Member_BrowsedStores.json          Member_BrowsedStores.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions
