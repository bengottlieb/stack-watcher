//
//  QuestionsListController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/9/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Cocoa
import WebKit

class QuestionsListController: NSWindowController {
	@IBOutlet var webView: WebView
	@IBOutlet var splitView: NSSplitView
	
	
	class func controller() -> (QuestionsListController) {
		var controller = QuestionsListController(windowNibName: "QuestionsListController")
		
		controller.showWindow(nil)
		
		controller.window.makeKeyAndOrderFront(nil)
		
		return controller
	}
	
}
