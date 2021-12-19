#coding=utf-8

"""
从指定url拉取api存入本地
"""
import urllib
import lxml.html as HTML
import re, os
import datetime
import utils.GlobalList


class GetApi(object):

    def __init__(self, tag=""):
        """
        初始化
        """
        print(u"正在连接指定网址......")
        if tag != "":
            self.tag = "_New"
        else:
            self.tag = ""
        Config = utils.GlobalList.ConfigIni()
        self.startData = datetime.datetime.now()
        self.HelpUrl = Config.get_ini("URL_Config", "API_Help_URL")
        self.Url = Config.get_ini("URL_Config", "API_URL")
        self.path = '%s%s%s%s' % (Config.get_ini("Directory_Path_Name", "root_path"), os.path.sep + "Api_List", self.tag, ".txt")

    def __get_html(self, url):
        """
        获得指定url的html
        :return: 返回一个byte流html
        """
        return urllib.urlopen(url).read()

    def __get_api_des_url(self):
        """
        获得指定api的详细信息的url
        :return: 返回列表
        """
        api = self.__get_api()
        index_temp = []
        for index in api:
            index_temp.append(index[0])

        return index_temp

    def __get_api_des(self):
        """
        通过正则表达式匹配相应的接口详情
        :return: 返回一个匹配后的接口详情字典
        """
        des = {}
        api_des_url = self.__get_api_des_url()
        api_des_html = self.__get_html(self.Url + api_des_url[0])   #暂时取了第一个, 还未实现

        reg_parameter_name = re.compile(r'<td class="parameter-name">(.+?)</td>')
        reg_parameter_documentation = re.compile(r'<td class="parameter-documentation"><p><b>(.+?)</b></p></td>')

        des = {"parameter_name": re.findall(reg_parameter_name, api_des_html.decode('utf-8')),
               "parameter_documentation": re.findall(reg_parameter_documentation, api_des_html.decode('utf-8')),
               }
        return des

    def __get_api_category(self):
        """
        通过url 取得url下的html元素，再根据xpath定位分类和分类下对应的api
        :return: 返回一个分类对应分类下api的字典
        """
        api_category_dic = {}
        rep = urllib.urlopen(self.HelpUrl)
        htree = HTML.parse(rep)
        category_xpath_list = htree.xpath('//h2')
        print(u"接口类别和分类下对应的api拉取成功")
        for i in range(len(category_xpath_list)):
            api_category_list = []

            api_xpath_list = htree.xpath('//h2[@id="{}"]/following::table[1]//a'.format(category_xpath_list[i].text_content()))
            for j in range(len(api_xpath_list)):
                api_category_list.append(api_xpath_list[j].text_content())

            temp_dict = {category_xpath_list[i].text_content(): api_category_list}
            api_category_dic.update(temp_dict)

        return api_category_dic

    def __get_api(self):
        """
        通过正则表达式匹配相应的接口
        :return: 返回一个匹配后的接口列表
        """
        html = self.__get_html(self.HelpUrl)
        print(u"接口拉取成功")
        reg = re.compile(r'<a href="(.+?)">(.+?)</a>')
        return re.findall(reg, html.decode('utf-8'))

    def __remove_deprecated_api(self):
        """
        移除一些过期的接口
        :return: 返回一个客户端正在使用的接口列表
        """
        api = self.__clear_api()
        print(u"移除过期接口......")
        return (index for index in api if index[1].find(u"已取消") == -1 and index[0].find(u"已取消") == -1
                and index[1].find(u"XMPP") == -1 and index[0].find(u"已不用") == -1 and index[0].find(u"已失效") == -1
                and index[1].find(u"废弃") == -1)

    def __clear_api(self):
        """
        去除部分匹配出来是非接口的数据
        :return: 返回一个真正的接口列表，里面包含过期接口，需要进一步移除
        """
        api = self.__get_api()

        print(u"接口清洗中......")
        # return (index for index in api if index[0].startswith(utils.GlobalList.API_URL.split('Help')[-1]))
        # return (index for index in api if index[-1].split(" ")[-1])
        index_temp = []
        for index in api:
            index_temp.append(index[-1])
        return index_temp

    def __write_file(self, path):
        """
        接口数据写入文件
        :return:
        """
        path = unicode(path, "utf-8")
        # api = self.__remove_deprecated_api()
        api = self.__clear_api()

        print(u"接口数据写入文件中......")
        with open(path, 'w') as f:
            for i in api:
                f.write(i)
                f.write("\n")
        print(u"接口数据写入成功")

    def get_api_data(self):
        """
        暴露的外部接口，从服务器拉取接口数据
        :return:
        """
        print(u"接口拉取中......")
        self.__write_file(self.path)

    def get_api_des_data(self):
        """
        获得每个api的详细信息数据
        :return:
        """
        api_des = self.__get_api_des()

        print api_des

    def get_api_category_data(self):
        """
        获得api的类别
        :return:
        """
        api_category = self.__get_api_category()

        return api_category


if __name__ == "__main__":
    pass


