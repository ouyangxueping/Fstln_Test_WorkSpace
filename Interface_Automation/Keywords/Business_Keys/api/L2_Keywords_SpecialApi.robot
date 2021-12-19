*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询专题详情是否存在
          [Arguments]          ${SpecialId}
          [Documentation]          *查询专题详情是否存在*
          ...
          ...          *参数：SpecialId*
          ...
          ...          *返回： True 或 False*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_specialthemebaseconfig INNER JOIN azt_specialthemecontrolsconfig ON azt_specialthemebaseconfig.Id=azt_specialthemecontrolsconfig.SpecialThemeBaseId where azt_specialthemebaseconfig.Id="${SpecialId}"          0          #大于0个
          Disconnect From Database
          [Return]          ${status}
