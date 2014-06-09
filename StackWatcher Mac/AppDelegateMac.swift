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
	@IBOutlet var reauthorizeItem: NSMenuItem
	
	var authController: AuthorizationController?

	func applicationDidFinishLaunching(aNotification: NSNotification?) {
		self.promptForAuthorization()
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification?) {
		// Insert code here to tear down your application
	}

	var showingAuthorizationPrompt = false
	
	@IBAction func reauthorize(sender: AnyObject?) {
		StackInterface.DefaultInterface.resetAuthorization()
		self.promptForAuthorization()
	}
	
	override func validateMenuItem(menuItem: NSMenuItem!) -> Bool {
		if menuItem == self.reauthorizeItem { return !self.showingAuthorizationPrompt }
		return super.validateMenuItem(menuItem)
	}
}

extension AppDelegate {
	func promptForAuthorization() {
		if self.showingAuthorizationPrompt { return }
		
		if (!StackInterface.DefaultInterface.isAuthorized) {
			self.showingAuthorizationPrompt = true
			authController = AuthorizationController.controllerToPresentURL(StackInterface.DefaultInterface.authorizationURL)
		}
	}
	
}
