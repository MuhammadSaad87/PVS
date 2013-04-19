#!/usr/bin/env python
#
# -*- encoding: utf-8 -*-
#
# generated by wxGlade HG on Wed Jul 18 14:54:33 2012
#

# This is the main entry point of the editor.

import wx, os.path, sys
from ui.frame import MainFrame
import util
import logging
import constants
import platform

log = util.getLogger(__name__)

class PVSEditorApp(wx.App):
    """The main class that starts the application and shows the main frame"""
    
    def OnInit(self):
        #wx.InitAllImageHandlers()
        self.mainFrame = MainFrame(None, wx.ID_ANY, "")
        self.SetTopWindow(self.mainFrame)
        self.mainFrame.Show()
        log.info("Editor initialized...") 
        return 1

# end of class PVSEditorApp

def processArguments(args):
    log.info("Command Line Arguments: %s", args)
    del args[0]
    for arg in args:
        if arg.startswith(constants.INPUT_LOGGER):
            logLevel = arg[len(constants.INPUT_LOGGER):]
            if logLevel == constants.LOG_LEVEL_DEBUG:
                constants.LOGGER_LEVEL = logging.DEBUG
            elif logLevel == constants.LOG_LEVEL_DEBUG:
                constants.LOGGER_LEVEL = logging.FATAL
            

if __name__ == "__main__":
    print sys.maxint
    utilDirectory = os.path.dirname(util.__file__)
    constants.APPLICATION_FOLDER = os.path.abspath(os.path.join(utilDirectory, os.path.pardir))
    constants.IMAGE_FOLDER_PATH = os.path.join(constants.APPLICATION_FOLDER, constants.IMAGE_FOLDER_NAME)
    log.debug("Application Folder is %s", constants.APPLICATION_FOLDER)
    processArguments(list(sys.argv))

    system = platform.system()
    if system == "Windows":
        print "This application is not designed for Windows"
        sys.exit()
    
    util.editor = PVSEditorApp(0)
    log.info("Entering MainLoop...") 
    util.editor.MainLoop()
