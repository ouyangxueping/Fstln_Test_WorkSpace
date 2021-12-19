#!/usr/bin/env python
#coding=utf-8

import re, json, os
import urllib
import utils.GlobalList
from collections import OrderedDict
from utils.TXT_Process import TXT_Process
from api.GetApi import GetApi


class TXT2RFScript(object):
    def __init__(self, txtFile, RFScriptFilePath):
        self.api_category = GetApi()
        self.RFScriptFilePath = RFScriptFilePath
        self.txtProcess = TXT_Process()
        self.requestList = self.txtProcess.GetRequestList(txtFile)
        self.requestDictList = self.txtProcess.ParseRequestList(self.requestList)
        self.init_str = '*** Settings ***' + '\n'
        self.init_str += 'Documentation     *XXXXXXXXX*' + '\n'
        self.init_str += 'Force Tags        API-Automated' + '\n'
        self.init_str += 'Library           ../../System_Public_Lib/Create_Common_Arg.py' + '\n'
        self.init_str += 'Library           RequestsKeywords' + '\n'
        self.init_str += 'Library           Collections' + '\n'
        self.init_str += 'Library           DatabaseLibrary' + '\n'
        self.init_str += 'Library           ReadAndWriteExcel' + '\n'
        self.init_str += 'Resource          ../Variables_Global.txt' + '\n'
        self.init_str += 'Resource          L1_Components.txt' + '\n\n'
        self.init_str += '*** Test Cases ***' + '\n'

    def add_case_to_RFScript(self, case_name, requestMethod, requestURL, requestBody):

        requestSession = requestURL.replace(",", "").replace("/", "_")

        if requestMethod == "POST":
            requestMethod = "Post Request"
            requestData = "data=${data}"
            #直接loads会内容自动排序，这里设置跟传进来的一致
            requestBody = json.loads(requestBody, object_pairs_hook=OrderedDict)
            requestURL = requestSession.replace(",", "").replace("_", "/")
        else:
            requestMethod = "Get Request"
            requestURL = requestURL.replace('/{', '/${')
            requestData = ""
            requestSession = requestSession.split("_{")[0]

        case_str = '%s' + '\n'
        case_str += '    [Documentation]    *XXXXXX*' + '\n'
        case_str += '    ...' + '\n'
        case_str += '    ...    *参数注意：*' + '\n'
        case_str += '    ...' + '\n'
        case_str += '    ...    *备注：*' + '\n'

        case_str += '    ${count}    ${result}    Get Number Of Match Cells    Sheet1    1    ${TEST_NAME}' + '\n'
        case_str += '    :FOR    ${row_num}    IN RANGE    ${count}' + '\n'
        case_str += '    \    #创建参数字典' + '\n'
        case_str += '    \    ${In_Parame}    Parse Cell Content    ${result[${row_num}]["In_Parame"]}    &' + '\n'
        case_str += '    \    ${Out_Parame}    Parse Cell Content    ${result[${row_num}]["Out_Parame"]}    &' + '\n'

        #Get方法传进来的是list     POST方法传进来的是dict
        if requestMethod == "Get Request":
            for key in range(len(requestBody)):
                case_str += '    \    ${%s}    Set Variable    ${In_Parame[%s]}' % (requestBody[key].encode("utf8"), key) + '\n'
        else:
            for key in range(len(requestBody.items())):
                case_str += '    \    ${%s}    Set Variable    ${In_Parame[%s]}' % (requestBody.items()[key][0].encode("utf8"), key) + '\n'
            case_str += '    \    ${data}    Create Dictionary'
            for key in requestBody:
                case_str += '   %s=${%s}' % (key.encode("utf8"), key.encode("utf8"))

        case_str += '\n'
        case_str += '    \    #数据库' + '\n'
        case_str += '    \    #请求' + '\n'

        if requestMethod == "Post Request":
            case_str += '    \    ${data}    Convert To Json    ${data}' + '\n'

        case_str += '    \    ${header}    Create Dictionary    Content-Type=application/json' + '\n'
        case_str += '    \    Create Session    %s    ${API_URL}    ${header}' + '\n'
        case_str += '    \    ${response}    %s    %s    %s    %s' + '\n'
        case_str += '    \    ${responsedata}    To Json    ${response.content}    #将响应的二进制内容转化为json对象' + '\n'
        case_str += '    \    Log    ${responsedata}' + '\n'
        case_str += '    \    ${Success}    Get From Dictionary    ${responsedata}    Success' + '\n'
        case_str += '    \    ${Message}    Get From Dictionary    ${responsedata}    Message' + '\n'
        case_str += '    \    ${Success}    Convert To String    ${Success}' + '\n'
        case_str += '    \    ${Message}    Convert To String    ${Message}' + '\n'
        case_str += '    \    #校验预期结果和实际结果' + '\n'
        case_str += '    \    Should Be Equal    ${Out_Parame[0]}    ${Message}' + '\n'
        case_str += '    \    Should Be Equal    ${Out_Parame[1]}    ${Success}' + '\n'
        case_str += '    \    Diff Verify Json    ${TEST_NAME}    ${response.content}' + '\n'
        case_str += '    \    Delete All Sessions' + '\n\n'

        return case_str % (case_name, requestSession, requestMethod, requestSession, requestURL, requestData)

    def add_keyword_to_RFScript(self, keyword_name):
        keyword_str = '*** Keywords ***' + '\n'
        keyword_str += '%s' + '\n'
        keyword_str += '    [Arguments]    ${pra1}    ${pra2}    ${pra3}' + '\n'
        keyword_str += '    [Documentation]    *参数注解：*' + '\n'
        keyword_str += '    ...' + '\n'
        keyword_str += '    ...    *${pra1}：xxxxxxxxx*' + '\n'
        keyword_str += '    Click Element    id=${login_by}' + '\n\n'

        return keyword_str % keyword_name

    def Init_RFScripts(self):
        return self.init_str

    ''' 生成RobotFramework框架脚本'''
    def GenerateRFScript(self):
        FilterSession_path = os.path.dirname(self.RFScriptFilePath) + "\\FilterSessionList.txt"
        api_category_dic = self.api_category.get_api_category_data()   #api分类取的就是api站点上的分类和对应api字典
        filter_session_Str = ""
        filter_session_List = []

        #判断是否存在过滤接口，如果存在则设置
        if os.path.exists(FilterSession_path):
            try:
                with open(FilterSession_path, "r") as FilterSession:
                    filetr = FilterSession.read()
            except:
                print u"打开文件失败！"
            filter_session_List = filetr.split("\n")
            # print filter_session_List

        #创建suite文件并初始化
        for i in range(len(self.requestDictList)):
            for api_category in api_category_dic:
                requestDict = self.requestDictList[i]
                requestMethod = requestDict['Request method']
                requestURL = requestDict['Request url']
                requestURL = requestURL.split(":6006/")[-1].split(":7006/")[-1]
                requestURL = re.sub(r'(/\w*[0-9]+)\w*', '', requestURL)

                #遍历分类下的列表
                for api in api_category_dic[api_category]:
                    #如果分类下的api(去掉url传参部分)列表等于txt文件中的url地址，且请求方法一样,则表示匹配
                    if requestURL == re.sub(r'(/{\w*})', '', api).split(" ")[1] and requestMethod == api.split(" ")[0] and requestURL not in filter_session_List:
                        try:
                            with open(self.RFScriptFilePath + "\\" + str(api_category) + ".txt", "w") as RFScript:
                                RFScript.write(self.init_str)
                        except:
                            print u"打开文件失败！"

        #追加case
        for i in range(len(self.requestDictList)):
            requestDict = self.requestDictList[i]
            RFScriptFile = requestDict['File name']
            requestMethod = requestDict['Request method']

            requestURL = requestDict['Request url']

            requestURL = requestURL.split(":6006/")[-1].split(":7006/")[-1]  #去掉ip地址部分
            requestURL = re.sub(r'(/\w*[0-9]+)\w*', '', requestURL)  #去掉url传参类型的数字部分

            requestBody = requestDict['Request body']
            requestBody = requestBody.replace("\n", "").encode("utf8")  #去掉回车符且转码

            case_name = RFScriptFile.split(".txt")[0]

            #遍历api分类字典
            for api_category in api_category_dic:
                #遍历分类下的列表
                for api in api_category_dic[api_category]:
                    #如果分类下的api(去掉url传参部分)列表等于txt文件中的url地址，且请求方法一样,则表示匹配
                    if requestURL == re.sub(r'(/{\w*})', '', api).split(" ")[1] and requestMethod == api.split(" ")[0] and requestURL not in filter_session_List:
                        # print requestURL, api, RFScriptFile
                        # print "--------------------------------------"
                        if requestMethod == "GET" or "{" in api:
                            #如果是get方法或者url中带有 '{' 则参数需要从url中取.否则就从文件中取
                            requestBody = re.findall("{(.+?)}", api.split(" ")[1])
                            requestURL = api.split(" ")[1]

                        script = self.add_case_to_RFScript(str(case_name), str(requestMethod), str(requestURL), requestBody)
                        try:
                            with open(self.RFScriptFilePath + "\\" + str(api_category) + ".txt", "a") as RFScript:
                                RFScript.write(script)
                        except:
                            print u"打开文件失败！"

                        requestURL = re.sub(r'(/{\w*})', '', api).split(" ")[1]
                        filter_session_Str += requestURL + "\n"

        #追加keyword

        #将生成的接口写入FilterSessionList.txt，下次执行的时候可以过滤掉
        try:
            with open(FilterSession_path, "a") as FilterSession:
                FilterSession.write(filter_session_Str)
        except:
            print u"打开文件失败！"


if __name__ == '__main__':
    pass