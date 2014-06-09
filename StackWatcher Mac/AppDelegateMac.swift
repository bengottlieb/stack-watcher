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
	var questionsList: QuestionsListController?

	func applicationDidFinishLaunching(aNotification: NSNotification?) {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didAuthorize", name: StackInterface.DefaultInterface.didAuthenticateNotificationName, object: nil)
		if !self.promptForAuthorization() { self.showQuestionsWindow() }
		
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification?) {
		// Insert code here to tear down your application
	}
	
	@IBAction func reauthorize(sender: AnyObject?) {
		StackInterface.DefaultInterface.resetAuthorization()
		self.promptForAuthorization()
	}
	
	override func validateMenuItem(menuItem: NSMenuItem!) -> Bool {
		if menuItem == self.reauthorizeItem { return self.authController == nil }
		return super.validateMenuItem(menuItem)
	}
}

extension AppDelegate {
	func showQuestionsWindow() {
		if let list = self.questionsList {
			list.window.makeKeyAndOrderFront(nil)
		} else {
			self.questionsList = QuestionsListController.controller()
		}
	}
}

extension AppDelegate {
	func promptForAuthorization() -> Bool {
		if (!StackInterface.DefaultInterface.isAuthorized) {
			if let controller = self.authController {
				controller.window.makeKeyAndOrderFront(nil)
			} else {
				authController = AuthorizationController.controllerToPresentURL(StackInterface.DefaultInterface.authorizationURL)
			}
			self.questionsList?.window.close()
			return true
		}
		return false
	}
	
	func didAuthorize() {
		self.showQuestionsWindow()
	}
}
