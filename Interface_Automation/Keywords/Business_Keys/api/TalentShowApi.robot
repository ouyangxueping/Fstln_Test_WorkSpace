*** Settings ***
Documentation           *达人推荐接口API*
Force Tags              API-Automated
Library                 ../../API_Lib/Image_Operation.py
Library                 RequestsKeywords
Library                 Collections
Library                 DatabaseLibrary
Resource                L1_Components.txt
Resource                ../../../Generic_Profiles.txt
Resource                L2_Keywords_TalentShowApi.txt

*** Test Cases ***
上传图片
          [Documentation]          *貌似这个接口有问题，文件保存时没有后缀，返回也是失败！*
          ...
          ...          *app发布达人推荐上传图片接口使用的是 话题API中的上传图片接口*
          ...
          ...          *发布达人推荐的api调用顺序为：1、POST /api/member/GetSignInDetail \ \ \ 2、POST /api/talk/saveimage 得到的 Value值作为第三步参数 \ 3、POST /api/TalentShow/AddShow \ \ *
          #请求          data=${data}
          ${header}          Create Dictionary          Content-Type=application/json
          ${auth}          Create List          kevin_tan          123456
          Create Session          saveimage          ${API_URL}          ${header}
          ${ImageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\test.png
          ${data}          Create Dictionary          ImageStreamString=${ImageStreamString}          userId=0
          ${data}          Convert To Json          ${data}
          log          ${data}
          ${files}          Create Dictionary          file="Photo3.jpg"
          ${response}          Post Request          saveimage          api/TalentShow/saveimage          data=${data}
          ${responsedata}          To Json          ${response.content}
          Log          ${responsedata}
          ${str1}          Get From Dictionary          ${responsedata}          Message
          ${str2}          Get From Dictionary          ${responsedata}          Success
          Delete All Sessions

获取达人推荐列表
          [Documentation]          *获取达人推荐列表*
          ...
          ...          *参数注意：*
          #创建参数字典
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          PageNo=${PageNo}          PageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${PageNo}
          #数据库
          #POST请求
          ${responsedata}          获取达人推荐列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          未将对象引用设置到对象的实例。          获取成功
          ${Success_list}          Create List          False          True
          ${Json_list}          Create List          TalentShow_List.json          TalentShow_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取达人推荐详情评论列表
          [Documentation]          *获取达人推荐详情评论列表*
          ...
          ...          *参数注意：（userid参数没什么用处，但又是必须的。。。）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalentShowID}          Get From Dictionary          ${json_user_content}          TalentShowID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          Id=${TalentShowID}          UserId=${UserID}          PageNo=${PageNo}          PageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P          OR          ${EMPTY}          ${PageNo}          ${UserID}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalentShowID}
          #数据库
          #POST请求
          ${responsedata}          获取达人推荐详情评论列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真          真--假          假--真          假--假
          ${Message_list}          Create List          参数错误          参数错误          达人秀Id错误          获取成功
          ${Success_list}          Create List          False          False          False          True
          ${Json_list}          Create List          TalentShow_Detail_List.json          TalentShow_Detail_List.json          TalentShow_Detail_List.json          TalentShow_Detail_List.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_not_id}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_not_id}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_not_id}
          Delete All Sessions

获取达人推荐详情
          [Documentation]          *获取达人推荐详情*
          ...
          ...          *参数注意：*
          ...
          ...          *备注：（同上 userid参数没什么用处，但又是必须的。。。）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${TalentShowID}          Get From Dictionary          ${json_user_content}          TalentShowID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          Id=${TalentShowID}          UserId=${UserID}          PageNo=${PageNo}          PageSize=${PageSize}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}          ${PageNo}
          ${have_not_id}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalentShowID}
          #数据库
          ${TalentShowID_OK}          判断达人推荐是否正常          ${TalentShowID}
          #POST请求
          ${responsedata}          获取达人推荐详情          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真--真--真          真--假--真          真--真--假          真--假--假          假--真--真
          ...          假--假--真          假--真--假          假--假--假
          ${Message_list}          Create List          参数错误          参数错误          参数错误          参数错误          达人秀Id错误
          ...          获取成功          达人秀Id错误          暂无数据
          ${Success_list}          Create List          False          False          False          False          False
          ...          True          False          False
          ${Json_list}          Create List          TalentShow_Detail(ERR).json          TalentShow_Detail(ERR).json          TalentShow_Detail(ERR).json          TalentShow_Detail(ERR).json          TalentShow_Detail(ERR).json
          ...          TalentShow_Detail.json          TalentShow_Detail(ERR).json          TalentShow_Detail(ERR).json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}          ${have_not_id}          ${TalentShowID_OK}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}          ${have_not_id}          ${TalentShowID_OK}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}          ${have_not_id}          ${TalentShowID_OK}
          Delete All Sessions

发布达人推荐
          [Documentation]          *发布达人推荐*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${Title}          Get Random Chinese String          10
          ${Content}          Get Random Chinese String          100
          ${ImageStreamString}          Get Image StreamString          ${CURDIR}\\Files\\TalentShow_Photo1.jpg
          ${responsedata}          上传图片(话题接口)          ${API_URL}          ${ImageStreamString}
          ${image_path}          Get From Dictionary          ${responsedata}          Value
          ${ImageLen}          Set Variable          ${image_path}          #将调用上传图片接口返回的路径传给iamges参数
          ${data}          Create Dictionary          Title=${Title}          Content=${Content}          ImageLen=${ImageLen}          UserId=${UserID}
          ${have_not_user}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${UserID}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${Content}          ${Title}          ${ImageLen}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #POST请求
          ${responsedata}          发布达人推荐          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          TalentShow_AddShow.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions

获取用户的达人推荐列表
          [Documentation]          *获取用户的达人推荐列表*
          ...
          ...          *参数注意：*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          Comment          ${UserID}          Set Variable          633
          ${UserID}          Get From Dictionary          ${json_user_content}          UserID
          ${PageNo}          Get Range Number String          1          3
          ${PageSize}          Get Range Number String          1          9
          ${data}          Create Dictionary          PageSize=${PageSize}          PageNo=${PageNo}          UserId=${UserID}
          ${have_not_par}          Validate Input Parameters          V          ${data}          ${EMPTY}
          #验证参数为空
          Pass Execution If          ${have_not_par[1]}          当有参数为空时，其实就是异常了！
          #数据库
          #POST请求
          ${responsedata}          获取用户的达人推荐列表          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Data}          Get From Dictionary          ${responsedata}          Data
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          TalentShow_UserList.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par[1]}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par[1]}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par[1]}
          Delete All Sessions

删除用户的达人推荐
          [Documentation]          *删除用户的达人推荐*
          ...
          ...          *参数注意：（values参数取的是达人推荐ID，调用后 AdminStatus 变为 -2）*
          ${json_user_content}          读取买家通用数据
          #创建参数字典
          ${TalentShowID}          Get From Dictionary          ${json_user_content}          TalentShowID
          ${data}          Create Dictionary          values=${TalentShowID}
          ${have_not_par}          Validate Input Parameters          P
          ...          AND          ${EMPTY}          ${TalentShowID}
          #验证参数为空
          Pass Execution If          ${have_not_par}          当有参数为空时，其实就是异常了！
          #数据库
          #POST请求
          ${responsedata}          删除用户的达人推荐          ${API_URL}          ${data}
          ${Message}          Get From Dictionary          ${responsedata}          Message
          ${Success}          Get From Dictionary          ${responsedata}          Success
          ${Value}          Get From Dictionary          ${responsedata}          Value
          #创建预期结果列表
          Comment          （对应的条件组合顺序表）          真          假
          ${Message_list}          Create List          ${EMPTY}          None
          ${Success_list}          Create List          ${EMPTY}          True
          ${Json_list}          Create List          ${EMPTY}          TalentShow_Delete.json
          Validate Output Results          ${Message}          ${Message_list}          ${have_not_par}
          Validate Output Results          ${Success}          ${Success_list}          ${have_not_par}
          Validate Json By Condition          ${Json_list}          ${responsedata}          ${have_not_par}
          Delete All Sessions
