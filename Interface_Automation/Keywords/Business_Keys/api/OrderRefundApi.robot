*** Settings ***
Documentation           *退货退款相关API*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_OrderRefundApi.txt

*** Test Cases ***
获取退款列表
          [Documentation]          *获取退款列表*
          ...
          ...          *参数注意：(接口的英文字母拼写错了。坑了我好久。。。。退款是 refund 不是 tefund 啊)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          990
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Set Variable          1
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          PageNo=${PageNo}          PageSize=${PageSize}          UserId=${UserID}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${PageNo}
          ...          ${PageSize}
          #数据库
          ${have_refund}          查询用户是否存在退款记录          ${UserID}
          #请求
          ${responsedata}          获取退款列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          参数错误          参数错误          获取成功          暂无数据
          ${Success_list}          Create List          False          False          True          True
          ${Json_list}          Create List          OrderRefund_List.json          OrderRefund_List.json          OrderRefund_List.json          OrderRefund_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_refund}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_refund}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_refund}
          Delete All Sessions

获取退款详情
          [Documentation]          *获取退款详情（App端是点击订单时调用）*
          ...
          ...          *参数注意：(接口的判断逻辑顺序为：1、先判断用户传参，如果有再判断退款id传参 \ 2、如果有退款id传参，再判断用户是否存在退款记录)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${User_OrderRetundId}          Get From Dictionary          ${json_user_content}          User_OrderRetundId
          ${data}          Create Dictionary          Id=${User_OrderRetundId}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${User_OrderRetundId}
          #数据库
          ${have_refund}          查询用户是否存在退款记录          ${UserID}
          #请求
          ${responsedata}          获取退款详情          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          参数错误          参数错误          参数错误          参数错误          退款Id错误
          ...          获取成功          退款Id错误          暂无数据
          ${Success_list}          Create List          False          False          False          False          False
          ...          True          False          True
          ${Json_list}          Create List          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json
          ...          OrderRefund_Detail.json          Common_Temp(ValueNone).json          OrderRefund_Detail.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_user}          ${have_not_id}          ${have_refund}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_user}          ${have_not_id}          ${have_refund}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_user}          ${have_not_id}          ${have_refund}
          Delete All Sessions

提交退款申请
          [Documentation]          *提交退款申请（App端是点击“申请”按钮时调用）*
          ...
          ...          *参数注意：(接口的入参检查逻辑为：1、先检查用户ID是否存在，如果存在，则往下走 \ 2、如果存在用户id参数，则检查订单id，如果存在则往下走 \ 3、如果存在第2步，则检查用户详情id，如果存在则往下走 4、如果1 2 3 都验证ok，则检查用户是否存在该订单且订单存在该订单详情)*
          ...
          ...          *备注：参数userID单独处理，否则入参数检查过多*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${OrderItemId}          Get From Dictionary          ${json_user_content}          User_OrderItemId
          ${data}          Create Dictionary          OrderId=${OrderId}          OrderItemId=${OrderItemId}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_orderid}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${OrderId}
          ${have_not_orderItemid}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${OrderItemId}
          #验证各种ID为空
          Pass Execution If          ${have_not_orderid}          订单Id错误
          Pass Execution If          ${have_not_orderItemid}          订单明细Id错误
          #数据库
          ${Orders_ok}          查询订单是否有效          ${OrderId}
          ${have_refund}          查询用户是否存在退款记录          ${UserID}          ${OrderId}
          ${refund_is_ok}          查询用户是否可以退款申请          ${UserID}          ${OrderId}
          #请求
          ${responsedata}          提交退款申请          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #验证userID为空
          Run Keyword If          ${have_not_user}          Should Be True          "${Message}" == "参数错误"
          Run Keyword If          ${have_not_user}          Should Be True          ${Success} == False
          Run Keyword If          ${have_not_user}          Validate Json          Common_Temp(ValueNone).json          ${responsedata}
          Pass Execution If          ${have_not_user}          当用户ID参数为空时，验证成功！结束case，不往下执行！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          您已申请过售后，不可重复申请          获取成功          您已申请过售后，不可重复申请          获取成功          该订单已删除或不属于该用户
          ...          该订单已删除或不属于该用户          该订单已删除或不属于该用户          该订单已删除或不属于该用户
          ${Success_list}          Create List          False          True          False          True          False
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp(ValueNone).json          OrderRefund_Refundapply.json          Common_Temp(ValueNone).json          OrderRefund_Refundapply.json          Common_Temp(ValueNone).json
          ...          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${Orders_ok}          ${have_refund}          ${refund_is_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${Orders_ok}          ${have_refund}          ${refund_is_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${Orders_ok}          ${have_refund}          ${refund_is_ok}
          Delete All Sessions
          #          错误的订单退款申请,订单状态有误

提交退款信息
          [Documentation]          *提交退款信息（App端是点击“提交申请”按钮时调用）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          689
          Comment          ${OrderId}          Set Variable          2016111057020970
          Comment          ${OrderItemId}          Set Variable          54311
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${OrderId}          Get From Dictionary          ${json_user_content}          User_OrderId
          ${OrderItemId}          Get From Dictionary          ${json_user_content}          User_OrderItemId
          #只做退款
          ${list}          Create List          1
          ${RefundType}          Get Random Choice Number          ${list}          #退款方式 1.仅退款 2.退货退款
          ${Amount}          查询订单的实付金额          ${OrderId}          #退款金额
          ${ReturnQuantity}          查询订单的购买数量          ${OrderId}          #退款数量
          ${Reason}          Get Random Chinese String          20          #退款原因
          ${ContactPerson}          Get Random Chinese String          3          #联系人
          ${ContactCellPhone}          Get Random Number String          9          #联系电话
          ${RefundAccount}          Get Random Chinese String          5          #退款银行
          ${Payee}          Get Random Chinese String          3          #收款人
          ${PayeeAccount}          Get Random Number String          11          #收款人账户
          ${data}          Create Dictionary          OrderId=${OrderId}          OrderItemId=${OrderItemId}          RefundType=${RefundType}          Amount=${Amount}          ReturnQuantity=${ReturnQuantity}
          ...          Reason=${Reason}          ContactPerson=${ContactPerson}          ContactCellPhone=${ContactCellPhone}          RefundAccount=${RefundAccount}          Payee=${Payee}          PayeeAccount=${PayeeAccount}
          ...          UserId=${UserID}
          ${have_not_orderid}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${OrderId}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${OrderItemId}          ${UserID}
          ...          ${RefundType}          ${Amount}          ${ReturnQuantity}          ${Reason}          ${ContactPerson}          ${ContactCellPhone}
          ...          ${RefundAccount}          ${Payee}          ${PayeeAccount}
          #数据库
          ${Orders_ok}          查询订单是否有效          ${OrderId}
          ${Orders_status_ok}          查询订单状态是否正确          ${OrderId}          5
          ${refund_is_ok}          查询用户是否可以退款申请          ${UserID}          ${OrderId}
          #请求
          ${responsedata}          提交退款信息          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #验证userID为空
          Pass Execution If          ${have_not_par}          参数错误，验证到此为止！结束case，不往下执行！
          Pass Execution If          ${have_not_orderid}          订单Id错误，验证到此为止！结束case，不往下执行！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          错误的订单退款申请,订单状态有误          更新成功          错误的订单退款申请,订单状态有误          您已申请过售后，不可重复申请          该订单已删除或不属于该用户
          ...          该订单已删除或不属于该用户          该订单已删除或不属于该用户          该订单已删除或不属于该用户
          ${Success_list}          Create List          False          True          False          False          False
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp(ValueNone).json          OrderRefund_Add.json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json
          ...          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json          Common_Temp(ValueNone).json
          Validate Output Results          ${Message}          ${Message_list}          ${Orders_ok}          ${refund_is_ok}          ${Orders_status_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${Orders_ok}          ${refund_is_ok}          ${Orders_status_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${Orders_ok}          ${refund_is_ok}          ${Orders_status_ok}
          Delete All Sessions

确认寄货
          [Documentation]          *确认寄货*
          ...
          ...          *参数注意：(接口的入参检查逻辑为：1、先检查退款ID是否存在，如果存在，则往下走 \ 2、检查其他三个参数是否存在，如果存在则往下走 \ 3、如果存在第2步，则检查用户的退款id是否存在，如果存在则往下走 4、如果1 2 3 都验证ok，则检查退款订单的状态是否为待发货状态。)*
          ...
          ...          *备注：参数退款ID单独处理，否则入参数检查过多*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${User_OrderRetundId}          Get From Dictionary          ${json_user_content}          User_OrderRetundId          #退款退货Id
          ${ExpressCompanyName}          Get Random Chinese String          5          #快递公司
          ${ShipOrderNumber}          Get Random Number String          10          #快递单号
          ${data}          Create Dictionary          Id=${User_OrderRetundId}          ExpressCompanyName=${ExpressCompanyName}          ShipOrderNumber=${ShipOrderNumber}          UserId=${UserID}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${User_OrderRetundId}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${ExpressCompanyName}
          ...          ${ShipOrderNumber}
          #数据库
          ${OrderRetundId_ok}          查询用户的退款记录是否存在          ${UserID}          ${User_OrderRetundId}
          ${OrderRetundId_status_ok}          查询退款订单是否为待发货状态          ${User_OrderRetundId}
          #请求
          ${responsedata}          确认寄货          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #验证退款ID为空
          Run Keyword If          ${have_not_id}          Should Be True          "${Message}" == "退款Id错误"
          Run Keyword If          ${have_not_id}          Should Be True          ${Success} == False
          Run Keyword If          ${have_not_id}          Validate Json          Common_Temp.json          ${responsedata}
          Pass Execution If          ${have_not_id}          当退款ID参数为空时，验证成功！结束case，不往下执行！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          参数错误          参数错误          参数错误          参数错误          更新成功
          ...          只有待等待发货状态的能进行发货操作          未将对象引用设置到对象的实例。          只有待等待发货状态的能进行发货操作
          ${Success_list}          Create List          False          False          False          False          True
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${OrderRetundId_status_ok}          ${OrderRetundId_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${OrderRetundId_status_ok}          ${OrderRetundId_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${OrderRetundId_status_ok}          ${OrderRetundId_ok}
          Delete All Sessions
