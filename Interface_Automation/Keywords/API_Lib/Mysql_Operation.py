#coding=utf-8

import sys, os
reload(sys)
sys.setdefaultencoding("gb2312")


class Mysql_Operation():

    def Get_SQL_Path(self):
        BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + "\\Resource\\Sql"
        print u"SQL文件路径设置成功！"
        return BASE_DIR
