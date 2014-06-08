//
//  AppDelegate.swift
//  StackWatcher Mac
//
//  Created by Ben Gottlieb on 6/8/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
	@IBOutlet var window: NSWindow
	
	var authController: AuthorizationController?

	func applicationDidFinishLaunching(aNotification: NSNotification?) {
		authController = AuthorizationController.controllerToPresentURL(StackInterface.DefaultInterface.authorizationURL)
		
		
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification?) {
		// Insert code here to tear down your application
	}


}

