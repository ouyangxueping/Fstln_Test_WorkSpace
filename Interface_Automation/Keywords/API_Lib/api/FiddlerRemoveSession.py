#!/usr/bin/env python
#coding=utf-8

"""
用来在fiddler中手动右键从接口文件中移除单独的session文件
"""

import os
from FiddlerAddSession import AddSession


class RemoveSession(object):

    def __init__(self, source_path, target_path):
        self.source_path = source_path
        self.target_path = target_path
        self.url = ""
        self.target_file_path = ""

    def __get_session(self):
        """
        获取待删除的session
        :return:
        """
        AddSession(self.source_path, self.target_path).get_session()

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
        self.__get_session()
        return [i for i in self.__get_file_list() if i.startswith(self.url)]

    def remove_session_file(self):
        """
        移除session的目标文件
        :return:
        """
        file_name = self.__match_file()

        if file_name:
            self.target_file_path = '%s%s%s' % (self.target_path, "\\", file_name[0])
            os.remove(self.target_file_path)


if __name__ == "__main__":
    pass
