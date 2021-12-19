#coding=utf-8

"""
接口全局文件
"""

import ConfigParser, os, re


class ConfigIni():
    def __init__(self):
        self.path = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + "\\Global_Config.ini"
        
        content = open(self.path).read()
        """
        #Window下用记事本打开配置文件并修改保存后，编码为UNICODE或UTF-8的文件的文件头  
         会被相应的加上\xff\xfe（\xff\xfe）或\xef\xbb\xbf，然后再传递给ConfigParser解析的时候会出错，因此解析之前，先替换掉 
        """
        content = re.sub(r"\xfe\xff", "", content)
        content = re.sub(r"\xff\xfe", "", content)
        content = re.sub(r"\xef\xbb\xbf", "", content)
        open(self.path, 'w').write(content)
        
        self.cf = ConfigParser.ConfigParser()

        self.cf.read(self.path)

    def get_ini(self, title, value):
        return self.cf.get(title, value)

    def set_ini(self, title, value, text):
        self.cf.set(title, value, text)
        return self.cf.write(open(self.path, "wb"))

    def add_ini(self, title):
        self.cf.add_section(title)
        return self.cf.write(open(self.path, "wb"))

    def get_options(self, data):
        # 获取所有的section
        options = self.cf.options(data)
        return options


if __name__ == "__main__":
    pass
