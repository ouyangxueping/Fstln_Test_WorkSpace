*** Settings ***
Library           AutoItLibrary
Resource          ../Common_Library.robot
Library           Selenium2Library
Resource          L3_Element_用户进行登录.robot
Resource          L2_Components.robot
Library           DatabaseLibrary
Resource          L3_Element_用户进行注册.robot
Resource          L3_Element_用户申请重置密码.robot

*** Variables ***
${UserLogin_Name}    daisy@fstln.io    #用户登录邮箱
${UserLogin_Password}    Daisy123456    #用户登录密码
${Register_Account_Suffixt}    Test@fstln.io    #新注册账号
${Site_URL}       https://chunmi.myshopify.com/    #测试环境的访问地址
${Test_Environment_Password}    chunmi_    #访问测试环境的密码
${Set_New_Password}    Daisy123456

*** Test Cases ***
Case_用户进行注册
    [Setup]
    Open Browser    ${Tokit_Recipes_NA_URL}    ${Browser_Type}    #打开浏览器
    将浏览器最大化
    #    校验是否为测试环境    ${Tokit_Recipes_NA_URL}    chunmi_    #打开浏览器
    点击个人中心的icon
    跳转至注册页面
    输入未注册账号进行注册    ${Register_Account_Suffixt}
    悬浮至设置密码的文本框
    输入新密码    ${Set_New_Password}
    输入二次确认密码    ${Set_New_Password}
    等待设置用户昵称可见
    点击设置昵称页面的下一步
    进入个人中心页面
    等待个人中心的图标可见
    判断用户邮箱可见后退出登录
    关闭浏览器
    [Teardown]    Run Keyword If    '${PREV TEST STATUS}'=='FAIL'    fail    Run Keywords    Import Library    OperatingSystem
    ...    AND    OperatingSystem.run    taskkill /F /IM WerFault.exe

Case_用户进行登录
    Open Browser    ${Tokit_Recipes_EU_URL}    #打开浏览器
    将浏览器最大化
    点击个人中心的Icon
    用户进行登录    ${UserLogin_Name}    ${userLogin_Password}
    进入个人中心页面
    加载菜单后点击个人中心    1
    关闭浏览器
    [Teardown]    Run Keyword If    '${PREV TEST STATUS}'=='FAIL'    fail    Run Keywords    Import Library    OperatingSystem
    ...    AND    OperatingSystem.run    taskkill /F /IM WerFault.exe

Case_用户申请重置密码
    Open Browser    ${Tokit_Recipes_EU_URL}    #打开浏览器
    将浏览器最大化
    点击个人中心的Icon
    跳转至重置密码页面
    输入已注册邮箱进行重置密码
    重置密码页面点击ReSet按钮
    判断页面是否展示重置密码的邮箱

Case_调试数据
    ${my_Account1}=    Set Variable    My account
    log    ${my_Account1}
    ${time}=    Evaluate    datetime.datetime.now().strftime('%H%M%S')    datetime    #获取当前的日期戳
    ${Register_Account_Suffixt}    Set Variable    ${time}${Register_Account_Suffixt}    #使用获取的时间戳，作为新注册的邮箱
    log    ${time}
    ${Register_Account_Suffixt}    Set Variable    185252522@fstln.io
    ${Register_Account_Suffixt}    Evaluate    "${Register_Account_Suffixt}".split("@")[0]    #拆分字符串，只获取@前面的字符
    log    ${Register_Account_Suffixt}
    Open Browser    https://account.tokitglobal.com/na-cooknjoy/set-password/?source=store&store=cooknjoy&callback=https%3A%2F%2Fna.cooknjoy.tokitglobal.com%2Faccount%2Flogin&return_to=https%3A%2F%2Fna.cooknjoy.tokitglobal.com%2Fpages%2Fredirect%3Freturn_to%3Dhttps%3A%2F%2Fna.cooknjoy.tokitglobal.com%2F&email=MTY0NzAzVGVzdEBmc3Rsbi5pbw%3D%3D
    ${set_pwd}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=set-pwd    10
    Run Keyword If    "${set_pwd}"=="PASS"    Mouse Over    id=set-pwd
    Input Text    id=set-pwd    Daisy123456
    ${Input_Password}    Get Text    id=set-pwd
    Set Global Variable    ${Input_Password}
    Input Text    id=confirm-pwd    Daisy123456
    Click Button    xpath=//form[@class="as-set-pwd-form mt-4"]/button

1-Case_数据库初始化
    #先处理下数据库
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    db='aws-test',user='root',password='ng6brE9LqSrt0M4H8HUD',host='18.167.6.45',port=3306
    ${query}=    DatabaseLibrary.Query    SELECT * FROM users
    log    ${query}
    Execute Sql String    SELECT * FROM users
    Disconnect From Database
    #    Connect To Database Using Custom Params    pyodbc    "Driver={MySQL ODBC 5.3 Unicode Driver};Server=18.167.6.45;Port=22;Database=aws-test;User=root;Password=ng6brE9LqSrt0M4H8HUD;"

*** Keywords ***
