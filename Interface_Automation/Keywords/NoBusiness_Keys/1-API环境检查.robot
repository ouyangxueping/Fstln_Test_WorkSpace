*** Settings ***
Documentation           *说明：*
...
...                     *1、获取最新的接口列表信息，生成列表文件 （ Api_List_New.txt ）*
...
...                     *2、比较最新的接口列表信息 ( Api_List_New.txt ) 与原始的列表信息 （Api_List.txt ），如果有差异，则生成差异文件 ( Diff_Api_List.txt )，且同时备份原始列表信息和重新覆盖生成新的原始列表信息。*
Force Tags              CollectData
Library                 ../API_Lib/Create_Common_Arg.py
Library                 OperatingSystem
Library                 DatabaseLibrary
Library                 Collections
Resource                ../../Generic_Profiles.txt

*** Test Cases ***
API环境检查
          Get Api          new
          sleep          3
          ${result}          Get DiffApi
          Run Keyword If          ${result} == False          Copy File          ${EXECDIR}/接口自动化测试子系统/TestData/Api_List.txt          ${EXECDIR}/接口自动化测试子系统/TestData/Api_List.bak          #备份原始api列表
          Run Keyword If          ${result} == False          Get Api          #如果对比有差异，则重新生成原始API列表
          Run Keyword If          ${result} == False          Fail          两次相邻测试发现API发生改动，接口自动化测试主动中止！
