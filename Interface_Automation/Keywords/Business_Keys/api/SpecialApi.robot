*** Settings ***
Documentation           *专题相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_SpecialApi.txt

*** Test Cases ***
获取专题列表
          [Documentation]          *获取专题列表*
          ...
          ...          *参数注意：*
          #创建参数字典
          ${PageNo}          Get Range Number String          1          9
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          PageNo=${PageNo}          PageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #POST请求
          ${responsedata}          获取专题列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          获取成功
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_Special_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取专题详情
          [Documentation]          *获取专题详情*
          ...
          ...          *(接口存在问题，当专题不使用模板时，调用接口会返回错误)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${SpecialId}          Get From Dictionary          ${json_user_content}          SpecialId
          ${data}          Create Dictionary          Id=${SpecialId}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${SpecialId}          #判断参数是否为空
          ${have_not_par}          Evaluate          not ${have_not_par}          #取反
          ${V_SpecialId}          Validate Input Parameters          S          ${SpecialId}          Int32          #判断参数的数据类型是否正确
          ${V_SpecialId_ok}          Validate Input Parameters          P
          ...          AND          True          ${have_not_par}          ${V_SpecialId}          #这两个参数都正常时，输入参数才算正常
          #数据库
          ${hava_SpecialId}          查询专题详情是否存在          ${SpecialId}
          #POST请求
          ${responsedata}          获取专题详情          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          获取成功          此专题没有详情          专题Id错误          专题Id错误          #
          ...          # 参数错误
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Get_Special_Detail2.json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json          ParameterError_Temp(Value).json
          Validate Output Results          ${Message}          ${Message_list}          ${V_SpecialId_ok}          ${hava_SpecialId}
          Validate Output Results          ${Success}          ${Success_list}          ${V_SpecialId_ok}          ${hava_SpecialId}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${V_SpecialId_ok}          ${hava_SpecialId}
          Delete All Sessions
