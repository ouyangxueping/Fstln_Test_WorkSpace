#coding=utf-8

from PIL import Image
import requests
from robot.utils.asserts import assert_true
import sys, os, base64
reload(sys)
sys.setdefaultencoding("gb2312")


class Image_Operation():
    def __init__(self):
        self.Image_path = None

    def Get_image_StreamString(self, image_file_path):
        """
        返回图片流。

        :param image_file_path:图片路径

        :return: 返回图片流
        """
        self.Image_path = image_file_path

        #img = Image.open(image_path)
        img = base64.b64encode(open(self.Image_path, "rb").read())

        return img

    def Get_image_Object(self, image_file_path):
        """
        返回图片对象。

        :param image_file_path:图片路径

        :return: 返回图片对象
        """
        self.Image_path = image_file_path

        img_obj = Image.open(self.Image_path)

        return img_obj

    def get_url_photo_str(self, url):
        '''参数为图片的网络地址

        例:
        ${data}=  | Get Url Photo Str | ${url} |
        '''
        return base64.b64encode(requests.get(url).content)

    def get_path_photo_str(self, path):
        '''参数为图片的本地地址

        例:
        ${data}=  | Get Path Photo Str | ${path} |
        '''
        with open(path, "rb") as image_file:
            encode_str = base64.b64encode(image_file.read())

        return encode_str

    def path_url_check(self, path, url):
        '''参数为图片的本地地址和网络地址，然后将两者的base64编码进行比较，如果一致就表示两个图片一样

        例:
        | Path Url Check | ${path} | ${url} |
        '''
        assert_true(self._path_url_check(path, url), u"本地图片和URL图片不一致！！")

    def url_url_check(self, url1, url2):
        '''参数为两个图片的网络地址，然后将两者的base64编码进行比较，如果一致就表示两个图片一样

        例:
        | Url Url Check | ${url1} | ${url2} |
        '''
        assert_true(self._url_url_check(url1, url2), u"两个URL图片不相同！！")

    def _url_url_check(self, url1, url2):
        '''网络图片比较
        '''
        return True if self.get_url_photo_str(url1) == self.get_url_photo_str(url2) \
            else False

    def _path_url_check(self, path, url):
        '''本地图片和网络图片比较
        '''
        return True if self.get_path_photo_str(path) == self.get_url_photo_str(url) \
            else False

#
# if __name__ == "__main__":
#     app = Image_Operation()
#     print app.Get_image_Object("test.png")

