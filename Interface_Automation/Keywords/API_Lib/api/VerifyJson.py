#!/usr/bin/env python
#coding=utf-8

from utils.TXT_Process import TXT_Process
from robot.utils.asserts import fail, assert_true
from robot.api import logger
import os, json, difflib, re


class VerifyJson(object):
    def __init__(self):
        self.txtFilePath = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + "\\fiddler_sessions\\Input_TXT_Files"
        self.json_list = []
        self.param_list = []

    def get_expect_json_list(self, api_name):
        """从Input_TXT_Files文件夹下获取特定接口的响应部分作为预期的json格式
        :param txtFilePath: Input_TXT_Files文件夹
        :param api_name: api名称
        :return:
        """
        txtProcess = TXT_Process()
        requestList = txtProcess.GetRequestList(self.txtFilePath)
        requestDictList = txtProcess.ParseRequestList(requestList)

        for i in range(len(requestDictList)):
            requestDict = requestDictList[i]

            RFScriptFile = requestDict['File name']
            case_name = RFScriptFile.split(".txt")[0]

            if case_name == api_name:
                for i1 in txtProcess.open_file(self.txtFilePath + os.sep + RFScriptFile.encode("utf8")):
                    if not i1.startswith("\n"):
                        if i1.startswith("Response body: "):
                            single_session = i1.split("Response body: ")[-1].replace("\n", "")
                            return single_session

    @staticmethod
    def print_json(json_data, title=""):
        """
        以树形结构打印json
        :param json_data: json数据源
        :return:
        """
        try:
            if isinstance(json_data, dict):
                decode = json_data
            else:
                decode = json.loads(json_data)
            print title
            print(json.dumps(decode, ensure_ascii=False, sort_keys=True, indent=2))
        except (ValueError, KeyError, TypeError):
            print("JSON format error")

    @staticmethod
    def response_json_stats_code(key, json_data):
        """
        返回StatsCode状态码
        :param key: 状态码字典的key
        :param json_data:
        :return:
        """
        data = ()
        try:
            data = json.loads(json_data)
        except Exception as e:
            print(e)
            print("JSON format error")
        if isinstance(data, dict):
            for k in data.keys():
                if k.startswith(key):
                    return data[k]
        return 0

    def iterate_json(self, json_data):
        """
        解析json并返回对应的key|value
        :param json_data: json数据源
        :return: 返回json各字段以及字段类型
        """
        self.json_list = []

        if isinstance(json_data, dict):
            data = json_data
        else:
            data = json.loads(json_data)

        self.__iterate_json(data)
        return self.json_list

    def is_check_param(self, json_body, param_str_list):
        """
        response body是否有time参数，如果有返回它的长度，无则返回0
        :param json_body:json数据源
        :param param_str_list:检查的参数列表
        :return:
        """
        for param_str in param_str_list:
            self.__is_check_param(json_body, param_str)

        print list(set(param_str_list) - set(self.param_list))
        print param_str_list
        print self.param_list
        if len(param_str_list) != len(self.param_list):
            print "ERROR：响应内容对比不匹配!"
        return self.param_list

    def __iterate_json(self, json_data, i=0):
        """
        遍历json
        :param i: 遍历深度
        :param json_data: json数据源
        :return: 返回json各字段以及字段值
        """
        if isinstance(json_data, dict):
            for k in json_data.keys():
                self.json_list.append('%s|%s' % (k, str(type(json_data[k])).split("'")[1]))
                if isinstance(json_data[k], list):
                    if len((json_data[k])) and isinstance(json_data[k][0], dict):
                        self.__iterate_json(json_data[k][0], i=i + 1)
                if isinstance(json_data[k], dict):
                    self.__iterate_json(json_data[k], i=i + 1)
        else:
            print("JSON format error")

    def __is_check_param(self, json_body, param_str, i=0):
        """
        response body是否有 param_str: 参数，如果有返回它的名称、值、类型
        :param i: 遍历深度
        :param json_body: json数据源
        :param param_str: 检查的参数字段
        :return:
        """
        if isinstance(json_body, dict):
            json_data = json_body
        else:
            json_data = json.loads(json_body)

        if isinstance(json_data, dict):
            for k in json_data.keys():
                if isinstance(json_data[k], list):
                    if len((json_data[k])) and isinstance(json_data[k][0], dict):
                        self.__is_check_param(json_data[k][0], param_str, i=i + 1)
                if isinstance(json_data[k], dict):
                    self.__is_check_param(json_data[k], param_str, i=i + 1)
                if k.lower() == param_str.lower():
                    self.param_list.append('%s|%s|%s' % (k, json_data[k], str(type(json_data[k])).split("'")[1]))
                    # if isinstance(json_data[k], int):
                    #     length = len(str(json_data[k]))
                    #     self.time_param_list.append('%s|%s' % (k, length))
                    # if isinstance(json_data[k], str):
                    #     self.time_param_list.append('%s' % k)
        else:
            print("JSON format error")

    def diff_verify_json(self, api_name, result_json_body):
        expect_json = self.get_expect_json_list(api_name)

        if expect_json:
            result_json_list = self.iterate_json(result_json_body)
            expect_json_list = self.iterate_json(expect_json)

            diff = list(set(expect_json_list) - set(result_json_list))  # 求差集
            # print diff
            #实际响应字段的差异部分
            result_diff_list = []
            for i in range(len(diff)):
                for j in range(len(result_json_list)):
                    if diff[i].split("|")[0] == result_json_list[j].split("|")[0]:
                        result_diff_list.append(result_json_list[j])
            # print result_diff_list

            if not diff:
                logger.info(u"\t\njson校验完成！未发现异常字段。接口测试通过！\t\n")
            elif 0.8 < difflib.SequenceMatcher(None, expect_json_list, result_json_list).ratio() < 1.0:
                logger.warn(u"\t\n警告！发现接口响应与预期不一致，请检查！json对比分析情况，预期json和实际json差异为： %s -------> %s\t\n" % (diff,result_diff_list))
                self.print_json(expect_json, u"\n预期json格式,例如:")
                self.print_json(result_json_body, u"\n但是实际返回的json内容为:")
            elif len(expect_json_list) == len(result_json_list):
                if json.loads(expect_json)["Code"] == json.loads(result_json_body)["Code"] and json.loads(expect_json)["Message"] == json.loads(result_json_body)["Message"] and \
                        json.loads(expect_json)["Success"] == json.loads(result_json_body)["Success"]:
                    logger.warn(u"\t\n警告！警告！接口返回的数据类型发生变化，预期json和实际json差异为： %s -------> %s\t\n" % (diff,result_diff_list))
                    self.print_json(expect_json, u"\n预期json格式,例如:")
                    self.print_json(result_json_body, u"\n但是实际返回的json内容为:")
                else:
                    fail(u"\t\n出错！json对比分析后发现接口变化差异很大。接口测试不通过！\t\n")
            else:
                logger.warn(u"\t\n警告！发现接口响应与预期结果的返回Data或Value数据不一致，可能是由于数据内容发生变化导致！ \t\n")
        else:
            fail(u"\t\n失败！未找到匹配的预期结果！\t\n")


if __name__ == "__main__":
    json_str = {
                "Value": {
                    "AdminPrivileges": None,
                    "CreateDate": "2016-03-21T16:23:19",
                    "StringCreateDate": "2016-03-21 16:23",
                    "Description": "系统管理员",
                    "Email": "11",
                    "Id": 463,
                    "Password": "187b150d77fe210bd9d03df173db51b7",
                    "PasswordSalt": "41d7a4fb13d84d8fd137",
                    "RealName": "89889",
                    "Remark": "Ddddddd",
                    "RoleId": 0,
                    "GuideId": 0,
                    "RoleName": "系统管理员",
                    "SellerPrivileges": [
                        0
                    ],
                    "ShopId": 3551,
                    "UserId": 0,
                    "UserName": "kevin_tan",
                    "CellPhone": "13025428825",
                    "LastLoginDate": "2017-11-02T15:01:15",
                    "HasSmartStore": True,
                    "ImportSource": 0
                },
                "Message": None,
                "Success": None,
                "Code": 0
            }

    h = VerifyJson()
    # print h.is_check_param(json_str1, ["code", "message", "shopid", "sdf"])
    h.diff_verify_json("POST_api_seller_login", json_str)
    # print h.get_expect_json_list("api/seller/login")