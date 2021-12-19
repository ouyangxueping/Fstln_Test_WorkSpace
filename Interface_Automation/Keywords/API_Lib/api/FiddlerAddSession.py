#!/usr/bin/env python
#coding=utf-8

"""
用来在fiddler中手动右键添加单独的session到接口文件
"""


import os, codecs
from utils.TXT_Process import TXT_Process


class AddSession(object):

    def __init__(self, source_path, target_path):
        self.source_path = source_path
        self.target_path = target_path
        self.url = ""
        self.session = []
        self.request_method = ""
        self.target_file_path = ""

    def get_session(self):
        """
        获取待添加的session.
        :return:
        """
        l = TXT_Process().open_file(self.source_path)
        for j in l:
            if not j.startswith("\n"):
                if j.startswith("Request method: "):
                    self.request_method = j.split(" ")[2]

                if j.startswith("Request url: "):
                    count = len(j.split("/"))
                    self.url = self.request_method
                    for i in range(1, count):
                        self.url += "_" + j.split("/")[i]
                    self.session = l
                    return

    def __get_file_list(self):
        """
        获取目标地址目录下的文件列表
        :return: 返回标地址目录下的文件列表
        """
        for root, dirs, files in os.walk(self.target_path):
            return (f for f in files)

    def __match_file(self):
        """
        url与文件列表匹配
        :return:返回匹配的文件
        """
        self.get_session()
        return [i for i in self.__get_file_list() if i.startswith(self.url)]

    def append_session_file(self):
        """
        把session追加到文件
        :return:
        """
        file_name = self.__match_file()

        if file_name:
            self.target_file_path = '%s%s%s' % (self.target_path, "\\", file_name[0])
            write_file_name = file_name[0]
        else:
            self.target_file_path = str(self.target_path) + "\\" + str(self.url) + ".txt"
            write_file_name = str(self.url) + ".txt"

        try:
            with codecs.open(self.target_file_path, 'a', 'utf-16') as f:
                f.write("File name: " + write_file_name + "\r\n")
                for i in self.session:
                    f.write(i + "\r\n")
        except UnicodeEncodeError:
            with codecs.open(self.target_file_path, 'a', 'utf-16') as f:
                f.write("File name: " + write_file_name + "\r\n")
                for i in self.session:
                    f.write(i + "\r\n")


if __name__ == "__main__":
    pass
