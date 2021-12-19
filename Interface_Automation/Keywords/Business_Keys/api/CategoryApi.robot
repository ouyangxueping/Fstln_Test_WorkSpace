*** Settings ***
Documentation           *商品分类相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_CategoryApi.txt

*** Test Cases ***
获得商品一级分类
          [Documentation]          *商品加入购物车*
          ...
          ...          *参数注意：有几种状态需要考虑：1、活动商品 \ 2、非活动商品*
          #数据库
          #请求
          ${responsedata}          获得商品一级分类          ${API_URL}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Get_Category_ProductList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获得商品分类详情
          [Documentation]          *商品加入购物车*
          ...
          ...          *参数注意：有几种状态需要考虑：1、活动商品 \ 2、非活动商品*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${categoryId}          Get From Dictionary          ${json_manager_content}          Product_CategoryId
          #数据库
          ${is_categoryId}          查询商品分类是否存在          ${categoryId}
          #请求
          ${responsedata}          获得商品分类详情          ${API_URL}          ${categoryId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证参数不正确的情况
          Run Keyword If          not ${is_categoryId}          Should Be True          ${Success} == False
          Run Keyword If          not ${is_categoryId}          Validate Json          ParameterError_Temp(Value).json          ${responsedata}
          Pass Execution If          not ${is_categoryId}          当参数不正确时，其实就是异常了！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          None          ${EMPTY}
          ${Success_list}          Create List          True          ${EMPTY}
          ${Json_list}          Create List          Get_Category_ProductDetail.json          ${EMPTY}
          Validate Output Results          ${Message}          ${Message_list}          ${is_categoryId}
          Validate Output Results          ${Success}          ${Success_list}          ${is_categoryId}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${is_categoryId}
          Delete All Sessions

获得视频一级分类
          [Documentation]          *XXXX*
          ...
          ...          *参数注意：(XXX)*
          #创建参数字典
          ${data}          Create Dictionary          sign=${Sign}
          #数据库
          #请求
          ${responsedata}          获得视频一级分类          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Get_Category_VideoList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获得视频分类详情
          [Documentation]          *XXXX*
          ...
          ...          *参数注意：(XXX)*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${categoryId}          Get From Dictionary          ${json_manager_content}          Video_CategoryId
          ${data}          Create Dictionary          categoryId=${categoryId}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          #数据库
          #请求
          ${responsedata}          获得视频分类详情          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          输入字符串的格式不正确。          ${EMPTY}
          ${Success_list}          Create List          True          True
          ${Json_list}          Create List          Get_Category_VideoDetail.json          Get_Category_VideoDetail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions
