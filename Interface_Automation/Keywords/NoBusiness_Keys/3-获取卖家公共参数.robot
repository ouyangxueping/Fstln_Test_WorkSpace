*** Settings ***
Documentation           *商家id-- \ \ \ \ \ \ \ \ \ \ \ \ ${managerID}*
...
...                     *店铺id-- \ \ \ \ \ \ \ \ \ \ \ \ ${ShopId}*
...
...                     *店铺名称-- \ \ \ \ \ \ \ \ \ ${ShopName}*
...
...                     *播放器id-- \ \ \ \ \ \ \ \ \ ${StoreId}*
...
...                     *播放器名称-- \ \ \ \ \ \ ${StoreName}*
...
...                     *视频id-- \ \ \ \ \ \ \ \ \ \ \ \ ${VideoId}*
...
...                     *视频名称-- \ \ \ \ \ \ \ \ \ ${VideoName}*
...
...                     *公司名称-- \ \ \ \ \ \ \ \ ${CompanyName}*
...
...                     *商品id-- \ \ \ \ \ \ \ \ \ \ \ \ ${ProductId}*
...
...                     *商品名称-- \ \ \ \ \ \ \ \ \ ${ProductName}*
...
...                     *播放器类型-- \ \ \ \ \ \ ${PlayerType}*
...
...                     *直播间名称-- \ \ \ \ \ \ \ ${LiveRoomName}*
...
...                     *直播id-- \ \ \ \ \ \ \ \ \ \ \ \ \ \ ${LiveID}*
...
...                     *视频分类id-- \ \ \ \ \ \ \ ${ParentId}*
...
...                     *订阅id-- \ \ \ \ \ \ \ \ \ \ \ \ \ ${SubscribeId}*
...
...                     *skuid-- \ \ \ \ \ \ \ \ \ \ \ \ \ ${SkuId}*
...
...                     *视频状态-- \ \ \ \ \ \ \ \ \ \ \ \ \${VideoType}*
...
...                     *播放器状态-- \ \ \ \ \ \ \ \ \ \ \ \ \${StoreTpye}*
...
...                     *商品状态-- \ \ \ \ \ \ \ \ \ \ \ \ \${ProductType}*
...
...                     *店铺状态-- \ \ \ \ \ \ \ \ \ \ \ \ \${ShopStatus}*
Force Tags              CollectData
Library                 ../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../Generic_Profiles.txt

*** Test Cases ***
Query_Manager_Info
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${java_userid}          Query          SELECT user_id FROM t_sysmgr_store_video          #java数据库的userid
          ${temp}          Get Random Choice Number          ${java_userid}
          ${java_userid}=          Set Variable If          ${java_userid}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${java_userid}          #设置全局变量

获取卖家相关ID
          #C#数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${managerID}          Query          SELECT ${Database_Name[0]}.azt_managers.id FROM ${Database_Name[0]}.azt_managers INNER JOIN ${Database_Name[1]}.t_sysmgr_user ON ${Database_Name[0]}.azt_managers.ID = ${Database_Name[1]}.t_sysmgr_user.`partner_account_id` and ${Database_Name[0]}.azt_managers.ShopId != "0"
          ${temp}          Get Random Choice Number          ${managerID}
          ${managerID}=          Set Variable If          ${managerID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${managerID}          #设置全局变量
          ${ShopId}          Query          select ShopId from azt_managers where id='${managerID}' \ and ShopId != "0"          #店铺id
          ${temp}          Get Random Choice Number          ${ShopId}
          ${ShopId}=          Set Variable If          ${ShopId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${ShopId}          #设置全局变量
          ${temp}          Query          select ShopName,ShopStatus from azt_shops where id='${ShopId}'          #店铺名称，店铺状态
          ${shopinfo}=          Get Random Choice Number          ${temp}
          ${ShopName}=          Set Variable If          ${temp}==[]          ${EMPTY}          ${ shopinfo[0]}
          ${ShopStatus}=          Set Variable If          ${temp}==[]          ${EMPTY}          ${ shopinfo[1]}
          Set Global Variable          ${ShopName}          #设置全局变量
          Set Global Variable          ${ShopStatus}          #设置全局变量
          ${CompanyName}          Query          select ShopName from azt_shops where id='${ShopId}'          #公司名称
          ${temp}          Get Random Choice Number          ${CompanyName}
          ${CompanyName}=          Set Variable If          ${CompanyName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${CompanyName}          #设置全局变量
          ${ShopNotice_Id}          Query          select id from azt_notices          #店铺公告ID
          ${temp}          Get Random Choice Number          ${ShopNotice_Id}
          ${ShopNotice_Id}=          Set Variable If          ${ShopNotice_Id}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${ShopNotice_Id}          #设置全局变量
          ${LiveID}          Query          SELECT id \ FROM \ azt_liverooms          #直播id，随机取1个
          ${temp}          Get Random Choice Number          ${LiveID}          1
          ${LiveID}=          Set Variable If          ${LiveID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${LiveID}          #设置全局变量
          ${LiveRoomName}          Query          SELECT LiveRoomTitle FROM azt_liverooms WHERE id='${LiveID}'          #直播id对应的直播标题名
          ${temp}          Get Random Choice Number          ${LiveRoomName}          1
          ${LiveRoomName}=          Set Variable If          ${LiveRoomName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${LiveRoomName}          #设置全局变量
          ${SubscribeId}          Query          SELECT id \ FROM \ azt_liverooms_subscribe WHERE LiveRoomId='${LiveID}'          #直播id对应的订阅id
          ${temp}          Get Random Choice Number          ${SubscribeId}
          ${SubscribeId}=          Set Variable If          ${SubscribeId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${SubscribeId}          #设置全局变量
          ${Manager_LiveID}          Query          SELECT id FROM azt_liverooms WHERE shopid='${ShopId}'          #商家的直播id
          ${temp}          Get Random Choice Number          ${Manager_LiveID}
          ${Manager_LiveID}=          Set Variable If          ${Manager_LiveID}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${Manager_LiveID}          #设置全局变量
          ${Manager_LiveRoomName}          Query          SELECT LiveRoomTitle FROM azt_liverooms WHERE id='${Manager_LiveID}'          #商家的直播间名称
          ${temp}          Get Random Choice Number          ${Manager_LiveRoomName}
          ${Manager_LiveRoomName}=          Set Variable If          ${Manager_LiveRoomName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${Manager_LiveRoomName}          #设置全局变量
          ${Tag_id}          Query          SELECT id FROM `t_sysmgr_tags`          #标签id
          ${Tag_id}          Get Random Choice Number          ${Tag_id}
          ${Tag_id}          Set Variable          ${Tag_id[0]}
          Set Global Variable          ${Tag_id}
          ${Tag_name}          Query          SELECT name FROM `t_sysmgr_tags` where id=${Tag_id}          #标签name
          ${Tag_name}          Set Variable          ${Tag_name[0][0]}
          Set Global Variable          ${Tag_name}
          Disconnect From Database
          #java数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[1]};User=${Database_User};Password=${Database_Passwd};"
          ${StoreId}          Query          SELECT store_id FROM t_sysmgr_store_video WHERE user_id='${java_userid}'          #播放器id
          ${temp}          Get Random Choice Number          ${StoreId}
          ${StoreId}=          Set Variable If          ${StoreId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${StoreId}          #设置全局变量
          ${StoreName}          Query          SELECT NAME FROM \ t_sysmgr_store WHERE id='${StoreId}'          #播放器名称
          ${temp}          Get Random Choice Number          ${StoreName}
          ${StoreName}=          Set Variable If          ${StoreName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${StoreName}          #设置全局变量
          ${PlayerType}          Query          SELECT player_type FROM t_sysmgr_store WHERE id='${StoreId}'          #播放器类型
          ${temp}          Get Random Choice Number          ${PlayerType}
          ${PlayerType}=          Set Variable If          ${PlayerType}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${PlayerType}          #设置全局变量
          ${VideoId}          Query          select video_id FROM \ t_sysmgr_store_video WHERE store_id='${StoreId}'          #视频id
          ${temp}          Get Random Choice Number          ${VideoId}
          ${VideoId}=          Set Variable If          ${VideoId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${VideoId}          #设置全局变量
          ${VideoType}          Query          SELECT check_state FROM t_sysmgr_video WHERE id='${VideoId}'          #视频状态
          ${temp}          Get Random Choice Number          ${VideoType}
          ${VideoType}=          Set Variable If          ${VideoType}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${VideoType}          #设置全局变量
          ${VideoName}          Query          SELECT title FROM t_sysmgr_video WHERE id='${VideoId}'          #视频名称
          ${temp}          Get Random Choice Number          ${VideoName}
          ${VideoName}=          Set Variable If          ${VideoName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${VideoName}          #设置全局变量
          ${ProductId}          Query          SELECT product_id FROM t_sysmgr_store_product WHERE store_id='${StoreId}'          #商品id
          ${temp}          Get Random Choice Number          ${ProductId}
          ${ProductId}=          Set Variable If          ${ProductId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${ProductId}          #设置全局变量
          ${ProductName}          Query          SELECT product_name FROM t_sysmgr_store_product WHERE \ product_id='${ProductId}' AND store_id='${StoreId}'          #商品名称
          ${temp}          Get Random Choice Number          ${ProductName}
          ${ProductName}=          Set Variable If          ${ProductName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${ProductName}          #设置全局变量
          ${TagsId}          Query          select id from t_sysmgr_tags          #标签id,，随机取
          ${temp}          Get Random Choice Number          ${TagsId}
          ${TagsId}=          Set Variable If          ${TagsId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${TagsId}          #设置全局变量
          ${TagsName}          Query          select name from t_sysmgr_tags where id="${TagsId}"          #标签id对应的标签名
          ${temp}          Get Random Choice Number          ${TagsName}
          ${TagsName}=          Set Variable If          ${TagsName}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${TagsName}          #设置全局变量
          ${Video_CategoryId}          Query          SELECT id FROM t_sysmgr_categories          #视频分类id,，随机取
          ${temp}          Get Random Choice Number          ${Video_CategoryId}
          ${Video_CategoryId}=          Set Variable If          ${Video_CategoryId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${Video_CategoryId}          #设置全局变量
          Disconnect From Database
          #C#数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${SkuId}          Query          SELECT id FROM azt_skus WHERE productid='${ProductId}'          #Skuid
          ${temp}          Get Random Choice Number          ${SkuId}
          ${SkuId}=          Set Variable If          ${SkuId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${SkuId}          #设置全局变量
          ${ProductType}          Query          SELECT EditStatus FROM azt_products WHERE id='${ProductId}'          #商品状态
          ${temp}          Get Random Choice Number          ${ProductType}
          ${ProductType}=          Set Variable If          ${ProductType}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${ProductType}          #设置全局变量
          ${PromotionId}          Query          select id from azt_shoppromotion          #活动id，随机取3个
          ${temp}          Get Random Choice Number          ${PromotionId}          3
          ${PromotionId}=          Set Variable If          ${PromotionId}==[]          ${EMPTY}          ${temp}
          Set Global Variable          ${PromotionId}          #设置全局变量
          ${Product_CategoryId}          Query          select id from azt_categories          #商品分类id，随机取
          ${temp}          Get Random Choice Number          ${Product_CategoryId}
          ${Product_CategoryId}=          Set Variable If          ${Product_CategoryId}==[]          ${EMPTY}          ${temp[0]}
          Set Global Variable          ${Product_CategoryId}          #设置全局变量
          ${SourceType}          Set Variable          4          #播放器来源,4为达人推荐
          Set Global Variable          ${SourceType}          #设置全局变量
          ${SourceId}          Query          select B.id from azt_praisedreview A,azt_talent_show B where A.SourceId=B.Id AND A.SourceType="${SourceType}"
          ${temp}          Get Random Choice Number          ${SourceId}
          ${SourceId}          Set Variable If          ${SourceId}==[]          ${EMPTY}          ${temp[0]}          #可能参数为null的情况
          Set Global Variable          ${SourceId}          #来源id
          ${SourceName}          Query          select B.Title from azt_praisedreview A,azt_talent_show B where A.SourceName=B.Title AND A.SourceType="${SourceType}" \
          ${temp}          Get Random Choice Number          ${SourceName}
          ${SourceName}          Set Variable If          ${SourceName}==[]          ${EMPTY}          ${temp[0]}          #可能参数为null的情况
          Set Global Variable          ${SourceName}          #来源名称
          Disconnect From Database

Get_Common_Arg(卖家)
          [Documentation]          *从json文件中取出参数文件的步骤：*          #先将读取出来的字符串转成字典*          #获取最终的参数值*
          ...
          ...          *|${json_content} | Read Joson Content | Common_Arg(Manager).json | *
          ...
          ...          *| ${json_content} | To Json | ${json_content} | *
          ...
          ...          *| ${managerID} | Get From Dictionary | ${json_content} | managerID |*
          ${managerInfo_dic}          Create Dictionary
          #往字典里新增数据
          Set To Dictionary          ${managerInfo_dic}          ManagerID=${managerID}          #商家id
          Set To Dictionary          ${managerInfo_dic}          ShopId=${ShopId}          #店铺id
          Set To Dictionary          ${managerInfo_dic}          ShopName=${ShopName}          #店铺名称
          Set To Dictionary          ${managerInfo_dic}          StoreId=${StoreId}          #播放器id
          Set To Dictionary          ${managerInfo_dic}          StoreName=${StoreName}          #播放器名称
          Set To Dictionary          ${managerInfo_dic}          VideoId=${VideoId}          #视频id
          Set To Dictionary          ${managerInfo_dic}          VideoName=${VideoName}          #视频名称
          Set To Dictionary          ${managerInfo_dic}          TagsId=${TagsId}          #标签ID
          Set To Dictionary          ${managerInfo_dic}          TagsName=${TagsName}          #标签ID对应的标签名称
          Set To Dictionary          ${managerInfo_dic}          CompanyName=${CompanyName}          #公司名称
          Set To Dictionary          ${managerInfo_dic}          ShopNotice_Id=${ShopNotice_Id}          #店铺公告
          Set To Dictionary          ${managerInfo_dic}          PromotionId=${PromotionId}          #活动id，随机取5个
          Set To Dictionary          ${managerInfo_dic}          ProductId=${ProductId}          #商品id
          Set To Dictionary          ${managerInfo_dic}          ProductName=${ProductName}          #商品名称
          Set To Dictionary          ${managerInfo_dic}          Product_CategoryId=${Product_CategoryId}          #商品分类ID，随机获取
          Set To Dictionary          ${managerInfo_dic}          SkuId=${SkuId}          #商品SKU
          Set To Dictionary          ${managerInfo_dic}          PlayerType=${PlayerType}          #播放器类型
          Set To Dictionary          ${managerInfo_dic}          Manager_LiveID=${Manager_LiveID}          #商家的直播id
          Set To Dictionary          ${managerInfo_dic}          Manager_LiveRoomName=${Manager_LiveRoomName}          #商家的直播id对应的直播间名称
          Set To Dictionary          ${managerInfo_dic}          LiveID=${LiveID}          #直播id，随机取的1个
          Set To Dictionary          ${managerInfo_dic}          LiveRoomName=${LiveRoomName}          #直播id对应的直播名
          Set To Dictionary          ${managerInfo_dic}          SubscribeId=${SubscribeId}          #直播id对应的订阅id
          Set To Dictionary          ${managerInfo_dic}          Video_CategoryId=${Video_CategoryId}          #视频分类id
          Set To Dictionary          ${managerInfo_dic}          SourceType=${SourceType}          #播放器来源类型
          Set To Dictionary          ${managerInfo_dic}          SourceId=${SourceId}          #来源id
          Set To Dictionary          ${managerInfo_dic}          SourceName=${SourceName}          #来源名称
          Set To Dictionary          ${managerInfo_dic}          Tag_id=${Tag_id}          #标签id
          Set To Dictionary          ${managerInfo_dic}          Tag_name=${Tag_name}          #标签name
          #保存至公共变量文件
          Create_Common_Arg          ${managerInfo_dic}          Common_Arg(Manager).json

*** Keywords ***
