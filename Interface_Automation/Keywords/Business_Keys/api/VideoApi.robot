*** Settings ***
Documentation           *视频相关接口API*
...
...                     *过滤标记：‘api/video/scan’*
Force Tags              API-Automated
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                ../../../Generic_Profiles.txt
Resource                L1_Components.txt
Resource                L2_Keywords_VideoApi.txt

*** Test Cases ***
统计播放次数
          [Documentation]          *统计播放次数*
          ...
          ...          *参数注意：(该接口实际上是生成视频播放记录，并存于 azt_videoreport表，同时返回存储后的id)*
          ...
          ...          *备注：接口描述中的id参数，不明白是什么意义，似乎没有作用*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${VideoTotalSeconds}          Get Range Number String          10          60
          ${SharePlatform}          Set Variable          0
          ${PlaySeconds}          Get Range Number String          10          50
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${list}          Create List          H5          PC
          ${ClientType}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          storeId=${storeId}          storeName=${storeName}          shopId=${shopId}          shopName=${shopName}          videoId=${VideoId}
          ...          videoName=${videoName}          VideoTotalSeconds=${VideoTotalSeconds}          SharePlatform=${SharePlatform}          PlaySeconds=${PlaySeconds}          SourceType=${SourceType}          SourceId=${SourceId}
          ...          ClientType=${ClientType}
          #数据库
          #请求
          ${responsedata}          统计播放次数          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Id}          Get From Dictionary          ${responsedata}          Id
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Report_VideoPlay.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions
          #查询数据库记录，存在则删除
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${praisedid}          Query          SELECT id FROM azt_videoreport \ WHERE id='${Id}'
          Run Keyword If          '${praisedid}'!='[]'          Execute Sql String          DELETE FROM azt_videoreport \ WHERE \ id='${praisedid[0][0]}'
          ...          ELSE          fail          未加入数据库，case失败！
          Disconnect From Database

统计播放时长
          [Documentation]          *统计播放时长*
          ...
          ...          *参数注意：(该接口同上个接口类似。但好像没实现)*
          ...
          ...          *备注：接口描述中的id参数，不明白是什么意义，似乎没有作用 \ （待定）*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${VideoTotalSeconds}          Get Range Number String          10          60
          ${SharePlatform}          Set Variable          0
          ${PlaySeconds}          Get Range Number String          10          50
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${list}          Create List          H5          PC
          ${ClientType}          Get Random Choice Number          ${list}
          ${data}          Create Dictionary          storeId=${storeId}          storeName=${storeName}          shopId=${shopId}          shopName=${shopName}          videoId=${VideoId}
          ...          videoName=${videoName}          VideoTotalSeconds=${VideoTotalSeconds}          SharePlatform=${SharePlatform}          PlaySeconds=${PlaySeconds}          SourceType=${SourceType}          SourceId=${SourceId}
          ...          ClientType=${ClientType}
          #数据库
          #请求
          ${responsedata}          统计播放时长          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

搜索视频
          [Documentation]          *搜索视频*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${keywords}          Set Variable          测试
          ${list}          Create List          1_1          1_2          2_1          2_2          3_1
          ...          3_2
          ${orderType}          Get Random Choice Number          ${list}          #排序 1_1代表人气升序，1_2人气降序 2_1价格升序，2_2价格降序 3_1发布时间升序，3_2发布时间降序
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          userId=${UserID}          keywords=${keywords}          pageNo=${PageNo}          orderType=${orderType}          pageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${orderType}          ${PageNo}
          ...          ${PageSize}
          #数据库
          #请求
          ${responsedata}          搜索视频          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          Video_GetSearchVideo.json          Video_GetSearchVideo.json
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取视频二级分类列表(GET)
          [Documentation]          *获取视频二级分类列表(GET)*
          ...
          ...          *参数注意：(XXX)*
          ...
          ...          *备注：模板返回结果校验中去掉了 titleImage的校验*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${parentId}          Get From Dictionary          ${json_manager_content}          Video_CategoryId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${parentId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库查询出相应的分类id
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${id}          Query          SELECT id FROM t_sysmgr_categories WHERE parent_id='${parentId}'
          ${count}          Query          SELECT count(*) FROM t_sysmgr_categories WHERE parent_id='${parentId}'
          Disconnect From Database
          #请求
          ${responsedata}          获取视频二级分类列表(GET)          ${API_URL}          ${parentId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #数据库中分类id与接口返回的分类id进行一一对比
          : FOR          ${i}          IN RANGE          ${count[0][0]}
          \          ${AID}          Get From Dictionary          ${Data[${i}]}          id
          \          Run Keyword If          ${AID}==${id[${i}][0]}          log          与数据库查询结果一致！！
          \          ...          ELSE          fail          与数据库查询的结果不一致！！
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_CategoryList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频二级分类列表(POST)
          [Documentation]          *获取视频二级分类列表(POST)*
          ...
          ...          *参数注意：(XXX)*
          ...
          ...          *备注：模板返回结果校验中去掉了 titleImage的校验*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          ${parentId}          Get From Dictionary          ${json_manager_content}          Video_CategoryId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${parentId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库查询出相应的分类id
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${id}          Query          SELECT id FROM t_sysmgr_categories WHERE parent_id='${parentId}'          #数据库分类id
          ${count}          Query          SELECT count(*) FROM t_sysmgr_categories WHERE parent_id='${parentId}'          #数据库分类个数
          Disconnect From Database
          #请求
          ${responsedata}          获取视频二级分类列表(POST)          ${API_URL}          ${parentId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #数据库中分类id与接口返回的分类id进行一一对比
          : FOR          ${i}          IN RANGE          ${count[0][0]}
          \          ${AID}          Get From Dictionary          ${Data[${i}]}          id          #接口返回的分类id
          \          Run Keyword If          ${AID}==${id[${i}][0]}          log          与数据库查询结果一致！！
          \          ...          ELSE          fail          与数据库查询的结果不一致！！          #接口返回的分类id与数据库中一一对比
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_CategoryList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频分类列表(GET)
          [Documentation]          *获取视频分类列表(POST)*
          ...
          ...          *参数注意：(与上面不同之处在于，修改为一级和二级按层次返回*
          ...
          ...          *备注：模板返回结果校验中去掉了 titleImage的校验*
          #创建参数字典
          #验证参数为空
          #数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${id}          Query          SELECT id FROM t_sysmgr_categories          #一级分类id
          ${count}          Query          SELECT count(*) FROM t_sysmgr_categories WHERE parent_id=0          #一级分类个数
          Disconnect From Database
          #请求
          ${responsedata}          获取视频分类列表(POST)          ${API_URL}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #数据库中分类id与接口返回的分类id进行一一对比
          : FOR          ${i}          IN RANGE          ${count[0][0]}
          \          ${AID}          Get From Dictionary          ${Data[${i}]}          id          #接口返回一级分类id
          \          ${subList}          Get From Dictionary          ${Data[${i}]}          subList          #接口返回的二级分类列表
          \          Run Keyword If          ${AID}==${id[${i}][0]}          log          与数据库查询结果一致！！
          \          ...          ELSE          fail          与数据库查询的结果不一致！！
          \          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          \          ${zidList}          Query          SELECT id FROM t_sysmgr_categories WHERE parent_id='${AID}' and display=1          #数据库中一级分类id对应的二级分类id
          \          ${count1}          Query          SELECT count(*) FROM t_sysmgr_categories WHERE parent_id='${AID}' and display=1          #数据库中一级分类下的二级分类个数
          \          Disconnect From Database
          \          接口返回的二级分类与数据库做比对          ${count1[0][0]}          ${zidList}          ${subList}
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_CategoryListAll.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频分类列表(POST)
          [Documentation]          *获取视频分类列表(GET)*
          ...
          ...          *参数注意：(与上面不同之处在于，修改为一级和二级按层次返回*
          ...
          ...          *备注：模板返回结果校验中去掉了 titleImage的校验*
          #创建参数字典
          #验证参数为空
          #数据库
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${id}          Query          SELECT id FROM t_sysmgr_categories          #一级分类id
          ${count}          Query          SELECT count(*) FROM t_sysmgr_categories WHERE parent_id=0          #一级分类个数
          Disconnect From Database
          #请求
          ${responsedata}          获取视频分类列表(GET)          ${API_URL}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #数据库中分类id与接口返回的分类id进行一一对比
          : FOR          ${i}          IN RANGE          ${count[0][0]}
          \          ${AID}          Get From Dictionary          ${Data[${i}]}          id          #接口返回一级分类id
          \          ${subList}          Get From Dictionary          ${Data[${i}]}          subList          #接口返回的二级分类列表
          \          Run Keyword If          ${AID}==${id[${i}][0]}          log          与数据库查询结果一致！！
          \          ...          ELSE          fail          与数据库查询的结果不一致！！
          \          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          \          ${zidList}          Query          SELECT id FROM t_sysmgr_categories WHERE parent_id='${AID}' and display=1          #数据库中一级分类id对应的二级分类id
          \          ${count1}          Query          SELECT count(*) FROM t_sysmgr_categories WHERE parent_id='${AID}' and display=1          #数据库中一级分类下的二级分类个数
          \          Disconnect From Database
          \          接口返回的二级分类与数据库做比对          ${count1[0][0]}          ${zidList}          ${subList}
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_CategoryListAll.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

根据视频分类Id获取视频列表
          [Documentation]          *根据视频分类Id获取视频列表*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：（这里的userid参数其实没什么用）*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${videoCategoryId}          Get From Dictionary          ${json_manager_content}          Video_CategoryId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          1_1          1_2          2_1          2_2
          ${orderType}          Get Random Choice Number          ${list}          #排序,1_1代表人气升序，1_2人气降序,2_1价格升序,2_2价格降序
          ${PageNo}          Get Range Number String          1          1
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${videoCategoryId}          ${UserID}
          ...          ${orderType}          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          根据视频分类Id获取视频列表          ${API_URL}          ${videoCategoryId}          ${UserID}          ${PageNo}          ${PageSize}
          ...          ${orderType}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          Comment          Run Keyword If          ${Data}!=[]          验证分类搜索返回播放器id是否与数据库一致          ${Data[0]}          ${videoCategoryId}
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_List.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频详细信息(GET)
          [Documentation]          *获取视频详细信息(GET)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：似乎返回的消息有问题，Message有时会返回一个异常消息 ‘未将对象引用设置到对象的实例。’*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${StoreId}          Set Variable          587
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${StoreId}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_store}          查询视频店铺是否有效          ${StoreId}
          ${store_is_ok}          查询视频店铺是否在线          ${StoreId}
          #请求
          ${responsedata}          获取视频详细信息(GET)          ${API_URL}          ${StoreId}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          未将对象引用设置到对象的实例。          None          None
          ${Success_list}          Create List          True          False          True          True
          ${Json_list}          Create List          Video_Detail.json          Video_Detail.json          Video_Detail(None).json          Video_Detail(None).json
          Comment          Validate Output Results          ${Message}          ${Message_list}          ${have_store}          ${store_is_ok}
          Comment          Validate Output Results          ${Success}          ${Success_list}          ${have_store}          ${store_is_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_store}          ${store_is_ok}
          Delete All Sessions

获取视频详细信息(POST)
          [Documentation]          *获取视频详细信息(POST)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${StoreId}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          ${have_store}          查询视频店铺是否存在          ${StoreId}
          ${store_is_ok}          查询视频店铺是否在线          ${StoreId}
          #请求
          ${responsedata}          获取视频详细信息(POST)          ${API_URL}          ${StoreId}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          ${EMPTY}          未将对象引用设置到对象的实例。          None          None
          ${Success_list}          Create List          True          False          True          True
          ${Json_list}          Create List          Video_Detail.json          Video_Detail.json          Video_Detail(None).json          Video_Detail(None).json
          Comment          Validate Output Results          ${Message}          ${Message_list}          ${have_store}          ${store_is_ok}
          Comment          Validate Output Results          ${Success}          ${Success_list}          ${have_store}          ${store_is_ok}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_store}          ${store_is_ok}
          Delete All Sessions

添加评论
          [Documentation]          *添加评论*
          ...
          ...          *参数注意：接口只检查了评论根节点ID, 但是对视频ID和评论发起者id的有效性并未做检查*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${Content}          Get Random Chinese String          20
          ${StoreId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${AtRId}          Get From Dictionary          ${json_user_content}          ReviewId          #评论根节点ID，这里其实就是评论ID          #注意这里取得的是个列表
          ${ReviewUserId}          Get From Dictionary          ${json_user_content}          UserID          #评论发起者ID，其实就是用户ID
          ${ReviewUserName}          Get From Dictionary          ${json_user_content}          UserName
          ${data}          Create Dictionary          Content=${Content}          StoreId=${StoreId}          Content=${Content}          AtRId=${AtRId[0]}          ReviewUserId=${ReviewUserId}
          ...          ReviewUserName=${ReviewUserName}
          #数据库
          ${have_AtRId}          查询视频评论是否存在          ${AtRId[0]}
          ${have_not_ReviewUserId}          Validate Input Parameters          P          OR          ${EMPTY}          ${ReviewUserId}
          ${have_not_StoreId}          Validate Input Parameters          P          OR          ${EMPTY}          ${StoreId}
          ${have_not_Content}          Validate Input Parameters          P          OR          ${EMPTY}          ${Content}
          Pass Execution If          not ${have_AtRId}          评论根节点ID无效，case执行失败！          #如果参数为空，直接Pass掉
          #请求
          ${responsedata}          添加评论          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          评论内容不能为空          评论内容不能为空          评论内容不能为空          评论内容不能为空          StoreId错误
          ...          ReviewUserId错误          StoreId错误          添加成功
          ${Success_list}          Create List          False          False          False          False          False
          ...          False          False          True
          ${Json_list}          Create List          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json          Common_Temp.json
          ...          Common_Temp.json          Common_Temp.json          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_Content}          ${have_not_StoreId}          ${have_not_ReviewUserId}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_Content}          ${have_not_StoreId}          ${have_not_ReviewUserId}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_Content}          ${have_not_StoreId}          ${have_not_ReviewUserId}
          Delete All Sessions

获取视频的评论列表(GET)
          [Documentation]          *获取视频的评论列表(GET)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：(模板校验中将凡是带name的字段去掉了)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${VideoId}          ${UserID}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取视频的评论列表(GET)          ${API_URL}          ${UserID}          ${VideoId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_ReviewList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频的评论列表(POST)
          [Documentation]          *获取视频的评论列表(POST)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：(模板校验中将凡是带name的字段去掉了)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${VideoId}          ${UserID}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取视频的评论列表(POST)          ${API_URL}          ${UserID}          ${VideoId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_ReviewList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频的评论列表-不分级(GET)
          [Documentation]          *获取视频的评论列表-不分级(GET)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：(模板校验中将凡是带name的字段去掉了)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${VideoId}          ${UserID}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取视频的评论列表-不分级(GET)          ${API_URL}          ${UserID}          ${VideoId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_ReviewListAll.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频的评论列表-不分级(POST)
          [Documentation]          *获取视频的评论列表-不分级(POST)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：(模板校验中将凡是带name的字段去掉了)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${VideoId}          ${UserID}
          ...          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取视频的评论列表-不分级(POST)          ${API_URL}          ${UserID}          ${VideoId}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_ReviewListAll.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取与用户相关的评论列表(GET)
          [Documentation]          *获取与用户相关的评论列表(GET)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：(模板校验结果中将凡是会产生null 值的字段去掉了)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          Comment          ${UserID}          Set Variable          633
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          0          1          2
          ${reviewType}          Get Random Choice Number          ${list}          #评论类型：0-查询与userId相关的所有评论 1-查询userId用户发出的评论 2-查询回复userId用户的评论
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${VideoId}          ${UserID}
          ...          ${reviewType}          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取与用户相关的评论列表(GET)          ${API_URL}          ${UserID}          ${VideoId}          ${reviewType}          ${PageNo}
          ...          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_ReviewListAll.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取与用户相关的评论列表(POST)
          [Documentation]          *获取与用户相关的评论列表(POST)*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：(模板校验结果中将凡是会产生null 值的字段去掉了)*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          Comment          ${UserID}          Set Variable          633
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${list}          Create List          0          1          2
          ${reviewType}          Get Random Choice Number          ${list}          #评论类型：0-查询与userId相关的所有评论 1-查询userId用户发出的评论 2-查询回复userId用户的评论
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${VideoId}          ${UserID}
          ...          ${reviewType}          ${PageNo}          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取与用户相关的评论列表(POST)          ${API_URL}          ${UserID}          ${VideoId}          ${reviewType}          ${PageNo}
          ...          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_ReviewListAll.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

播放器点赞
          [Documentation]          *播放器点赞*
          ...
          ...          *参数注意：这个接口应该是比较旧的，更新的数据库是azt_praisedvideo*
          ...
          ...          *备注：（最后面的三个参数似乎没什么用）*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${SourceName}          Get From Dictionary          ${json_manager_content}          SourceName
          ${data}          Create Dictionary          userId=${userId}          ShopId=${shopId}          ShopName=${shopName}          StoreId=${storeId}          StoreName=${storeName}
          ...          VideoId=${videoId}          VideoName=${videoName}          SourceType=${SourceType}          SourceId=${SourceId}          SourceName=${SourceName}
          #数据库
          #请求
          ${responsedata}          播放器点赞          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          点赞成功
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频的点赞数
          [Documentation]          *获取视频的点赞数*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${VideoId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取视频的点赞数          ${API_URL}          ${VideoId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_PraiseCount.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取所有标签
          [Documentation]          *获取所有标签*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          #创建参数字典
          #验证参数为空
          #数据库
          #请求
          ${responsedata}          获取所有标签          ${API_URL}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_TagsList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取用户保存的标签
          [Documentation]          *获取用户保存的标签*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          633
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取用户保存的标签          ${API_URL}          ${UserID}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_TagsList.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

保存用户标签
          ${json_user_content}          读取买家通用数据
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${json_manager_content}          读取卖家通用数据
          ${Tag_id}          Get From Dictionary          ${json_manager_content}          Tag_id
          ${Tag_name}          Get From Dictionary          ${json_manager_content}          Tag_name
          #创建参数字典
          #数据库
          Comment          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          Comment          ${Tag_id}          Query          SELECT id FROM `t_sysmgr_tags`          #数据库取标签id
          Comment          ${Tag_id}          Get Random Choice Number          ${Tag_id}
          Comment          ${Tag_id}          Set Variable          ${Tag_id[0]}
          Comment          ${Tag_name}          Query          SELECT name FROM `t_sysmgr_tags` where id=${Tag_id}          #数据库取标签name
          Comment          ${Tag_name}          Set Variable          ${Tag_name[0][0]}
          Comment          Disconnect From Database
          ${a}          Create Dictionary          Id=${Tag_id}          name=${Tag_name}          userId=${UserID}
          ${IdList}          Create List          ${a}
          ${data}          Create Dictionary          IdList=${IdList}
          log          ${data}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${Tag_name}          ${Tag_id}
          ...          ${UserID}
          #数据库
          #请求
          ${responsedata}          保存用户标签          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

保存用户标签-IOS
          [Documentation]          *保存用户标签-IOS*
          ...
          ...          *参数注意：接口并未做任何参数的检查*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          633
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${tagIds}          Get From Dictionary          ${json_manager_content}          TagsId
          ${tagNames}          Get From Dictionary          ${json_manager_content}          TagsName
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${tagIds}
          ...          ${tagNames}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          保存用户标签-IOS          ${API_URL}          ${UserID}          ${tagIds}          ${tagNames}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

根据标签查询视频
          [Documentation]          *根据标签查询视频*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：userid参数其实没什么用*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${tagIds}          Get From Dictionary          ${json_manager_content}          Tag_id
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${tagIds}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          根据标签查询视频          ${API_URL}          ${UserID}          ${tagIds}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          查询成功
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_GetTags.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取精选视频列表
          [Documentation]          *获取精选视频列表*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Set Variable          0
          Comment          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          1
          ${PageSize}          Get Range Number String          1          1
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${UserID}          ${PageNo}
          ...          ${PageSize}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取精选视频列表          ${API_URL}          ${UserID}          ${PageNo}          ${PageSize}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          ${EMPTY}
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_Featured.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取视频的弹幕列表
          [Documentation]          *获取视频的弹幕列表*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          #创建参数字典
          Comment          ${VideoId}          Set Variable          388
          ${VideoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${VideoId}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当参数为空时，这里不做验证，跳出case！
          #数据库
          #请求
          ${responsedata}          获取视频的弹幕列表          ${API_URL}          ${VideoId}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Video_Danmu.json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

弹幕数据写入
          [Documentation]          *弹幕数据写入 （点播，仅APP使用）*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：*
          ${json_manager_content}          读取卖家通用数据
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${userId}          Get From Dictionary          ${json_user_content}          UserID
          ${shopId}          Get From Dictionary          ${json_manager_content}          ShopId
          ${shopName}          Get From Dictionary          ${json_manager_content}          ShopName
          ${storeId}          Get From Dictionary          ${json_manager_content}          StoreId
          ${storeName}          Get From Dictionary          ${json_manager_content}          StoreName
          ${videoId}          Get From Dictionary          ${json_manager_content}          VideoId
          ${videoName}          Get From Dictionary          ${json_manager_content}          VideoName
          ${Text}          Get Random Chinese String          10
          ${SourceType}          Get From Dictionary          ${json_manager_content}          SourceType
          ${SourceId}          Get From Dictionary          ${json_manager_content}          SourceId
          ${ShowTimeSecond}          Get Random Number String          2
          ${data}          Create Dictionary          MemberId=${userId}          ShopId=${shopId}          ShopName=${shopName}          StoreId=${storeId}          StoreName=${storeName}
          ...          VideoId=${videoId}          VideoName=${videoName}          Text=${Text}          SourceType=${SourceType}          SourceId=${SourceId}          ShowTimeSecond=${ShowTimeSecond}
          #数据库
          #请求
          ${responsedata}          弹幕数据写入          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          ${Message_list}          Create List          None
          ${Success_list}          Create List          True
          ${Json_list}          Create List          Common_Temp(None).json
          Validate Output Results          ${Message}          ${Message_list}
          Validate Output Results          ${Success}          ${Success_list}
          Validate Json By Condition          ${Json_list}          ${responsedata}
          Delete All Sessions

获取平台所有视频列表
          [Documentation]          *获取平台所有视频列表*
          ...
          ...          *参数注意：接口返回的是个列表*
          ...
          ...          *备注：*
          #创建参数字典
          #验证参数为空
          #数据库
          #请求
          ${responsedata}          获取平台所有视频列表          ${API_URL}
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真
          log          ${responsedata[0]}
          Delete All Sessions
