#coding=utf-8

from ReadAndWriteExcel import ReadAndWriteExcel
import os
import csv
import sys
# reload(sys)
# sys.setdefaultencoding('gb2312')

# print sys.argv
# print sys.argv[-1]
# print "yes"
# dirpath = os.path.dirname(os.path.abspath(__file__)) + "\\"
print sys.argv[-1] + "\\接口自动化测试子系统\\TestData\\Web_Test_Data\\user_login.csv"
dirpath = sys.argv[-1] + "\\接口自动化测试子系统\\TestData\\Web_Test_Data\\user_login.csv"
# print dirpath
file1 = open(dirpath, "rb")
reader = csv.reader(file1)

# Excel_data = ReadAndWriteExcel()
# Excel_data.Set_ExcelPath(dirpath + "Excel_Data.xlsx")
# print Excel_data.Get_columnCount_By_SheetName("Sheet1")
# print Excel_data.Get_RowCount_By_SheetName("Sheet1")
# print Excel_data.Get_RowIndexData_By_SheetName("Sheet1", 3)[6]

username = []
passwd = []
row_count = 0

for row in reader:
    print row
    if reader.line_num == 1:
        continue
    username.append(unicode(row[5]))
    passwd.append(unicode(row[6]))
    row_count += 1


       





