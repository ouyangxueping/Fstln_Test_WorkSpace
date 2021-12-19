*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
获取店铺基本信息
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_baseinfo          ${API_URL}          ${header}
          ${response}          Post Request          shop_baseinfo          api/shop/baseinfo          ${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺首页
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_home          ${API_URL}          ${header}
          ${response}          Post Request          shop_home          api/shop/home          ${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺视频页
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_videos          ${API_URL}          ${header}
          ${response}          Post Request          shop_videos          api/shop/videos          ${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺商品页
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_products          ${API_URL}          ${header}
          ${response}          Post Request          shop_products          api/shop/products          ${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺基本信息和播放器列表(GET)
          [Arguments]          ${API_URL}          ${ShopId}          ${UserID}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          videoShop_baseInfo_get          ${API_URL}          ${header}
          ${response}          Get Request          videoShop_baseInfo_get          api/videoShop/baseInfo/${ShopId}/${UserID}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺基本信息和播放器列表(POST)
          [Arguments]          ${API_URL}          ${ShopId}          ${UserID}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          videoShop_baseInfo_post          ${API_URL}          ${header}
          ${response}          Post Request          videoShop_baseInfo_post          api/videoShop/baseInfo/${ShopId}/${UserID}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

添加店铺关注
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_concern_add          ${API_URL}          ${header}
          ${response}          Post Request          shop_concern_add          api/shop/concern/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

取消店铺关注
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_concern_cancel          ${API_URL}          ${header}
          ${response}          Post Request          shop_concern_cancel          api/shop/concern/cancel          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

关注列表(GET_1)
          [Arguments]          ${API_URL}          ${UserID}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          concern_list          ${API_URL}          ${header}
          ${response}          Get Request          concern_list          api/shop/concern/list/${UserID}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

关注列表(GET_2)
          [Arguments]          ${API_URL}          ${UserID}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          concern_getlist          ${API_URL}          ${header}
          ${response}          Get Request          concern_getlist          api/shop/concern/getlist/${UserID}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

关注列表(POST)
          [Arguments]          ${API_URL}          ${UserID}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          concern_getlist          ${API_URL}          ${header}
          ${response}          Post Request          concern_getlist          api/shop/concern/getlist/${UserID}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取关注店铺的动态信息
          [Arguments]          ${API_URL}          ${UserID}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          concern_notification          ${API_URL}          ${header}
          ${response}          Get Request          concern_notification          api/shop/concern/notification/${UserID}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺评论列表(GET)
          [Arguments]          ${API_URL}          ${UserID}          ${ShopId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_review_list_get          ${API_URL}          ${header}
          ${response}          Get Request          shop_review_list_get          api/shop/review/list/${UserID}/${ShopId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺评论列表(POST)
          [Arguments]          ${API_URL}          ${UserID}          ${ShopId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_review_list_post          ${API_URL}          ${header}
          ${response}          Post Request          shop_review_list_post          api/shop/review/list/${UserID}/${ShopId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

写评论(Post)
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          videoShop_review_post          ${API_URL}          ${header}
          ${response}          Post Request          videoShop_review_post          api/shop/review/add          ${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

写评论(Get)
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          videoShop_review_get          ${API_URL}          ${header}
          ${response}          Get Request          videoShop_review_get          api/shop/review/add          ${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺公告列表
          [Arguments]          ${API_URL}          ${ShopId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_notice_list          ${API_URL}          ${header}
          ${response}          Get Request          shop_notice_list          api/shop/notice/list/${ShopId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取店铺公告详情
          [Arguments]          ${API_URL}          ${id}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          shop_notice_detail          ${API_URL}          ${header}
          ${response}          Get Request          shop_notice_detail          api/shop/notice/detail/${id}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
