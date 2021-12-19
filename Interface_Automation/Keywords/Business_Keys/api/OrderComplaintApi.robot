*** Settings ***
Documentation           *投诉维权相关API*
Force Tags              API-Automated
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Library                 ../../API_Lib/Create_Common_Arg.py
Resource                L1_Components.txt
Resource                ../../../Generic_Profiles.txt
Resource                L2_Keywords_OrderComplaintApi.txt

*** Test Cases ***
添加投诉维权
          [Documentation]          *添加投诉维权，同一个订单可以重复投诉！*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${OrderItemId}          Get From Dictionary          ${json_user_content}          User_OrderItemId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${UserPhone}          Get Random Number String          9
          ${ComplaintReason}          Get Random Chinese String          20
          ${list}          Create List          2          #仲裁类型1.退货仲裁 2.投诉仲裁          #这里就直接取2
          ${Type}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          OrderItemId=${OrderItemId}          ShopId=${shopId}          OrderId=${OrderId}          UserPhone=${UserPhone}          ComplaintReason=${ComplaintReason}
          ...          Type=${Type}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_order}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${OrderId}
          ${have_not_shop}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${shopId}
          #验证参数为空
          Pass Execution If          ${have_not_user}          用户Id错误
          Pass Execution If          ${have_not_shop}          店铺Id错误
          Pass Execution If          ${have_not_order}          订单Id错误
          #数据库
          ${order_ok}          查询用户店铺订单是否有效          ${OrderId}          ${shopId}          ${UserID}
          ${have_ordercomplaint}          查询用户是否存在投诉维权记录          ${UserID}
          #请求
          #正确和错误返回格式都一致          Add_OrderComplaint.json
          ${data}=          Create Dictionary          OrderItemId=${OrderItemId}          ShopId=${ShopId}          OrderId=${OrderId}          UserPhone=${UserPhone}          ComplaintReason=${ComplaintReason}
          ...          UserId=${userId}
          ${data}          Convert To Json          ${data}          #字典转化成json字符串
          ${header}          Create Dictionary          Content-Type=application/json          #post头
          Create Session          Add_OrderComplaint          ${API_URL}          ${header}          #创建会话
          ${response}          Post Request          Add_OrderComplaint          api/ordercomplaint/add          data=${data}          #发送post请求，保存response json对象
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象字典
          ${Message}          Get From Dictionary          ${responsedata}          Message          #获取返回信息
          ${Success}          Get From Dictionary          ${responsedata}          Success          #获取接口返回状态
          Comment          Run Keyword If          "${OrderId}"!="" and "${CellPhone}"!="" and "${UserId}"!="" and "${Order_Shop_Id}"!="" \ \          Should Be True          ${Success}==True and "${Message}"=="操作成功"          #验证正确操作
          Comment          Run Keyword If          "${OrderId}"=="" and "${CellPhone}"!="" and "${UserId}"!="" and "${Order_Shop_Id}"!="" \          Should Be True          ${Success}==False and "${Message}"=="订单Id错误"          #验证订单ID不存在
          Comment          Run Keyword If          "${CellPhone}"=="" and "${OrderId}"!="" and "${UserId}"!="" and "${Order_Shop_Id}"!="" \          Should Be True          "${Message}"=="投诉电话不能为空" and ${Success}==False          #验证投诉电话不能为空
          Comment          Run Keyword If          "${UserId}"=="" and "${CellPhone}"!="" and "${OrderId}"!="" and "${Order_Shop_Id}"!="" \          Should Be True          ${Success}==False and "${Message}"=="用户Id错误"          #验证用户ID不存在
          Comment          Run Keyword If          "${Order_Shop_Id}"=="" and "${CellPhone}"!="" and "${UserId}"!="" and "${OrderId}"!="" \          Should Be True          ${Success}==False and "${Message}"=="店铺Id错误"          #验证订单的商店ID不存在
          Comment          Validate Json          Add_OrderComplaint.json          ${responsedata}          #验证返回值模板
          Comment          ${have_shopid}          查询订单用户是否存在投诉维权记录          ${userId}
          Delete All Sessions

结束投诉
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Id}          Get From Dictionary          ${json_user_content}          User_OrderComplaintsId          #投诉维权ID
          ${list}          Create List          2          #1.满意 2.取消          #这里就直接取2
          ${Status}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          UserId=${userId}          Id=${Id}          Status=${Status}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}          ${Id}          ${Status}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_user}          查询用户是否存在          ${UserID}
          ${have_user_complaint}          查询用户是否存在投诉维权记录          ${UserID}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          dealcomplaint_list          ${API_URL}          ${header}
          ${response}          Post Request          dealcomplaint_list          api/ordercomplaint/dealcomplaint          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          #请求
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          操作成功          投诉维权Id错误          该投诉不属于此用户！          投诉维权Id错误
          ${Success_list}          Create List          True          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}          ${have_user_complaint}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}          ${have_user_complaint}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}          ${have_user_complaint}
          Delete All Sessions

获取投诉维权列表
          [Documentation]          *获取投诉维权列表*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          519
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Id}          Set Variable          0
          ${OrderId}          Set Variable          0
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          10
          ${data}          Create Dictionary          UserId=${UserID}          Id=${Id}          OrderId=${OrderId}          PageNo=${PageNo}          PageSize=${PageSize}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${PageNo}          ${PageSize}
          #数据库
          ${have_ordercomplaint}          查询用户是否符合投诉维权条件          ${UserID}
          #数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Count}          Query          select COUNT(*) \ from azt_ordercomplaints where UserId=${UserID}
          ${Count}          Set Variable          ${Count[0][0]}
          Disconnect From Database
          #请求
          ${responsedata}          获取投诉维权列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          用户Id错误          用户Id错误          用户Id错误          用户Id错误          参数错误
          ...          获取成功          参数错误          暂无数据
          ${Success_list}          Create List          False          False          False          False          False
          ...          True          False          True
          ${Json_list}          Create List          OrderComplaint_List(None).json          OrderComplaint_List(None).json          OrderComplaint_List(None).json          OrderComplaint_List(None).json          Order_List(None).json
          ...          OrderComplaint_List.json          Order_List(None).json          Order_List(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Delete All Sessions

获取投诉维权记录
          [Documentation]          *获取投诉维权记录*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：这个接口中参数 OrderId \ 其实没什么意义*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Id}          Set Variable          ${EMPTY}
          ${OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          Comment          ${PageNo}          Get Range Number String          1          3
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          Id=${Id}          OrderId=${OrderId}          PageNo=${PageNo}          PageSize=${PageSize}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${PageNo}          ${PageSize}
          #数据库
          ${have_ordercomplaint}          查询用户是否存在投诉维权记录          ${UserID}          ${Id}
          #请求
          ${responsedata}          获取投诉维权记录          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          用户Id错误          用户Id错误          用户Id错误          用户Id错误          参数错误
          ...          获取成功          参数错误          暂无数据
          ${Success_list}          Create List          False          False          False          False          False
          ...          True          False          True
          ${Json_list}          Create List          OrderComplaint_List(None).json          OrderComplaint_List(None).json          OrderComplaint_List(None).json          OrderComplaint_List(None).json          Order_List(None).json
          ...          OrderComplaint_Record.json          Order_List(None).json          Order_List(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Delete All Sessions

退货仲裁
          [Documentation]          *退货仲裁 (App端当订单退款申请被拒绝后，点申请仲裁按钮时调用)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${OrderItemId}          Get From Dictionary          ${json_user_content}          User_OrderItemId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${User_OrderRetundId}          Get From Dictionary          ${json_user_content}          User_OrderRetundId          #退款退货Id
          ${OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${UserPhone}          Get Random Number String          9
          ${ComplaintReason}          Get Random Chinese String          20
          ${list}          Create List          1          #仲裁类型1.退货仲裁 2.投诉仲裁          #这里就直接取1
          ${Type}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          OrderItemId=${OrderItemId}          ShopId=${shopId}          OrderId=${OrderId}          UserPhone=${UserPhone}          ComplaintReason=${ComplaintReason}
          ...          Type=${Type}          OrderRetundId=${User_OrderRetundId}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_order}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${OrderId}
          ${have_not_shop}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${shopId}
          #验证参数为空
          Pass Execution If          ${have_not_user}          用户Id错误
          Pass Execution If          ${have_not_shop}          店铺Id错误
          Pass Execution If          ${have_not_order}          订单Id错误
          #数据库
          ${order_ok}          查询用户店铺订单是否有效          ${OrderId}          ${shopId}          ${UserID}
          ${have_ordercomplaint}          查询用户是否存在投诉维权记录          ${UserID}
          #请求
          ${responsedata}          退货仲裁          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          您已申请过投诉，不可重复申请！          操作成功          该订单不属于当前用户          该订单不属于当前用户
          ${Success_list}          Create List          False          True          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${order_ok}          ${have_ordercomplaint}
          Validate Output Results          ${Success}          ${Success_list}          ${order_ok}          ${have_ordercomplaint}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${order_ok}          ${have_ordercomplaint}
          Delete All Sessions
          #          投诉内容不能小于5个字符          投诉电话不能为空

投诉仲裁
          [Documentation]          *投诉仲裁*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Id}          Get From Dictionary          ${json_user_content}          User_OrderComplaintsId          #投诉维权ID
          ${list}          Create List          1          2          #状态 1.满意 2.取消
          ${Status}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          Id=${Id}          Status=${Status}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${Id}          ${Status}
          #数据库
          ${have_ordercomplaint}          查询用户是否存在投诉维权记录          ${UserID}          ${Id}
          #请求
          ${responsedata}          投诉仲裁          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          用户Id错误          用户Id错误          用户Id错误          用户Id错误          投诉维权Id错误
          ...          操作成功          投诉维权Id错误          该投诉不属于此用户！          #参数错误          #未将对象引用设置到对象的实例。
          ${Success_list}          Create List          False          False          False          False          False
          ...          True          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_user}          ${have_not_par}          ${have_ordercomplaint}
          Delete All Sessions

*** Keywords ***
