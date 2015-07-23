//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by Dennis Nguyen on 7/22/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let mainWindowController = MainWindowController()
        mainWindowController.showWindow(self)
        
        self.mainWindowController = mainWindowController
    }
}

