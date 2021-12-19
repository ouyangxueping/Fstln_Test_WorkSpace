*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询播放器投票总数
          [Arguments]          ${storeId}          ${VideoId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${VoteTotal}          Query          Select VoteTotal from azt_vote where StoreId='${storeId}' and VideoId='${VideoId}'          #从数据库查询出投票总数，用来与服务器响应做对比
          ${temp}          Get Random Choice Number          ${VoteTotal}
          ${VoteTotal}          Set Variable If          ${VoteTotal}==[]          0          ${temp[0]}          #可能参数为null的情况
          Disconnect From Database
          [Return]          ${VoteTotal}

验证投票总数
          [Arguments]          ${responsedata}          ${VoteTotal}
          ${Value}          Get From Dictionary          ${responsedata}          Value
          ${VoteTotal}          Evaluate          int(${VoteTotal})          #将字符串转换成整型
          Should Be Equal          ${VoteTotal}          ${Value}          msg=接口返回的投票数与数据库存储的值不相等！！！          #验证投票总数
          Validate Json          Get_Vote_Count.json          ${responsedata}          #验证服务端响应结果是否符合标准定义

查询用户是否当天已经投过票
          [Arguments]          ${userId}
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          SELECT * from azt_vote_detail where date(VoteTime)=date(now()) and MemberId="${userId}"          0          #判断用户是不是当天已经投过票
          Disconnect From Database
          [Return]          ${status}

播放器统计
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          report_player          ${API_URL}          ${header}
          ${response}          Post Request          report_player          api/report/player          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

App分享写入
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_saveShare          ${API_URL}          ${header}
          ${response}          Post Request          store_saveShare          api/store/saveShare          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

App写入经验值
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          exp_add          ${API_URL}          ${header}
          ${response}          Post Request          exp_add          api/exp/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

收藏播放器次数(GET)
          [Arguments]          ${API_URL}          ${storeId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_GetStoreFavoriteCount          ${API_URL}          ${header}
          ${response}          Get Request          store_GetStoreFavoriteCount          api/store/GetStoreFavoriteCount/${storeId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

收藏播放器次数(POST)
          [Arguments]          ${API_URL}          ${storeId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_GetStoreFavoriteCount          ${API_URL}          ${header}
          ${response}          Post Request          store_GetStoreFavoriteCount          api/store/GetStoreFavoriteCount/${storeId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

播放器访客次数统计
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Report_AddAZTReportVisitorStore          ${API_URL}          ${header}
          ${response}          Post Request          Report_AddAZTReportVisitorStore          api/Report/AddAZTReportVisitorStore          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商家名片信息(GET)
          [Arguments]          ${API_URL}          ${shopId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_shopcard          ${API_URL}          ${header}
          ${response}          Get Request          store_shopcard          api/store/shopcard/${shopId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取商家名片信息(POST)
          [Arguments]          ${API_URL}          ${shopId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_shopcard          ${API_URL}          ${header}
          ${response}          Post Request          store_shopcard          api/store/shopcard/${shopId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

收藏播放器(GET)
          [Arguments]          ${API_URL}          ${StoreId}          ${UserId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite          ${API_URL}          ${header}          #建立连接
          ${store_Favorite}          Get Request          store_Favorite          api/storeFavorite/Add/${StoreId}/${UserId}
          ${store_Favorite}          To Json          ${store_Favorite.content}          #取出返回值内容转化为joson格式
          [Return]          ${store_Favorite}

收藏播放器(POST)
          [Arguments]          ${API_URL}          ${StoreId}          ${UserId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite          ${API_URL}          ${header}          #建立连接
          ${store_Favorite}          Post Request          store_Favorite          api/storeFavorite/Add/${StoreId}/${UserId}          #发送post请求
          ${store_Favorite}          To Json          ${store_Favorite.content}          #取出返回值内容转化为joson格式
          [Return]          ${store_Favorite}

取消收藏播放器(GET)
          [Arguments]          ${API_URL}          ${StoreId}          ${UserId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite_Cancel          ${API_URL}          ${header}          #建立连接
          ${store_Favorite_Cancel}          Get Request          store_Favorite_Cancel          api/storeFavorite/Cancel/${StoreId}/${UserId}          #发送post请求
          ${store_Favorite_Cancel}          To Json          ${store_Favorite_Cancel.content}          #取出返回值内容转化为joson格式
          [Return]          ${store_Favorite_Cancel}

取消收藏播放器(POST)
          [Arguments]          ${API_URL}          ${StoreId}          ${UserId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite_Cancel          ${API_URL}          ${header}          #建立连接
          ${store_Favorite_Cancel}          Post Request          store_Favorite_Cancel          api/storeFavorite/Cancel/${StoreId}/${UserId}          #发送post请求
          ${store_Favorite_Cancel}          To Json          ${store_Favorite_Cancel.content}          #取出返回值内容转化为joson格式
          [Return]          ${store_Favorite_Cancel}

批量取消收藏播放器
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          storeFavorite_batchCancel          ${API_URL}          ${header}
          ${response}          Post Request          storeFavorite_batchCancel          api/storeFavorite/batchCancel          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

查询收藏播放器信息(GET)
          [Arguments]          ${API_URL}          ${storeId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite_info          ${API_URL}          ${header}          #建立连接
          ${response}          Get Request          store_Favorite_info          api/storeFavorite/info/${storeId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

查询收藏播放器信息(POST)
          [Arguments]          ${API_URL}          ${storeId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite_info          ${API_URL}          ${header}          #建立连接
          ${response}          Post Request          store_Favorite_info          api/storeFavorite/info/${storeId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收藏播放器列表(GET)
          [Arguments]          ${API_URL}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite_list          ${API_URL}          ${header}          #建立连接
          ${response}          Get Request          store_Favorite_list          api/storeFavorite/List/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取收藏播放器列表(POST)
          [Arguments]          ${API_URL}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_Favorite_list          ${API_URL}          ${header}          #建立连接
          ${response}          Post Request          store_Favorite_list          api/storeFavorite/List/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取播放器中使用的客户QQ(GET)
          [Arguments]          ${API_URL}          ${shopId}
          ${header}          Create Dictionary          Content-Type=application/json          #头文件信息
          Create Session          store_qq          ${API_URL}          ${header}          #建立连接
          ${response}          Get Request          store_qq          api/store/qq/${shopId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

播放器投票
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          vote_add          ${API_URL}          ${header}
          ${response}          Post Request          vote_add          api/store/vote/add          data=${data}
          ${responsedata}          To Json          ${response.content}
          Log          ${responsedata}
          [Return]          ${responsedata}

获取投票总数
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          vote_count          ${API_URL}          ${header}
          ${response}          Post Request          vote_count          api/store/vote/count          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

返回微信分享图片
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_getweixinlogo          ${API_URL}          ${header}
          ${response}          Post Request          store_getweixinlogo          api/store/getweixinlogo          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

返回播放器视频信息(POST)
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_getstorevideopostapi          ${API_URL}          ${header}
          ${response}          Post Request          store_getstorevideopostapi          api/store/getstorevideopostapi          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

返回播放器视频信息(GET)
          [Arguments]          ${API_URL}          ${store_id}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_getstorevideoapiget          ${API_URL}          ${header}
          ${response}          Get Request          store_getstorevideoapiget          api/store/getstorevideoapiget/${store_id}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

扣减流量
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_minusflowapi          ${API_URL}          ${header}
          ${response}          Post Request          store_minusflowapi          api/store/minusflowapi          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

地址生成二维码
          [Arguments]          ${API_URL}          ${store_id}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          store_getqrimage          ${API_URL}          ${header}
          ${response}          Get Request          store_getqrimage          api/store/getqrimage/${store_id}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
