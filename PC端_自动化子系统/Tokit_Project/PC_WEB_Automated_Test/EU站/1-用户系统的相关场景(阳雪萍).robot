*** Settings ***
Library                 AutoItLibrary
Resource                ../L3_Element_用户进行注册.robot
Resource                ../L2_Components.robot
Library                 Selenium2Library

*** Variables ***
${UserLogin_Name}          daisy@fstln.io          #用户登录邮箱
${UserLogin_Password}          Daisy123456

*** Test Cases ***
Case_用户进行注册
          [Setup]          Run Keywords          Import Library          OperatingSystem
          ...          AND          OperatingSystem.run          taskkill /F /IM WerFault.exe
          [Teardown]          Close All Browsers

Case_用户进行登录
          [Tags]          Automated
          Open Browser          ${CHUNMU_EU_URL}
          Maximize Browser Window
          ${personal_Center_Icon}          Run Keyword And Return Status          Wait Until Element Is Visible          xpath=//div[@id="UserInfo"]/a/span          10
          Run Keyword And Return If          '${Personal_Center_Icon}'=='PASS'          AutoItLibrary.Mouse Down          xpath=//div[@id="UserInfo"]/a/span
          ...          ELSE          fail          找不到个人中心的图标
          Click Element          xpath=//div[@id="UserInfo"]/a/span
          Wait Until Element Is Visible          xpath=//section[@class="container py-8"]/div/h2          10          #等待用户登录页面的标题可见
          Input Text          xpath=//input[@id="floatingInput"]          ${userLogin_Name}          #用户登录页面输入正确的用户邮箱
          Input Text          xpath=//input[@id="floatingPassword"]          ${userLogin_Password}          #用户登录页面输入正确的的密码
          Click Button          xpath=//form[@class="as-login-form mt-4"]/button          #点击登录按钮
          Wait Until Element Is Visible          xpath=//li[2]/div[@id="UserInfo"]/a/span          10
          AutoItLibrary.Mouse Down          xpath=//li[2]/div[@id="UserInfo"]/a/span
          Mouse Over          xpath=//li[2]/div[@id="UserInfo"]/a/span
          Mouse Over          xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
          ${my_Account}=          Run Keyword And Return Status          Get Text          xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
          Run Keyword And Return If          '${my_Account}'=="PASS"          AutoItLibrary.Mouse Down          xpath=//div[@id="UserInfo"]/a/span
          ...          ELSE          fail          获取个人中心的访问入口失败，无法进行至个人中心
          Click Element          xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span

Case_用户申请重置密码

*** Keywords ***
获取页面的元素
