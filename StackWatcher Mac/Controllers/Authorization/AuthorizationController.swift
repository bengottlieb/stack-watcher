//
//  AuthorizationController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/8/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Cocoa
import WebKit

class AuthorizationController: NSWindowController {
	@IBOutlet var webview : WebView
	var initialURL: NSURL?
	
	
	class func controllerToPresentURL(URL: NSURL) -> (AuthorizationController) {
		var controller = AuthorizationController(windowNibName: "AuthorizationController")
		
		controller.initialURL = URL
		controller.showWindow(nil)
		
		controller.window.makeKeyAndOrderFront(nil)
		return controller
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()
		
		self.webview.mainFrameURL = self.initialURL?.absoluteString
		
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
