#coding=utf-8

import os
import utils.GlobalList
from robot.api import logger


class GetDiffApi(object):

    def __init__(self):
        """
        初始化
        """
        Config = utils.GlobalList.ConfigIni()
        self.api_path = '%s%s' % (Config.get_ini("Directory_Path_Name", "root_path"), os.path.sep + "Api_List.txt")
        self.session_path = '%s%s' % (Config.get_ini("Directory_Path_Name", "root_path"), os.path.sep + "Api_List_New.txt")
        self.dif_path = '%s%s' % (Config.get_ini("Directory_Path_Name", "root_path"), os.path.sep + "Diff_Api_List.txt")

        self.api_path = unicode(self.api_path, "utf-8")
        self.session_path = unicode(self.session_path, "utf-8")
        self.dif_path = unicode(self.dif_path, "utf-8")

    def __get_api(self, path):
        """
        从本地获取api列表
        :return:
        """
        if os.path.exists(path):
            l = open(path).readlines()
            return (index.replace("\n", "") for index in l)

    def __get_sessions_api(self):
        """
        从本地获取已经请求过的sessions
        :return:
        """
        for root, dirs, files in os.walk(self.session_path):
            return (f.split(".")[0] for f in files)

    def __get_diff_api(self):
        """
        求diff
        :return:
        """
        api = self.__get_api(self.api_path)
        assert (api), u"失败！！未找到 Api_List.txt 文件！... ...{}".format(self.api_path)
        sessions_api = self.__get_api(self.session_path)
        assert (sessions_api), u"失败！！未找到 Api_List_New.txt 文件！... ...{}".format(self.session_path)

        return list(set(sessions_api).symmetric_difference(set(api)))

    def write_diff_file(self):
        """
        diff写入文件
        :return: True 或者 False
        """
        d = self.__get_diff_api()
        if len(d) != 0:
            logger.info(u"\t\n注意: 检查到API列表有改动... ... 详情请查看 {} 文件！\t\n".format(self.dif_path))
            with open(self.dif_path, 'w') as f:
                for i in d:
                    f.write(i)
                    f.write("\r\n")
            return False
        else:
            logger.info(u"\t\nAPI接口对比信息相同，没有发现有API改动！\t\n")
            return True


if __name__ == "__main__":
    g = GetDiffApi()
    print g.write_diff_file()
