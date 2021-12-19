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
          Open Browser          ${CHUNMU_EU_URL}
          Maximize Browser Window
          ${Personal_Center_Icon}          Run Keyword And Return Status          Wait Until Element Is Visible          xpath=//div[@id="UserInfo"]/a/span          10
          Run Keyword If          ${Personal_Center_Icon}=='PASS'          AutoItLibrary.Mouse Down          xpath=//div[@id="UserInfo"]/a/span
          ...          ELSE          log          找不到个人中心的图标
          Click Element          xpath=//div[@id="UserInfo"]/a/span
          ${Wait_Login_Page}=          Run Keyword And Return Status          Wait Until Element Is Visible          xpath=//section[@class="container py-8"]/div/h2          10
          Run Keyword If          ${Wait_Login_Page}=='PASS'          Input Text          ${UserLogin_Name}
          Input Text          ${UserLogin_Name}          xpath=//input[@id="floatingInput"]
          Input Text          ${UserLogin_Password}          xpath=//input[@id="floatingPassword"]
          AutoItLibrary.Mouse Down          xpath=//section[class="container py-8"]/div/form/button
          Click Button          xpath=//section[class="container py-8"]/div/form/button
          Wait Until Element Is Visible          xpath=//div[@class="input-group h-100"]/input          10
          [Teardown]          Close All Browsers

Case_用户进行登录
          Open Browser          ${CHUNMU_EU_URL}
          Maximize Browser Window
          ${personal_Center_Icon}          Run Keyword And Return Status          Wait Until Element Is Visible          xpath=//div[@id="UserInfo"]/a/span          10
          Run Keyword If          '${Personal_Center_Icon}'=='PASS'          AutoItLibrary.Mouse Down          xpath=//div[@id="UserInfo"]/a/span
          ...          ELSE          log          找不到个人中心的图标
          Click Element          xpath=//div[@id="UserInfo"]/a/span
          Wait Until Element Is Visible          xpath=//section[@class="container py-8"]/div/h2          10          #等待用户登录页面的标题可见
          Input Text          xpath=//input[@id="floatingInput"]          ${userLogin_Name}          #用户登录页面输入正确的用户邮箱
          Input Text          xpath=//input[@id="floatingPassword"]          ${userLogin_Password}          #用户登录页面输入正确的的密码
          Click Button          xpath=//form[@class="as-login-form mt-4"]/button
          Wait Until Element Is Visible          xpath=//li[2]/div[@id="UserInfo"]/a/span          10
          AutoItLibrary.Mouse Down          xpath=//li[2]/div[@id="UserInfo"]/a/span
          Mouse Over          xpath=//li[2]/div[@id="UserInfo"]/a/span
          Mouse Over          xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
          ${my_Account}=          Run Keyword And Return Status          Get Text          xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
          Run Keyword If          '${my_Account}'=="PASS"          Click Element          xpath=//div[@id="shopify-section-header"]/header//div[2]/a[2]/span
          ...          ELSE          log          获取个人中心的访问入口失败，无法进行至个人中心

Case_用户申请重置密码

*** Keywords ***
获取页面的元素
