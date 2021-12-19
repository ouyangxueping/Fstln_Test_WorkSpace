#coding=utf-8

import cv2
import cv2 as cv
import numpy as np
import win32clipboard as w
import win32api, win32gui, win32con, win32ui, struct
import time


class Image_Recognition():
    def __init__(self):
        self.Image_path = None

    def face_recognition(self, image_path):
        """人脸识别."""
        # rectangle color and stroke
        color = (0, 0, 255)       # reverse of RGB (B,G,R) - weird
        strokeWeight = 1        # thickness of outline

        # set window name
        windowName = "Press the Esc key to exit ... ..."

        # load an image to search for faces
        img = cv2.imread(image_path)

        # load detection file (various files for different views and uses)
        cascade = cv2.CascadeClassifier("face_alt_tree/haarcascade_frontalface_alt_tree.xml")

        # preprocessing, as suggested by: http://www.bytefish.de/wiki/opencv/object_detection
        # img_copy = cv2.resize(img, (img.shape[1]/2, img.shape[0]/2))
        # gray = cv2.cvtColor(img_copy, cv2.COLOR_BGR2GRAY)
        # gray = cv2.equalizeHist(gray)

        # detect objects, return as list
        rects = cascade.detectMultiScale(img)

        # display until escape key is hit
        while True:
            # get a list of rectangles
            for x, y, width, height in rects:
                cv2.rectangle(img, (x, y), (x + width, y + height), color, strokeWeight)

            # display!
            cv2.imshow(windowName, img)

            # escape key (ASCII 27) closes window
            if cv2.waitKey(0) == 27:
                break
        cv2.destroyAllWindows()

    def image_contrast(self, source_name, template_name, display_result=False, matching_value=2):
        """图像识别对比.识别模板图片在源图中的位置,若存在模板图片则返回模块图片在源图中的位置和模板图片大小.若不存在则断言提示

        参数：

        source_name：源图(待匹配目标图)

        template_name：模板图(用于在源图中去查找的已定义的图)

        display_result：是否显示匹配结果(匹配结果会弹窗显示5秒后自动关闭。默认为False.)

        matching_value: 匹配值，表示识别的匹配值必须达到这个值后才表示匹配 (默认2：表示2千万)

        返回：

        返回一个二维元组。第一个为模板图片在源图中的位置坐标(元组),第二个为模板图片本身的大小(元组)
        """

        events = [i for i in dir(cv2) if 'EVENT'in i]
        # print events

        source = cv.imread(source_name)
        template = cv.imread(template_name)
        value = float(matching_value) * 10000000

        W, H = cv.GetSize(source)
        w, h = cv.GetSize(template)
        width = W - w + 1
        height = H - h + 1
        result = cv.CreateImage((width, height), 32, 1)  #result是一个矩阵，用于存储模板与源图像每一帧相比较后的相似值
        cv.MatchTemplate(source, template, result, cv.CV_TM_SQDIFF) #从矩阵中找到相似值最小的点，从而定位出模板位置

        (min_x, max_y, minloc, maxloc) = cv.MinMaxLoc(result)
        (x, y) = minloc
        print (min_x, max_y, minloc, maxloc)

        assert (min_x < value), u"失败！！在源图中没有找到所匹配的图像... ..."  #min_x值超过了就表示不匹配

        cv.Rectangle(source, (int(x), int(y)), (int(x) + w, int(y) + h), (0, 0, 255), 2, 0) #use red rectangle to notify the target

        if display_result == "True":
            cv.ShowImage("result", source)
            cv.WaitKey(5000)

        cv.DestroyAllWindows()

        return minloc, (w, h)

    def click_contrasted_image(self, image_pos, image_size, x_offset_value=0, y_offset_value=97):
        """点击源图中特定位置上的匹配图片.

        参数：

        image_pos:图片在源图中的位置

        image_size：图片的大小

        x_offset_value：x轴误差值。默认为0

        y_offset_value：y轴误差值。默认为97 ,这里其实就是取的firefox浏览器的H 轴的窗口部分
        """
        w = image_size[0]
        h = image_size[1]

        x = image_pos[0] + int(x_offset_value) + w/2
        y = image_pos[1] + int(y_offset_value) + h/2
        pos = (x, y)
        print (u"点击的位置： ", pos)
        handle = win32gui.WindowFromPoint(pos)

        client_pos = win32gui.ScreenToClient(handle, pos)
        tmp = win32api.MAKELONG(client_pos[0], client_pos[1])
        win32gui.SendMessage(handle, win32con.WM_ACTIVATE, win32con.WA_ACTIVE, 0)
        time.sleep(0.5)
        win32gui.SendMessage(handle, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, tmp)
        time.sleep(0.5)
        win32gui.SendMessage(handle, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, tmp)
        # time.sleep(0.5)
        # win32api.SetCursorPos(pos)    #为鼠标焦点设定一个位置
        # time.sleep(0.5)
        # win32api.mouse_event(win32con.MOUSE_MOVED, x, y, 0, 0)
        # time.sleep(0.5)
        # win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
        # time.sleep(0.5)
        # win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)

    def drag_contrasted_image(self, image_pos, image_size, x_offset_value=0, y_offset_value=97):
        """拖拽源图中特定位置上的匹配图片.

        参数：

        image_pos:图片在源图中的位置

        image_size：图片的大小

        x_offset_value：x轴误差值。默认为0

        y_offset_value：y轴误差值。默认为97 ,这里其实就是取的firefox浏览器的H 轴的窗口部分
        """
        w = image_size[0]
        h = image_size[1]

        x = image_pos[0] + int(x_offset_value) + w/2
        y = image_pos[1] + int(y_offset_value) + h/2
        pos = (x, y)
        print (u"点击的位置： ", pos)

        handle = win32gui.WindowFromPoint(pos)
        client_pos = win32gui.ScreenToClient(handle, pos)
        tmp = win32api.MAKELONG(client_pos[0], client_pos[1])
        win32gui.SendMessage(handle, win32con.WM_ACTIVATE, win32con.WA_ACTIVE, 0)
        win32gui.SendMessage(handle, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, tmp)
        win32gui.SendMessage(handle, win32con.WM_MOUSEMOVE, win32con.MK_LBUTTON, y)
        win32gui.SendMessage(handle, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, tmp)

    def move_on_contrasted_image(self, image_pos, image_size, x_offset_value=0, y_offset_value=97):
        """移动到源图中特定位置上的匹配图片.

        参数：

        image_pos:图片在源图中的位置

        image_size：图片的大小

        x_offset_value：x轴误差值。默认为0

        y_offset_value：y轴误差值。默认为97 ,这里其实就是取的firefox浏览器的H 轴的窗口部分
        """
        w = image_size[0]
        h = image_size[1]

        x = image_pos[0] + int(x_offset_value) + w/2
        y = image_pos[1] + int(y_offset_value) + h/2
        pos1 = (0, y)
        pos2 = (x, y)
        print (u"移动的位置： ", pos1, pos2)
        self.click_contrasted_image(pos1, image_size)
        handle = win32gui.WindowFromPoint(pos2)
        client_pos = win32gui.ScreenToClient(handle, pos2)
        tmp = win32api.MAKELONG(client_pos[0], client_pos[1])
        # win32gui.SendMessage(handle, win32con.WM_MOUSEHOVER, None, tmp)
        win32gui.SendMessage(handle, win32con.WM_MOUSEMOVE, None, tmp)

    def wheel_on_contrasted_image(self, image_pos, image_size, x_offset_value=0, y_offset_value=97):
        """在源图中特定位置上的匹配图片上滚动鼠标.

        参数：

        image_pos:图片在源图中的位置

        image_size：图片的大小

        x_offset_value：x轴误差值。默认为0

        y_offset_value：y轴误差值。默认为97 ,这里其实就是取的firefox浏览器的H 轴的窗口部分
        """
        w = image_size[0]
        h = image_size[1]

        x = image_pos[0] + int(x_offset_value) + w/2
        y = image_pos[1] + int(y_offset_value) + h/2
        pos = (x, y)
        print (u"点击的位置： ", pos)
        win32api.SetCursorPos(pos)
        win32api.mouse_event(win32con.MOUSEEVENTF_WHEEL, 0, 0, 12000)

        # handle = win32gui.WindowFromPoint(pos)
        # client_pos = win32gui.ScreenToClient(handle, pos)
        # tmp = win32api.MAKELONG(client_pos[0], client_pos[1])

        # win32gui.SendMessage(handle, win32con.WM_MOUSEWHEEL, win32con.MK_LBUTTON, tmp)
        # win32gui.SendMessage(handle, win32con.WM_VSCROLL, win32con.SB_LINEDOWN)

    def Input_contrasted_text(self, image_pos, image_size, text="", x_offset_value=0, y_offset_value=97):
        """在源图中特定位置上的匹配图片内用键盘输入内容(先点击后输入).

        参数：

        image_pos:图片在源图中的位置

        image_size：图片的大小

        text：待输入的内容(默认为空)

        x_offset_value：x轴误差值。默认为0

        y_offset_value：y轴误差值。默认为97 ,这里其实就是取的firefox浏览器的H 轴的窗口部分
        """
        text = unicode(text).encode("gbk")
        self.click_contrasted_image(image_pos, image_size, x_offset_value, y_offset_value)
        self.__set_Clipboard_Text(text)

        #清空操作 ctrl + A  和 delete
        time.sleep(0.5)
        win32api.keybd_event(17, 0, 0, 0)  #ctrl键位码是17
        time.sleep(0.5)
        win32api.keybd_event(65, 0, 0, 0)  #a键位码是65
        time.sleep(0.5)
        win32api.keybd_event(65, 0, win32con.KEYEVENTF_KEYUP, 0)  #释放按键
        time.sleep(0.5)
        win32api.keybd_event(17, 0, win32con.KEYEVENTF_KEYUP, 0)
        time.sleep(0.5)
        win32api.keybd_event(46, 0, 0, 0)  #delete键位码是46
        time.sleep(0.5)
        win32api.keybd_event(46, 0, win32con.KEYEVENTF_KEYUP, 0)  #释放按键

        #ctrl + V
        time.sleep(0.5)
        win32api.keybd_event(17, 0, 0, 0)  #ctrl键位码是17
        time.sleep(0.5)
        win32api.keybd_event(86, 0, 0, 0)  #v键位码是86
        time.sleep(0.5)
        win32api.keybd_event(86, 0, win32con.KEYEVENTF_KEYUP, 0)  #释放按键
        time.sleep(0.5)
        win32api.keybd_event(17, 0, win32con.KEYEVENTF_KEYUP, 0)

    def windows_upload_file(self, file_path):
        """windows下非标准控件内上传文件。(需要先打开窗口)

        参数：

        file_path：文件路径
        """
        file_path = unicode(file_path).encode("gbk")

        uploadwindowname = u'文件上传'
        hn = win32gui.FindWindow('#32770', uploadwindowname)

        ComboBoxEx32 = win32gui.FindWindowEx(hn, None, "ComboBoxEx32", None)
        ComboBox = win32gui.FindWindowEx(ComboBoxEx32, None, "ComboBox", None)
        hn1 = win32gui.FindWindowEx(ComboBox, None, "Edit", None)
        hn2 = win32gui.FindWindowEx(hn, None, "Button", None)

        # print hn
        # print ComboBoxEx32
        # print ComboBox
        # print hn1
        # print hn2
        assert (ComboBox > 0), u"失败！！没有找到文件打开窗口... ..."
        win32gui.SendMessage(hn1, win32con.WM_SETTEXT, None, file_path)  #输入图片路径名称
        time.sleep(0.5)
        # win32gui.PostMessage(hn2, win32con.WM_KEYDOWN, win32con.VK_RETURN, 0)
        # win32gui.PostMessage(hn2, win32con.WM_KEYUP, win32con.VK_RETURN, 0)
        while True:
            try:
                win32gui.FindWindowEx(hn, None, "Button", None)
            except:
                break

            win32gui.SendMessage(hn2, win32con.WM_ACTIVATE, win32con.WA_ACTIVE, 0)
            time.sleep(0.5)
            win32gui.SendMessage(hn2, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, 0)
            time.sleep(0.5)
            win32gui.SendMessage(hn2, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, 0)

    def __click(self, handle, pos):
        client_pos = win32gui.ScreenToClient(handle, pos)
        tmp = win32api.MAKELONG(client_pos[0], client_pos[1])
        win32gui.SendMessage(handle, win32con.WM_ACTIVATE, win32con.WA_ACTIVE, 0)
        win32api.SendMessage(handle, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, tmp)
        win32api.SendMessage(handle, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, tmp)

    #获得鼠标位置
    def __get_curpos(self):
        return win32gui.GetCursorPos()

    #获得指定位置上的窗口
    def __get_win_handle(self, pos):
        return win32gui.WindowFromPoint(pos)

    #获得指定位置上的颜色
    def __get_color(self, pos):
        hdc_screen = win32gui.CreateDC("DISPLAY", "", None)
        hmem_dc = win32gui.CreateCompatibleDC(hdc_screen)
        h_bitmap = win32gui.CreateCompatibleBitmap(hdc_screen, 1, 1)
        h_old_bitmap = win32gui.SelectObject(hmem_dc, h_bitmap)
        win32gui.BitBlt(hmem_dc, 0, 0, 1, 1, hdc_screen, pos[0], pos[1], win32con.SRCCOPY)
        win32gui.DeleteDC(hdc_screen)
        win32gui.DeleteDC(hmem_dc)
        x = win32ui.CreateBitmapFromHandle(h_bitmap)
        bits = x.GetBitmapBits(True)

        return struct.unpack('I', bits)[0]

    #获取粘贴板内容
    def __get_Clipboard_Text(self):
        w.OpenClipboard()
        d = w.GetClipboardData(win32con.CF_TEXT)
        w.CloseClipboard()
        return d

    #设置粘贴板内容
    def __set_Clipboard_Text(self, aString):
        w.OpenClipboard()
        w.EmptyClipboard()
        w.SetClipboardData(win32con.CF_TEXT, aString)
        w.CloseClipboard()


if __name__ == "__main__":
    IR = Image_Recognition()
    result = IR.image_contrast("C:\\1.png", "C:\\2.png", "True")
    print (result)
