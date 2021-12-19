#!/usr/bin/python
#coding=utf-8

import sys, os
import utils.GlobalList
from api.Fiddler2RFScript import TXT2RFScript
from api.FiddlerAddSession import AddSession
from api.FiddlerRemoveSession import RemoveSession


class Fiddler(object):
    def __init__(self):
        self.ApitxtFile = os.path.dirname(os.path.abspath(__file__)) + "\\fiddler_sessions\\Input_TXT_Files"
        self.RFScriptFilePath = os.path.dirname(os.path.abspath(__file__)) + "\\fiddler_sessions\\Output_RF_Files"
        self.AddSession_source_file = os.path.dirname(os.path.abspath(__file__)) + "\\fiddler_sessions\\AddSession.txt"
        self.RemoveSession_source_file = os.path.dirname(os.path.abspath(__file__)) + "\\fiddler_sessions\\RemoveSession.txt"

        if not os.path.isdir(self.ApitxtFile):
            os.mkdir(self.ApitxtFile)
        if not os.path.isdir(self.RFScriptFilePath):
            os.mkdir(self.RFScriptFilePath)

    def GenerateRFScript(self):
        txt_converter = TXT2RFScript(self.ApitxtFile, self.RFScriptFilePath)
        txt_converter.GenerateRFScript()

    def AddSession(self):
        session = AddSession(self.AddSession_source_file, self.ApitxtFile)
        session.append_session_file()

    def RemoveSession(self):
        session = RemoveSession(self.RemoveSession_source_file, self.ApitxtFile)
        session.remove_session_file()


if __name__ == "__main__":
    Fiddler_OP = Fiddler()
    if len(sys.argv) == 2:
        if sys.argv[1] == "1":
            Fiddler_OP.GenerateRFScript()
        elif sys.argv[1] == "2":
            Fiddler_OP.AddSession()
        elif sys.argv[1] == "3":
            Fiddler_OP.RemoveSession()
    else:
        Fiddler_OP.GenerateRFScript()
