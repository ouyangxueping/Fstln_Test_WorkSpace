*** Settings ***
Library                 ../../API_Lib/Create_Common_Arg.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary

*** Keywords ***
查询视频评论是否存在
          [Arguments]          ${select}
          [Documentation]          *查询参数：评论ID*
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${status}          Run Keyword And Return Status          Row Count Is Greater Than X          select * from azt_review where id="${select}"          0
          Disconnect From Database
          [Return]          ${status}

接口返回的二级分类与数据库做比对
          [Arguments]          ${count1[0][0]}          ${id1}          ${subList}
          : FOR          ${a}          IN RANGE          ${count1[0][0]}
          \          ${ZID}          Get From Dictionary          ${subList[${a}]}          id          #接口返回的二级分类id
          \          Run Keyword If          ${ZID}==${id1[${a}][0]}          log          二级分类与数据库一致！！
          \          ...          ELSE          fail          与数据库查询结果不一致！！          #接口返回的二级分类id与数据库中二级分类一一比对

验证分类搜索返回播放器id是否与数据库一致
          [Arguments]          ${Data[0]}          ${categoryid}
          ${ID}          Get From Dictionary          ${Data[0]}          Id
          Connect To Database Using Custom Params          pyodbc          "Driver={MySQL ODBC 5.3 Unicode Driver};Server=${Database_Addr};Port=${Database_Port};Database=${Database_Name[0]};User=${Database_User};Password=${Database_Passwd};"
          ${Videoid}          Query          SELECT video_id \ FROM \ `t_sysmgr_store_video` \ WHERE store_id='${ID}'          #获取分类下的视频id
          ${category}          Query          SELECT category FROM t_sysmgr_video \ WHERE id='${Videoid[0][0]}'          #获取分类下的播放器id
          Disconnect From Database
          Run Keyword If          ${category[0][0]}==${categoryid}          log          查询结果正确
          ...          ELSE          fail          查询结果与数据库中不一致！！

统计播放次数
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          report_videoplay          ${API_URL}          ${header}
          ${response}          Post Request          report_videoplay          api/report/videoplay          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

统计播放时长
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          report_videoplayseconds          ${API_URL}          ${header}
          ${response}          Post Request          report_videoplayseconds          api/report/videoplayseconds          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

搜索视频
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          Video_GetSearchVideo          ${API_URL}          ${header}
          ${response}          Post Request          Video_GetSearchVideo          api/Video/GetSearchVideo          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频二级分类列表(GET)
          [Arguments]          ${API_URL}          ${parentId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_category_list          ${API_URL}          ${header}
          ${response}          Get Request          video_category_list          api/video/category/list/${parentId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频二级分类列表(POST)
          [Arguments]          ${API_URL}          ${parentId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_category_list          ${API_URL}          ${header}
          ${response}          Post Request          video_category_list          api/video/category/list/${parentId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频分类列表(GET)
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_category_all          ${API_URL}          ${header}
          ${response}          Get Request          video_category_all          api/video/category/all
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频分类列表(POST)
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_category_all          ${API_URL}          ${header}
          ${response}          Post Request          video_category_all          api/video/category/all
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

根据视频分类Id获取视频列表
          [Arguments]          ${API_URL}          ${videoCategoryId}          ${userId}          ${pageNo}          ${pageSize}          ${orderType}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_list          ${API_URL}          ${header}
          ${response}          Get Request          video_list          api/video/list/${videoCategoryId}/${userId}/${pageNo}/${pageSize}/${orderType}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频详细信息(GET)
          [Arguments]          ${API_URL}          ${storeId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_detail          ${API_URL}          ${header}
          ${response}          Get Request          video_detail          api/video/detail/${storeId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频详细信息(POST)
          [Arguments]          ${API_URL}          ${storeId}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_detail          ${API_URL}          ${header}
          ${response}          Post Request          video_detail          api/video/detail/${storeId}/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

添加评论
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_add          ${API_URL}          ${header}
          ${response}          Post Request          video_review_add          api/video/review/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频的评论列表(GET)
          [Arguments]          ${API_URL}          ${userId}          ${videoId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_list          ${API_URL}          ${header}
          ${response}          Get Request          video_review_list          api/video/review/list/${userId}/${videoId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频的评论列表(POST)
          [Arguments]          ${API_URL}          ${userId}          ${videoId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_list          ${API_URL}          ${header}
          ${response}          Post Request          video_review_list          api/video/review/list/${userId}/${videoId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频的评论列表-不分级(GET)
          [Arguments]          ${API_URL}          ${userId}          ${videoId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_all          ${API_URL}          ${header}
          ${response}          Get Request          video_review_all          api/video/review/all/${userId}/${videoId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频的评论列表-不分级(POST)
          [Arguments]          ${API_URL}          ${userId}          ${videoId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_all          ${API_URL}          ${header}
          ${response}          Post Request          video_review_all          api/video/review/all/${userId}/${videoId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取与用户相关的评论列表(GET)
          [Arguments]          ${API_URL}          ${userId}          ${videoId}          ${reviewType}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_all_reviewType          ${API_URL}          ${header}
          ${response}          Get Request          video_review_all_reviewType          api/video/review/all/${userId}/${videoId}/${reviewType}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取与用户相关的评论列表(POST)
          [Arguments]          ${API_URL}          ${userId}          ${videoId}          ${reviewType}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_review_all_reviewType          ${API_URL}          ${header}
          ${response}          Post Request          video_review_all_reviewType          api/video/review/all/${userId}/${videoId}/${reviewType}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

播放器点赞
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_praise_add          ${API_URL}          ${header}
          ${response}          Post Request          video_praise_add          api/video/praise/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          ${responsedata}          To Json          ${response.content}
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频的点赞数
          [Arguments]          ${API_URL}          ${id}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_praise_count          ${API_URL}          ${header}
          ${response}          Get Request          video_praise_count          api/video/praise/count/${id}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取所有标签
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_tags_list          ${API_URL}          ${header}
          ${response}          Get Request          video_tags_list          api/video/tags/list
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取用户保存的标签
          [Arguments]          ${API_URL}          ${userId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_usertags          ${API_URL}          ${header}
          ${response}          Get Request          video_usertags          api/video/usertags/${userId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

保存用户标签
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_usertags_add          ${API_URL}          ${header}
          ${response}          Post Request          video_usertags_add          api/video/usertags/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

保存用户标签-IOS
          [Arguments]          ${API_URL}          ${userId}          ${tagIds}          ${tagNames}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_usertags_add_ios          ${API_URL}          ${header}
          ${response}          Get Request          video_usertags_add_ios          api/video/usertags/add/${userId}/${tagIds}/${tagNames}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

根据标签查询视频
          [Arguments]          ${API_URL}          ${userId}          ${tagIds}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_gettags          ${API_URL}          ${header}
          ${response}          Get Request          video_gettags          api/video/gettags/${userId}/${tagIds}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取精选视频列表
          [Arguments]          ${API_URL}          ${userId}          ${pageNo}          ${pageSize}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_featured          ${API_URL}          ${header}
          ${response}          Get Request          video_featured          api/video/featured/${userId}/${pageNo}/${pageSize}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取视频的弹幕列表
          [Arguments]          ${API_URL}          ${videoId}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_danmu          ${API_URL}          ${header}
          ${response}          Get Request          video_danmu          api/video/danmu/${videoId}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

弹幕数据写入
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_danmu_add          ${API_URL}          ${header}
          ${response}          Post Request          video_danmu_add          api/video/danmu/add          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

获取平台所有视频列表
          [Arguments]          ${API_URL}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          video_all          ${API_URL}          ${header}
          ${response}          Get Request          video_all          api/VideoApi
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}

api/video/scan
          [Arguments]          ${API_URL}          ${data}
          ${data}          Convert To Json          ${data}
          ${header}          Create Dictionary          Content-Type=application/json
          Create Session          api_video_scan          ${API_URL}          ${header}
          ${response}          Post Request          api_video_scan          api/video/scan          data=${data}
          ${responsedata}          To Json          ${response.content}          #将响应的二进制内容转化为json对象
          Log          ${responsedata}
          [Return]          ${responsedata}
