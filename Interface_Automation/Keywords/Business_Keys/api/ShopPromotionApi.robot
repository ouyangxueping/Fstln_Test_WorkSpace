*** Settings ***
Documentation           *商家活动相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_ShopPromotionApi.txt

*** Test Cases ***
获取店铺的活动列表
          [Documentation]          *获取店铺的活动列表*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${shopId}          Set Variable          1
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${shopId}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          获取店铺的活动列表          ${API_URL}          ${shopId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          None
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Get_ShopPromotion_List.json          Get_ShopPromotion_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions
          Comment          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"

获取活动详细信息
          [Documentation]          *获取活动详细信息*
          ...
          ...          *参数注意：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${PromotionId}          Set Variable          355
          ${PromotionId}          Get From Dictionary          ${json_manager_content}          PromotionId          #返回的是个列表
          ${PromotionId_len}          Get Length          ${PromotionId}
          ${PromotionId}          Set Variable If          ${PromotionId_len} == 0          ${EMPTY}          ${PromotionId[0]}          #默认就取第一个
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${PromotionId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #GET请求
          ${responsedata}          获取活动详细信息          ${API_URL}          ${PromotionId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Get_ShopPromotion_Detail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

批量删除活动
          [Documentation]          *批量删除活动*
          ...
          ...          *参数注意：不明白 Ids 参数的意义,脚本中直接取空来处理的*
          ...
          ...          *备注：IdList参数可以取空*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${IdList}          Get From Dictionary          ${json_manager_content}          PromotionId
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          #数据库
          #post请求
          ${responsedata}          批量删除活动          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions
