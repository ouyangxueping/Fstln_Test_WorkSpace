*** Settings ***
Library           AutoItLibrary
Resource          ../Common_Library.robot
Library           Selenium2Library
Resource          L3_Element_用户进行登录.robot
Resource          L2_Components.robot
Library           DatabaseLibrary

*** Variables ***
${UserLogin_Name}    daisy@fstln.io    #用户登录邮箱
${UserLogin_Password}    Daisy123456
${Register_Account_Suffixt}    Test@fstln.io

*** Test Cases ***
Case_用户进行注册
    [Setup]    Run Keywords    Import Library    OperatingSystem
    ...    AND    OperatingSystem.run    taskkill /F /IM WerFault.exe
    #    Open Browser    ${Tokit_Recipes_NA_URL}    #打开浏览器
    进入测试环境    ${Tokit_TestDev_URL}
    点击个人中心的Icon
    Wait Until Element Is Visible    xpath=//section[@class="container py-8"]/div/div[3]/a[1]    15
    ${Create_Account1}=    Set Variable    Create Account
    ${Create_Account}=    Get Text    xpath=//section[@class="container py-8"]/div/div[3]/a[1]
    Run Keyword If    '${Create_Account}'=='${Create_Account1}'    Click Element    xpath=//section[@class="container py-8"]/div/div[3]/a[1]
    ...    ELSE    FAIL    页面找不到"Create Account"的跳转地址
    Wait Until Element Is Enabled    id=email-register    10
    ${time}=    Evaluate    datetime.datetime.now().strftime('%H%M%S')    datetime    #获取当前的日期戳
    ${Register_Account_Suffixt}    Set Variable    ${time}${Register_Account_Suffixt}    #使用获取的时间戳，作为新注册的邮箱
    Set Global Variable    ${Register_Account_Suffixt}
    Input Text    xpath=//input[@id="email-register"]    ${Register_Account_Suffixt}
    Click Element    xpath=//input[@id="flexCheckDefault"]
    Click Button    xpath=//form[@class="as-check-email-form mt-4"]/button
    Sleep    3
    ${set_pwd}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=set-pwd    10
    Run Keyword If    "${set_pwd}"=="PASS"    Mouse Over    id=set-pwd
    Input Text    id=set-pwd    Daisy123456
    ${Input_Password}    Get Text    id=set-pwd
    Set Global Variable    ${Input_Password}
    Input Text    id=confirm-pwd    Daisy123456
    Click Button    xpath=//form[@class="as-set-pwd-form mt-4"]/button
    Sleep    5
    Wait Until Element Is Visible    id=username    10
    #    ${Register_Account_Suffixt}    Evaluate    "${Register_Account_Suffixt}".split("@")[0]    #将邮箱进行拆分，获取@前面的数据
    Click Button    xpath=//form[@class="as-set-username-form mt-4"]/button
    进入个人中心页面
    Wait Until Element Is Visible    xpath=//body[@id="account"]/div[4]//div/div[1]/p[2]    10
    ${Register_Account_Suffixt1}    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[@id="UserInfo"]/a/span    10    #等待个人中心的图标可见
    Run Keyword And Return If    "${Register_Account_Suffixt}"=="${Register_Account_Suffixt1}"    用户退出登录
    ...    ELSE    fail    系统获取用户昵称失败
    [Teardown]    Close All Browsers

Case_用户进行登录
    #    Open Browser    ${Tokit_Recipes_NA_URL}    #打开浏览器
    进入测试环境    ${Tokit_TestDev_URL}
    Maximize Browser Window    #将浏览器最大化
    点击个人中心的Icon
    Wait Until Element Is Visible    xpath=//section[@class="container py-8"]/div/h2    10    #等待用户登录页面的标题可见
    Input Text    xpath=//input[@id="floatingInput"]    ${userLogin_Name}    #用户登录页面输入正确的用户邮箱
    Input Text    xpath=//input[@id="floatingPassword"]    ${userLogin_Password}    #用户登录页面输入正确的的密码
    Click Button    xpath=//form[@class="as-login-form mt-4"]/button    #点击登录按钮
    进入个人中心页面
    Wait Until Element Is Visible    xpath=//ul[@class="list-unstyled mb-0"]/li[1]/a/span    10
    ${My_profile}    Get Text    xpath=//ul[@class="list-unstyled mb-0"]/li[1]/a/span
    ${My_profile1}    Set Variable    My profile    #设置临时变量
    Run Keyword If    '${My_profile}'=='${My_profile1}'    Click Element    xpath=//ul[@class="list-unstyled mb-0"]/li[1]/a/span
    ...    ELSE    fail    获取个人中心的二级导航"My profile"失败
    Close Browser

Case_用户申请重置密码

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
