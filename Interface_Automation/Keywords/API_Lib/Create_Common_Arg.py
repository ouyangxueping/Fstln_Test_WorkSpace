#coding=utf-8

import hashlib
import json, simplejson
from robot.utils.dotdict import DotDict
from robot.utils.asserts import assert_true, assert_equal, assert_contains
from robot.api import logger
from api.GetApi import *
from api.GetDiffApi import *
from api.VerifyJson import *
from datetime import date
import sys, os, string, random, time
reload(sys)
sys.setdefaultencoding("gb2312")


class Create_Common_Arg():
    def __init__(self):
        self.verifyJson = VerifyJson()
        self.base_dir = None
        self.String_base = u"\u7684\u4e00\u4e86\u662f\u6211\u4e0d\u5728\u4eba\u4eec\u6709\u6765\u4ed6\u8fd9\u4e0a\u7740\u4e2a\u5730\u5230\u5927\u91cc\u8bf4\u5c31\u53bb\u5b50\u5f97" \
              u"\u4e5f\u548c\u90a3\u8981\u4e0b\u770b\u5929\u65f6\u8fc7\u51fa\u5c0f\u4e48\u8d77\u4f60\u90fd\u628a\u597d\u8fd8\u591a\u6ca1\u4e3a\u53c8\u53ef\u5bb6\u5b66" \
              u"\u53ea\u4ee5\u4e3b\u4f1a\u6837\u5e74\u60f3\u751f\u540c\u8001\u4e2d\u5341\u4ece\u81ea\u9762\u524d\u5934\u9053\u5b83\u540e\u7136\u8d70\u5f88\u50cf\u89c1" \
              u"\u4e24\u7528\u5979\u56fd\u52a8\u8fdb\u6210\u56de\u4ec0\u8fb9\u4f5c\u5bf9\u5f00\u800c\u5df1\u4e9b\u73b0\u5c71\u6c11\u5019\u7ecf\u53d1\u5de5\u5411\u4e8b" \
              u"\u547d\u7ed9\u957f\u6c34\u51e0\u4e49\u4e09\u58f0\u4e8e\u9ad8\u624b\u77e5\u7406\u773c\u5fd7\u70b9\u5fc3\u6218\u4e8c\u95ee\u4f46\u8eab\u65b9\u5b9e\u5403" \
              u"\u505a\u53eb\u5f53\u4f4f\u542c\u9769\u6253\u5462\u771f\u5168\u624d\u56db\u5df2\u6240\u654c\u4e4b\u6700\u5149\u4ea7\u60c5\u8def\u5206\u603b\u6761\u767d" \
              u"\u8bdd\u4e1c\u5e2d\u6b21\u4eb2\u5982\u88ab\u82b1\u53e3\u653e\u513f\u5e38\u6c14\u4e94\u7b2c\u4f7f\u5199\u519b\u5427\u6587\u8fd0\u518d\u679c\u600e\u5b9a" \
              u"\u8bb8\u5feb\u660e\u884c\u56e0\u522b\u98de\u5916\u6811\u7269\u6d3b\u90e8\u95e8\u65e0\u5f80\u8239\u671b\u65b0\u5e26\u961f\u5148\u529b\u5b8c\u5374\u7ad9" \
              u"\u4ee3\u5458\u673a\u66f4\u4e5d\u60a8\u6bcf\u98ce\u7ea7\u8ddf\u7b11\u554a\u5b69\u4e07\u5c11\u76f4\u610f\u591c\u6bd4\u9636\u8fde\u8f66\u91cd\u4fbf\u6597" \
              u"\u9a6c\u54ea\u5316\u592a\u6307\u53d8\u793e\u4f3c\u58eb\u8005\u5e72\u77f3\u6ee1\u65e5\u51b3\u767e\u539f\u62ff\u7fa4\u7a76\u5404\u516d\u672c\u601d\u89e3" \
              u"\u7acb\u6cb3\u6751\u516b\u96be\u65e9\u8bba\u5417\u6839\u5171\u8ba9\u76f8\u7814\u4eca\u5176\u4e66\u5750\u63a5\u5e94\u5173\u4fe1\u89c9\u6b65\u53cd\u5904" \
              u"\u8bb0\u5c06\u5343\u627e\u4e89\u9886\u6216\u5e08\u7ed3\u5757\u8dd1\u8c01\u8349\u8d8a\u5b57\u52a0\u811a\u7d27\u7231\u7b49\u4e60\u9635\u6015\u6708\u9752" \
              u"\u534a\u706b\u6cd5\u9898\u5efa\u8d76\u4f4d\u5531\u6d77\u4e03\u5973\u4efb\u4ef6\u611f\u51c6\u5f20\u56e2\u5c4b\u79bb\u8272\u8138\u7247\u79d1\u5012\u775b" \
              u"\u5229\u4e16\u521a\u4e14\u7531\u9001\u5207\u661f\u5bfc\u665a\u8868\u591f\u6574\u8ba4\u54cd\u96ea\u6d41\u672a\u573a\u8be5\u5e76\u5e95\u6df1\u523b\u5e73" \
              u"\u4f1f\u5fd9\u63d0\u786e\u8fd1\u4eae\u8f7b\u8bb2\u519c\u53e4\u9ed1\u544a\u754c\u62c9\u540d\u5440\u571f\u6e05\u9633\u7167\u529e\u53f2\u6539\u5386\u8f6c" \
              u"\u753b\u9020\u5634\u6b64\u6cbb\u5317\u5fc5\u670d\u96e8\u7a7f\u5185\u8bc6\u9a8c\u4f20\u4e1a\u83dc\u722c\u7761\u5174\u5f62\u91cf\u54b1\u89c2\u82e6\u4f53" \
              u"\u4f17\u901a\u51b2\u5408\u7834\u53cb\u5ea6\u672f\u996d\u516c\u65c1\u623f\u6781\u5357\u67aa\u8bfb\u6c99\u5c81\u7ebf\u91ce\u575a\u7a7a\u6536\u7b97\u81f3" \
              u"\u653f\u57ce\u52b3\u843d\u94b1\u7279\u56f4\u5f1f\u80dc\u6559\u70ed\u5c55\u5305\u6b4c\u7c7b\u6e10\u5f3a\u6570\u4e61\u547c\u6027\u97f3\u7b54\u54e5\u9645" \
              u"\u65e7\u795e\u5ea7\u7ae0\u5e2e\u5566\u53d7\u7cfb\u4ee4\u8df3\u975e\u4f55\u725b\u53d6\u5165\u5cb8\u6562\u6389\u5ffd\u79cd\u88c5\u9876\u6025\u6797\u505c" \
              u"\u606f\u53e5\u533a\u8863\u822c\u62a5\u53f6\u538b\u6162\u53d4\u80cc\u7ec6"

    def Get_api(self, tag=""):
        """抓取API列表,并保存至接口测试项目的 TestData 目录。

        参数：

        tag：表示生成api列表标记，如果tag为空则表示生成原始api文件(Api_List.txt)，否则，则生成新的最近测试的api文件(Api_List_New.txt)。
        """
        api1 = GetApi(tag)
        api1.get_api_data()
        d2 = datetime.datetime.now()
        time = d2 - api1.startData
        if time.seconds != 0:
            print("%s %s%s" % (u"耗时：", time.seconds, u"秒"))
        else:
            print("%s %s%s" % (u"耗时：", time.microseconds / 1000, u"毫秒"))

    def Get_DiffApi(self):
        """将最近一次获取的API列表与原始API列表做比较。生成对比的差异列表文件(Diff_Api_List.txt)。
        """
        g = GetDiffApi()
        result = g.write_diff_file()
        return result

    def iterate_json(self, json_data):
        """
        解析json并返回对应的key|value

        参数：

        json_data: json数据源

        返回:

        json各字段以及字段类型
        """
        return self.verifyJson.iterate_json(json_data)

    def diff_verify_json(self, api_name, result_json_body):
        """
        校验两个json格式的相似度

        参数：

        api_name: 接口名称(关键字会使用该名称去取出在[Input_TXT_Files]文件夹下的该名称文件内的json部分作为预期json)

        result_json_body: 结果相应的json
        """
        return self.verifyJson.diff_verify_json(api_name, result_json_body)

    def Create_Common_Arg(self, data, filename):
        """创建并保存公共参数文件.(文件路径已固定)
        """

        self.base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + "\\Resource\\"

        with open(self.base_dir + filename, 'w') as f:
            f.write(json.dumps(data, sort_keys=True, indent=4, separators=(',', ': '), ensure_ascii=False).encode("utf-8"))

        print u"公共参数文件创建成功！"

    def Read_joson_content(self, filename):
        """
        从公共参数文件中读取json字符串。(文件路径已固定)

        :param

        filename: json文件名

        :return: json字符串
        """
        self.base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + "\\Resource\\"
        json_content = open(self.base_dir + filename).read().decode("utf-8")

        print u"公共参数文件内容读取成功！"
        return json_content

    def Validate_input_parameters(self, Validate_type="P", *paremeters):
        """
        【主要功能】：

        1、用于验证输入参数的字典中是否包含特定字符，如果有则返回具体的匹配到的某个输入参数。(一个变量去匹配一个或多个字符)

        2、用于验证输入参数的数据类型是否符合接口规范。（提供的参数为单个数据）（可选的数据类型有 Int32、Int64）

        3、用于验证的输入参数的组合条件下的返回,可以简化【预期结果】与【实际结果】验证时的验证条件。(一个或多个变量去匹配一个字符)

        【参数】：

        Validate_type：表示验证类型，大写P：表示验证混合参数的【与运算】或【或运算】结果. 大写V：表示验证参数字典中各个key值【是否为空】. 大写S：表示验证参数的数据类型是否符合接口规范。

        paremeters：参数集(不同的 Validate_type值，参数集的长度不同，请参考详细备注说明)

        备注：

        当 Validate_type="P" 时，需提供额外三个参数，1、提供运算类型 "AND" 或 "OR"  2、提供待验证的数值. 3、待验证的变量(一个或多个)

        当 Validate_type="S",需提供额外两个参数，既：1、待验证的变量(一个) 2、被测接口规范中定义的数据类型

        当 Validate_type="V" 时，需提供额外两个参数，1、待验证的变量 2、提供待验证的数值(一个或多个).

        【返回值】：

        1、返回具体匹配到的某个或某些输入参数，且返回True 或者 False

        2、返回接口数据是否符合规范的结果，True 或者 False

        3、返回【与运算】或【或运算】后的组合结果，且返回True 或者 False

        【例子】：

        | ${status} | Validate Input Parameters | S | ${userId} | Int32 |

         表示：验证提供的输入参数是否为 Int32 类型数据。如果参数为整型且符合整型取值范围，则返回True，否则返回False。

         | ${status} | Validate Input Parameters | P | AND | ${EMPTY} | ${userId} | ${shopId} | ${VideoId} |

         表示：验证提供的输入参数中必须都为空时才返回 True ，否则返回False。

         | ${status} | Validate Input Parameters | V | ${data} | ${EMPTY} |

         表示：验证提供的输入参数字典中是否包含空值.有则返回具体的字典参数名，且返回True。没有则返回False。
        """
        if Validate_type == "P":
            #将输入参数转换下类型，这样数组内就全为字符型，方便比较
            paremeters_list = []
            for i in range(0, len(paremeters[2:])):
                paremeters_list.append(str(paremeters[2:][i]))

            if paremeters[0] == "OR":
                for par in paremeters_list:
                    # 只要验证的值有一个与输入参数相符，就为真
                    if par == paremeters[1]:
                        status = True
                        break
                    else:
                        status = False

            elif paremeters[0] == "AND":   #如果运算类型为 and 。并且要验证的值存在于 输入参数内
                for par in paremeters_list:
                    if par != paremeters[1]:
                        status = False
                        break
                    else:
                        status = True

            print u"验证输入参数值的有效性，最后返回为： %s" % bool(status)
            return bool(status)

        elif Validate_type == "V":
            key_list = []
            par_list = []
            status = False

            for j in range(1, len(paremeters)):
                par_list.append(paremeters[j])

            if type(paremeters[0]) != DotDict and type(paremeters[0]) != dict:
                if paremeters[0] in par_list:
                    status = True
                    print u"接口输入参数变量中存在非法的参数，关键字返回 %s ！" % status
                    return status
                else:
                    print u"接口输入参数变量中不存在非法的参数，关键字返回 %s ！" % status
                    return status

            else:
                for i in range(len(paremeters[0])):
                    if paremeters[0].values()[i] in par_list:
                        status = True
                        key_list.append(paremeters[0].keys()[i])
                    else:
                        pass

            if status:
                print u"接口输入参数字典中存在非法的参数，其中非法的输入参数有：%s。关键字返回 %s ！" % (key_list, status)
            else:
                print u"接口输入参数字典中不存在非法的参数。关键字返回 %s !" % status

            return key_list, status

        elif Validate_type == "S":
            if paremeters[0] == "":   #如果提供的值为空直接返回 False
                return False

            if paremeters[1] == "Int32":
                if type(paremeters[0]) != int and type(paremeters[0]) != long and type(paremeters[0]) != unicode:
                    print u"待校验的输入参数为非整型！"
                    return False
                else:
                    if -2147483648 <= int(paremeters[0]) <= 2147483647:
                        return True
                    else:
                        print u"待校验的输入参数整型超出范围！"
                        return False

            elif paremeters[1] == "Int64":
                if type(paremeters[0]) != int and type(paremeters[0]) != long and type(paremeters[0]) != unicode:
                    print u"待校验的输入参数为非整型！"
                    return False
                else:
                    if -9223372036854775808 <= int(paremeters[0]) <= 9223372036854775807:
                        return True
                    else:
                        print u"待校验的输入参数整型超出范围！"
                        return False
            elif paremeters[1] == "List":
                if type(paremeters[0]) != list:
                    print u"待校验的输入参数为非列表类型！"
                    return False
                else:
                    return True
            else:
                print u"不支持你所提供的数据类型校验！提示：数据类型：Int32、Int64、List 其中的一种！"

        else:
            return u"提供的参数有误，请检查... ... 提示：大写P：表示验证混合参数的与运算结果，大写V：表示验证参数字典中各个key值是否为空！"

    def Validate_output_results(self, responsedata, results, *output):
        """
        【【【------------------------------当了个当！！只支持最多【三个】输入条件因子的验证，超过三个会变得很复杂！----------------------------------】】】

        【主要功能】：

        1、以正交匹配的方式，在给出特定的输入参数条件因子的前提下，验证预期结果与实际结果是否一致。

        【参数】：

        responsedata: 服务器响应的内容。分别对应Message或者Success值的实际结果

        results: 自定义的验证列表。分别对应Message或者Success值的预期结果

        output: 提供的待校验的输入参数的真假值 (必须为bool类型)。

        验证的顺序为: 【真】、【假】（请记住：results参数必须以这个顺序为基础来给定。）

        验证的顺序为: 【真--真】、【真--假】、【假--真】、【假--假】

        验证的顺序为: 【真--真--真】、【真--假--真】、【真--真--假】、【真--假--假】、【假--真--真】、【假--假--真】、【假--真--假】、【假--假--假】

        【返回值】：

        无

        【例子】：

        | Validate Output Results | ${Message} | ${list} | ${check_input} | ${status} |

        """
        assert_true(len(output) <= 3, u"Sorry!暂时最多只支持【三个】输入参数的验证！")
        assert_true(type(results) == list, u"第二个参数必须为列表list类型！")

        for par in output:
            assert_true(type(par) == bool, u"提供的待验证的输入参数必须为bool类型！")

        '''全量组合参数匹配方法，好像不行
        from itertools import product
        count = 0
        validate_list = []

        for x in range(len(output)):
            T_str = "Result%d-True" % (x + 1)
            F_str = "Result%d-False" % (x + 1)
            tmp = [T_str, F_str]
            validate_list.append(tmp)
        # print validate_list
        # validate_list = [["Result1-True", "Result1-False"], ["Result2-True", "Result2-False"], ["Result3-True", "Result3-False"]]
        for i in product(*(v_l for v_l in validate_list)):
            print i
            assert_equal(str(responsedata), results[count], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
            count += 1
        '''
        if len(output) == 0:
            """
            真
            """
            print u"【真】"
            assert_equal(str(responsedata), results[0], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
        elif len(output) == 1:
            """真
               假
            """
            if output[0]:
                print u"【真】"
                assert_equal(str(responsedata), results[0], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
            else:
                print u"【假】"
                assert_equal(str(responsedata), results[1], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
        elif len(output) == 2:
            """真-真
               真-假
               假-真
               假-假
            """
            if output[0] and output[1]:
                print u"【真--真】"
                assert_equal(str(responsedata), results[0], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
            elif output[0] and not output[1]:
                print u"【真--假】"
                assert_equal(str(responsedata), results[1], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
            elif not output[0] and output[1]:
                print u"【假--真】"
                assert_equal(str(responsedata), results[2], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")
            elif not output[0] and not output[1]:
                print u"【假--假】"
                assert_equal(str(responsedata), results[3], u"响应内容与预期结果不一致，验证失败！请检查原因... ...")

        elif len(output) == 3:
            """ 真	真	真
                真	假	真
                真	真	假
                真	假	假
                假	真	真
                假	假	真
                假	真	假
                假	假	假
            """
            if output[0] and output[1] and output[2]:
                print u"【真--真--真】"
                assert_equal(str(responsedata), results[0], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif output[0] and not output[1] and output[2]:
                print u"【真--假--真】"
                assert_equal(str(responsedata), results[1], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif output[0] and output[1] and not output[2]:
                print u"【真--真--假】"
                assert_equal(str(responsedata), results[2], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif output[0] and not output[1] and not output[2]:
                print u"【真--假--假】"
                assert_equal(str(responsedata), results[3], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif not output[0] and output[1] and output[2]:
                print u"【假--真--真】"
                assert_equal(str(responsedata), results[4], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif not output[0] and not output[1] and output[2]:
                print u"【假--假--真】"
                assert_equal(str(responsedata), results[5], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif not output[0] and output[1] and not output[2]:
                print u"【假--真--假】"
                assert_equal(str(responsedata), results[6], u"响应内容与预期结果不一致，验证失败！出错原因")
            elif not output[0] and not output[1] and not output[2]:
                print u"【假--假--假】"
                assert_equal(str(responsedata), results[7], u"响应内容与预期结果不一致，验证失败！出错原因")
        else:
            return u"Sorry!暂时最多只支持三个输入参数的验证！你提供的参数有误，请检查... ... （提示：responsedata：表示实际结果 results：表示预期结果！）"

    def format_string(self, string):
        """
        格式化字符串，去掉 \\r \\n  空格后，返回处理后的字符串。
        """
        result_string = string.strip('\r').strip('\n').strip('\r\n')
        return result_string.replace(" ", "")

    def split_string(self, string, split_string, num):
        """切割字符串。返回切割后的所需特定的字符串。

        参数：

        string： 原始待切割的字符串

        split_string：从哪个字符串开始切割

        num：取切割后的字符串列表下标（如:0 表示切割后的第一个字符串）
        """
        result_string = str(string).split(split_string)
        if len(result_string) > 1:
            return result_string[int(num)]
        else:
            return result_string[0]

    def concate_string(self, *args):
        """拼接字符串。返回拼接后的字符串
        """
        result_string = ""
        for i in range(len(args)):
            result_string += args[i]

        return result_string

    def replace_string(self, string, replace_string, to_string):
        """用特定字符来替换字符串某个字符。返回替换后的字符串。

        参数：

        string： 原始待替换的字符串

        replace_string：替换原字符串中的哪个字符

        to_string：将待替换的字符替换成哪个字符
        """
        return str(string).replace(str(replace_string), str(to_string))

    def create_password_DB_str(self, password, salt_str):
        """通过用户密码和加盐字符串生成加密后的MD5密码字符串。（该关键字可以用于比较数据库内存储的加密后密码字符串和加密前密码字符串是否一致）

        参数:

        password: 原始密码字符串

        salt_str：加盐字符串。（可以取来自数据库内的用来比较）

        返回：

        加盐后的md5值密码字符串。
        """
        data = str(password)
        salt = str(salt_str)

        hash_md5 = hashlib.md5(data)
        md5_str = hash_md5.hexdigest()

        #加盐字符串后再次加密
        hash_md5 = hashlib.md5(md5_str + salt)
        return hash_md5.hexdigest()

    def Get_range_number_string(self, MinNum, MaxNum):
        """获得一个自定义范围内的随机数字字符串.

        MinNum：范围段的最小值

        MaxNum: 范围段的最大值

        Example:
        | ${num}= | Get Range Number String | 4 | 40 |
        返回一个在4和40之间范围内的随机数字字符串.
        """
        s = random.randint(int(MinNum), int(MaxNum))
        print u"得到随机字符串： %s" % s
        return str(s)

    def Get_random_number_string(self, counts):
        """获得一个自定义位数的随机数字字符串.

        counts：待获取的字符串位数

        Example:
        | ${a}= | Get Random Number String | 4 |
        返回一组参数中定义位数的随机数字字符串. 如： '2624','1456'.
        """
        li = string.digits
        s = ''
        for n in range(0, int(counts)):
            s += li[random.randint(0, len(li) - 1)]
        print u"得到随机字符串： %s" % s
        return s

    def Get_random_character_string(self, counts, upper='M'):
        """获得一组自定义位数的随机字母字符串.

        counts：待获取的字符串位数

        upper：表示取大小写（默认大小写混合） U：大写 L：小写 M：大小写混合

        Example:
        | ${a}= | Get Random Character String | 4 | U |
        返回一组参数中定义位数的随机字母字符串. 如： 'ABCD','HJHK'.
        """
        s = ''
        li = ''

        if upper.upper() == 'U':
            li = string.ascii_uppercase
            lenli = len(li)
        elif upper.upper() == 'L':
            li = string.ascii_lowercase
            lenli = len(li)
        elif upper.upper() == 'M':
            li = string.ascii_letters
            lenli = len(li)
        else:
            pass
            print(u'逗逼！没有这种类型的字母！: %s' % upper.upper())
            return
        for n in range(0, int(counts)):
            s += li[random.randint(0, lenli - 1)]
        print u"得到随机字符串： %s" % s
        return s

    def Get_random_chinese_string(self, counts):
        """获得一组自定义位数的随机汉字.

        counts：待获取的汉字位数

        Example:
        | ${a}= | Get Random Chinese String | 4 |
        返回一组参数中定义位数的随机汉字.
        """
        string = ""
        #基础为固定常用汉字
        for n in range(0, int(counts)):
            string += self.String_base[random.randint(0, len(self.String_base) - 1)]
        #基础为全部汉字
        # for n in range(0, int(counts)):
        #     string += self._GB2312()

        print u'得到随机汉字: %s' % string
        return string

    def Get_random_choice_number(self, sequence, count=1):
        """从序列中获取指定个数的随机元素(默认随机取1个).参数sequence表示一个有序类型(dict、list、tuple、字符串都属于).
        """
        return_list = []
        par_type = type(sequence)   #参数类型
        par_len = len(sequence)    #参数长度
        # print par_type

        if int(count) > 1:
            if par_type == list:
                if par_len == 0:
                    print u"随机种子为空！返回NULL ..."
                    return "Null"
                else:
                    temp_list = []
                    for i in range(0, int(count)):
                        temp_list.append(random.choice(sequence))
                        return_list.append(temp_list[i][0])
                    print u"得到包含多个随机数的列表： %s" % return_list
                    return return_list

            if par_type == DotDict or par_type == dict:
                print u"随机种子是个字典！"
                for k, v in zip(sequence.iterkeys(), sequence.itervalues()):
                    print '%s:%s' % (k, v)
                    return_list.append(v)

                return random.choice(return_list)

        else:
            if par_type == DotDict or par_type == dict:
                print u"随机种子是个字典！"
                for k, v in zip(sequence.iterkeys(), sequence.itervalues()):
                    print '%s:%s' % (k, v)
                    return_list.append(v)
                return random.choice(return_list)

            if par_type == list:
                if par_len == 0:
                    print u"随机种子为空！返回NULL ..."
                    return "Null"
                else:
                    str = random.choice(sequence)
                    print u"得到一个随机数： %s" % str
                    return str

    def Get_random_idcard_string(self, len=18, minAge=20, maxAge=50):
        """
        随机生成一个身份证号字符串。

        len: 身份证的位数 (身份证的位数一般为 15位、17位、18位这三种)

        minAge:给定一个年龄段的最小值

        maxAge:给定一个年龄段的最大值

        Example:
        | ${id_card}= | Get Random Idcard String | 18 | 20 | 50 |
        返回一个年龄在20岁到50岁之间的18位的身份证号.
        """
        idcard = str(random.randint(1, 9)) + self._get_random_nums(5) + self._get_random_birthday(int(minAge), int(maxAge)) + self._get_random_nums(3)
        # print idcard
        idcard_list = list(idcard)
        temp = 0
        for nn in range(2, 19):
            a = int(idcard_list[18 - nn])
            w = (2 ** (nn - 1)) % 11
            temp += a * w

        temp = (12 - temp % 11) % 11
        if temp >= 0 and temp <= 9:
            idcard += str(temp)
        elif temp == 10:
            idcard += 'X'

        return str(idcard)

    def Get_unix_time(self):
        """
        返回当前时间,用unix表示。
        """
        times = time.time()
        times = str(times).split(".")[0] + "000"
        return times

    def _GB2312(self):
        str1 = self._hex()
        try:
            str2 = str1.decode('hex').decode('gb2312')
        except UnicodeDecodeError:
            #如果出错则重新生成一个汉字
            str1 = self._hex()
            try:
                str2 = str1.decode('hex').decode('gb2312')
            except UnicodeDecodeError:
                #如果还是报错，那就指定一个汉字
                str2 = u'安'
        return str2

    def _hex(self):
        head = random.randint(0xB0, 0xCF)
        body = random.randint(0xA, 0xF)
        if body == 0xF:
            tail = random.randint(0, 0xE)
        else:
            tail = random.randint(0, 0xF)
        val = (head << 8) | (body << 4) | tail
        str1 = "%x" % val
        return str1

    def _get_random_nums(self, counts):
        li = string.digits
        s = ''
        for n in range(0, int(counts)):
            s += li[random.randint(0, len(li) - 1)]
        return s

    def _get_random_birthday(self, minAge, maxAge, sep=''):
        now = date.today()
        #print now
        birth = now.year - int(minAge)
        mon = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']
        mon_days = ['31', '28', '31', '30', '31', '30', '31', '31', '30', '31', '30', '31']
        s = ''
        age = int(maxAge) - int(minAge)
        y = str(birth - random.randint(1, age))
        index1 = random.randint(0, 11)
        m = str(mon[index1])
        m = m.zfill(2)
        maxDay = int(mon_days[index1])
        d = str(random.randint(1, maxDay))
        d = d.zfill(2)
        s = y + sep + m + sep + d
        return s


if __name__ == "__main__":
    app = Create_Common_Arg()
    app.Get_DiffApi()



