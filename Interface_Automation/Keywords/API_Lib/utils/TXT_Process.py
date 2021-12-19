#!/usr/bin/env python
#coding=utf-8

import os, re
import codecs


class TXT_Process(object):
    def __init__(self):
        pass

    def all_file_path(self, root_directory):
        """
        :return: 遍历文件目录
        """
        file_dic = {}
        for parent, dirnames, filenames in os.walk(root_directory):
            for filename in filenames:
                if 'filter' not in filename:
                    if filename.endswith("txt"):
                        path = os.path.join(parent, filename).replace('\\', '/')
                        file_dic[filename] = path
        return file_dic

    def open_file(self, file):
        #打开文本，告诉解码器是unicode编码
        with codecs.open(file, 'r', 'utf-16') as txt_file:
            lines = [ line for line in txt_file]
            request_content = []
            for i in range(len(lines)):  # 去除每行末尾的'\r\n'
                lines[i] = re.sub(r'\n', '', lines[i])
                lines[i] = re.sub(r'\r', '', lines[i])
                # lines[i] = re.sub(r'\t', '', lines[i])
                if lines[i] == "":  #再去掉 ''
                    continue
                request_content.append(lines[i])
            return request_content

    ''' 将文件或文件夹中的每个request转换为一个list，最终将所有request以二维list的形式返回 '''
    def GetRequestList(self, source):
        RequestList = []
        if os.path.isdir(source):
            for file in self.all_file_path(source).values():
                request_content = self.open_file(file)
                RequestList.append(request_content)
            return RequestList
        else:
            request_content = self.open_file(source)
            RequestList.append(request_content)
            return RequestList

    ''' 解析单个request list，以dict的形式返回 '''
    def ParseRequest(self, request):
        requestDict = {}

        elementNum = len(request)
        for i in range(elementNum):
            reqItem = request[i].split(": ")
            if len(reqItem) == 2:   #reqItem的格式为“XX: YY”，排除第一行和空行
                requestDict[reqItem[0]] = reqItem[1]    #reqItem=[XX,YY]

        return requestDict

    ''' 将RequestList中的每个request转换为dict，最终将所有request以二维dict的形式返回'''
    def ParseRequestList(self, requestList):
        requestDictList = []
        for i in range(len(requestList)):
            requestDictList.append(self.ParseRequest(requestList[i]))
        return requestDictList


if __name__ == '__main__':
    pass
