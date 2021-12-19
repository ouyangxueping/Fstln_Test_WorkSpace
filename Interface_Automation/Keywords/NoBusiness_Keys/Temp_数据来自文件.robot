*** Settings ***
Documentation           *数据来自文件。 扩展用*
Library                 ../API_Lib/Create_Common_Arg.py
Library                 ReadAndWriteExcel
Library                 RequestsKeywords
Library                 DatabaseLibrary
Library                 SaveVariables
Library                 Collections
Resource                ../../Generic_Profiles.txt

*** Test Cases ***
Save_User_Info
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${count}          Query          select count(*) from azt_members
          ${userInfo}          Query          select ID,UserName,Nick,Email,CellPhone,QQ,Address,Photo from azt_members
          ${userInfo_dic}          Create Dictionary
          : FOR          ${i}          IN RANGE          ${count[0][0]}
          \          ${temp}          Create Dictionary
          \          Set To Dictionary          ${temp}          UserID=${userInfo[${i}][0]}          UserName=${userInfo[${i}][1]}          Nick=${userInfo[${i}][2]}          Email=${userInfo[${i}][3]}
          \          ...          CellPhone=${userInfo[${i}][4]}          QQ=${userInfo[${i}][5]}          Address=${userInfo[${i}][6]}          Photo=${userInfo[${i}][7]}
          \          Set To Dictionary          ${userInfo_dic}          Num${userInfo[${i}][0]}=${temp}          #字典的key为 Num + userid
          \          ${row_index}          Evaluate          ${i}+ int(2)
          \          Write Excel          Sheet1          ${row_index}          1          ${userInfo[${i}][0]}          #用户ID
          \          Write Excel          Sheet1          ${row_index}          2          ${userInfo[${i}][1]}          #用户名
          \          Write Excel          Sheet1          ${row_index}          3          ${userInfo[${i}][2]}          #昵称
          \          Write Excel          Sheet1          ${row_index}          4          ${userInfo[${i}][3]}          #邮箱
          \          Write Excel          Sheet1          ${row_index}          5          ${userInfo[${i}][4]}          #电话
          \          Write Excel          Sheet1          ${row_index}          6          ${userInfo[${i}][5]}          #QQ
          \          Write Excel          Sheet1          ${row_index}          7          ${userInfo[${i}][6]}          #地址
          \          Write Excel          Sheet1          ${row_index}          8          ${userInfo[${i}][7]}          #头像
          Set Global Variable          ${userInfo_dic}          #设置全局变量
          Save Var          userInfo_dic          ${userInfo_dic}
          Disconnect From Database

Get_Common_Arg_From_DataFile(买家)
          ${userInfo_dic}          Evaluate          eval("${userInfo_dic}")          #将字符串转换成表达式
          log          ${userInfo_dic}
          ${userInfo}          Get From Dictionary          ${userInfo_dic}          Num${userID}          #从userinfo字典中取出userid对应的其他值
          Set To Dictionary          ${userInfo}          ReviewUserId=${ReviewUserId}          #评论ID
          Set To Dictionary          ${userInfo}          Talent_ShowID=${talent_showID}          #达人秀ID
          Set To Dictionary          ${userInfo}          User_SigninID=${user_signinID}          #签到ID
          Set To Dictionary          ${userInfo}          Shipping_Address=${shipping_address}          #收货地址
          Set To Dictionary          ${userInfo}          DistributionID=${distributionID}          #用户分销商ID
          Set To Dictionary          ${userInfo}          OrderId=${OrderId}          #订单ID
          Set To Dictionary          ${userInfo}          OrderItemId=${OrderItemId}          #订单明细ID
          Set To Dictionary          ${userInfo}          OrderRetundId=${OrderRetundId}          #订单退款ID
          Create_Common_Arg          ${userInfo}          Common_Arg(User).json
