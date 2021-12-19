*** Settings ***
Documentation           *消息推送相关API*
...
...                     *过滤标记：’生成推送消息数据‘*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_PushMessageApi.txt

*** Test Cases ***
生成推送消息数据
          [Documentation]          *生成推送消息数据（似乎还有问题，这个接口跳过）*
          ...
          ...          *参数注意：(接口描述貌似有问题，这个接口还可以更新用户的登录状态？)*
          ...
          ...          *备注：参数中只提供用户id和类型，怎么生成消息数据？*
          ...
          ...          *tag暂时标注为 filter*
          [Tags]          filter
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          1          2          3          #则1表示买家，2表示卖家,3表示分销商
          ${Status}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          Id=${userId}          Status=${Status}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          生成推送消息数据          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          修改状态失败          None
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_user}
          Delete All Sessions

更新用户APP登录状态
          [Documentation]          *更新用户APP登录状态*
          ...
          ...          *参数注意：(1、接口描述与实际不符，status入参实际上是一个非1既假的定义（本身默认值为1）,凡是status不等1的值均视为退出状态。2、实际上这里的入参直接取成整型似乎更方便验证）*
          ...
          ...          *备注：接口定义了很多种返回消息，脚本中只考虑了，参数为空、参数不合法、参数正常这三种状况*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          0          1
          ${Status}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          Id=${userId}          Status=${Status}
          ${have_not_par}          Validate Input Parameters          V          ${userId}          ${EMPTY}          #判断输入参数是否有空值
          ${par_ok}          Validate Input Parameters          S          ${userId}          Int32
          #数据库
          ${have_user}          查询用户是否存在          ${userId}
          #请求
          ${responsedata}          更新用户APP登录状态          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          修改状态失败,入参为null          修改状态失败,入参为null          修改状态失败,入参为null          修改状态失败,入参为null          修改成功
          ...          修改状态失败,Error:值对于 Int32 太大或太小。          修改状态失败,Error:未将对象引用设置到对象的实例。          修改状态失败,Error:值对于 Int32 太大或太小。
          ${Success_list}          Create List          False          False          False          False          True
          ...          False          False          False
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${par_ok}          ${have_user}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${par_ok}          ${have_user}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${par_ok}          ${have_user}
          Delete All Sessions

修改系统通知状态为已读
          [Documentation]          *修改系统通知状态为已读*
          ...
          ...          *参数注意：(这个接口与SystemNotifApi实现类似的功能，这个采用POST方法，且校验的参数多了类型的验证）*
          ...
          ...          *参数注意：(不清楚参数ids 代表的意思，脚本中直接取空了)*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${IdList}          Get From Dictionary          ${json_user_content}          SystemNotice_Ids          #取到的是个列表
          ${Ids}          Set Variable          ${EMPTY}
          ${data}          Create Dictionary          IdList=${IdList}          Ids=${Ids}          sign=${Sign}
          ${have_not_par}          Validate Input Parameters          V          ${IdList}          ${EMPTY}          #判断输入参数是否有空值
          #数据库
          #请求
          ${responsedata}          修改系统通知状态为已读          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          修改状态失败          None
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Common_Temp(None).json          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

更新即时推送消息人数
          [Documentation]          *更新即时推送的推送送达人数和打开人数*
          ...
          ...          *参数注意：(接口参数做了数据类型的校验，验证起来有些繁琐。注意看参数的获取）*
          ...
          ...          *备注：最后一个参数暂时并未做验证*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${InstantPushId}          Get From Dictionary          ${json_user_content}          InstantPushId
          ${list1}          Create List          ${InstantPushId}          0          ${EMPTY}
          ${InstantPushId}          Get Random Choice Number          ${list1}          #${InstantPushId}取0和空值表示不执行更新，取id表示执行更新
          ${MemberId}          Get From Dictionary          ${json_user_content}          UserID
          ${list2}          Create List          ${MemberId}          0          ${EMPTY}
          ${MemberId}          Get Random Choice Number          ${list2}          #${MemberId}取0和空值表示更新送达人数 取id表示更新打开人数
          ${list3}          Create List          true          false          ${EMPTY}
          ${WriteOpenHistory}          Get Random Choice Number          ${list3}          #${WriteOpenHistory}取false和空值表示不写入历史记录
          ${data}          Create Dictionary          InstantPushId=${InstantPushId}          MemberId=${MemberId}          WriteOpenHistory=${WriteOpenHistory}
          ${InstantPushId_ok}          Validate Input Parameters          V          ${InstantPushId}          ${EMPTY}          0
          ${MemberId_ok}          Validate Input Parameters          V          ${MemberId}          ${EMPTY}          0
          #数据库
          #请求
          ${responsedata}          更新即时推送消息人数          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          非即时推送.不执行任何操作.          非即时推送.不执行任何操作.          ${EMPTY}          ${EMPTY}
          ${Success_list}          Create List          True          True          True          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${InstantPushId_ok}          ${MemberId_ok}
          Validate Output Results          ${Success}          ${Success_list}          ${InstantPushId_ok}          ${MemberId_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${InstantPushId_ok}          ${MemberId_ok}
          Delete All Sessions
