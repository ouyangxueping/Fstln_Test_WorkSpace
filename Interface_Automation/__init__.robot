*** Settings ***
Suite Setup             Run Keywords          Set ExcelPath          ${CURDIR}\\TestData\\API_Test_ExcelData.xlsx
...                     AND          Set VarPath          ${CURDIR}\\Vars.yaml
...                     AND          Set Jsonschema Path          ${CURDIR}\\Resource\\Json_template
...                     AND          Set SQL Path          ${CURDIR}\\Resource\\Sql
Library                 ReadAndWriteExcel
Library                 SaveVariables
Library                 RequestsKeywords
Library                 DatabaseLibrary
