*** Settings ***
Library           Selenium2Library
Resource          ../Common_Library.robot
Library           AutoItLibrary

*** Keywords ***
进入测试环境
    [Arguments]    ${Site_URL}    ${Test_Environment_Password}
    Open Browser    ${Site_URL}
    ${Password}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=password    10
    Run Keyword If    '${Password}'=='TRUE'    Input Password    id=password    ${Test_Environment_Password}
    Click Button    xpath=//div[@class="content--block"]/form/button
    [Return]    ${Site_URL}

点击个人中心的Icon
    ${personal_Center_Icon}    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[@id="UserInfo"]/a/span    10    #等待个人中心的图标可见
    Run Keyword And Return If    '${Personal_Center_Icon}'=='PASS'    AutoItLibrary.Mouse Down    xpath=//div[@id="UserInfo"]/a/span
    ...    ELSE    fail    找不到个人中心的图标    #等待个人中心的图标可见，悬浮至个人中心的图标上
    Click Element    xpath=//div[@id="UserInfo"]/a/span    #点击个人中心的图标

进入个人中心页面
    Wait Until Element Is Visible    xpath=//li[2]/div[@id="UserInfo"]/a/span    10    #等待个人中心的图标可见，悬浮至个人中心的图标上
    AutoItLibrary.Mouse Down    xpath=//li[2]/div[@id="UserInfo"]/a/span
    Mouse Over    xpath=//li[2]/div[@id="UserInfo"]/a/span
    Mouse Over    xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
    ${my_Collection}=    Get Text    xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
    ${my_Collection1}=    Set Variable    My Collection    #设置临时变量
    Run Keyword If    '${my_Collection}'=="${my_Collection1}"    Mouse Over    xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
    Click Element    xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span    #点击二级导航栏的"account"链接进行跳转

用户退出登录
    Wait Until Element Is Visible    xpath=//li[2]/div[@id="UserInfo"]/a/span    10    #等待个人中心的图标可见，悬浮至个人中心的图标上
    AutoItLibrary.Mouse Down    xpath=//li[2]/div[@id="UserInfo"]/a/span
    Mouse Over    xpath=//li[2]/div[@id="UserInfo"]/a/span    #鼠标悬浮至个人中心的icon上
    Mouse Over    xpath=//div[@id="shopify-section-header"]/header/nav/div//div[2]/a[3]    #鼠标悬浮至退出登录按钮上
    Click Element    xpath=//div[@id="shopify-section-header"]/header/nav/div//div[2]/a[3]    #点击退出登录的按钮
