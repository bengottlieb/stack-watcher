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
	
	override func webView(webView: WebView, didStartProvisionalLoadForFrame frame: WebFrame) {
		var request = frame.provisionalDataSource.request
		
		if (StackInterface.DefaultInterface.validateAuthorizationURLRequest(request)) {
			let fragComponents = request.URL.fragment?.componentsSeparatedByString("=") as Array?
			
			if fragComponents?.count >= 2 {
				StackInterface.DefaultInterface.authToken = fragComponents![1] as String
				self.close()
				NSNotificationCenter.defaultCenter().postNotificationName(StackInterface.DefaultInterface.didAuthenticateNotificationName, object: nil)
			}
		}

	}
	
	func windowWillClose(note: NSNotification) {
		(NSApplication.sharedApplication().delegate as AppDelegate).showingAuthorizationPrompt = false
	}
}
