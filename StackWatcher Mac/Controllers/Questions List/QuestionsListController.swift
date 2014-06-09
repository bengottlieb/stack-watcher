//
//  QuestionsListController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/9/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Cocoa
import WebKit

class QuestionsListController: NSWindowController, NSTableViewDataSource {
	@IBOutlet var webView: WebView
	@IBOutlet var splitView: NSSplitView
	@IBOutlet var questionsTable: NSTableView
	var fetchRequest = NSFetchRequest(entityName: "PostedQuestion")
	
	var questions = []
	var searchTag = "swift-language"
	
	
	class func controller() -> (QuestionsListController) {
		var controller = QuestionsListController(windowNibName: "QuestionsListController")
		
		controller.fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "last_activity_date", ascending: false) ]
		
		controller.showWindow(nil)
		
		controller.window.makeKeyAndOrderFront(nil)
		NSNotificationCenter.defaultCenter().addObserver(controller, selector: "updateQuestions", name: StackInterface.DefaultInterface.didAuthenticateNotificationName, object: nil)

		return controller
	}
	
	override func windowWillLoad()  {
		self.updateQuestions()
	}
	
}

extension QuestionsListController {
	func updateQuestions() {
		if !StackInterface.DefaultInterface.isAuthorized {
			(NSApplication.sharedApplication().delegate as AppDelegate).promptForAuthorization()
			return
		}
		
		StackInterface.DefaultInterface.fetchQuestionsForTag(self.searchTag, completion: {(error: NSError?) -> Void in
			dispatch_async(dispatch_get_main_queue()) {
				var error: NSError?
				
				self.questions = Store.DefaultStore.mainQueueContext.executeFetchRequest(self.fetchRequest, error: &error)
				self.reloadQuestions()
			}
		})
	}
	
	func reloadQuestions() {
		
	}
}

extension QuestionsListController {
	func numberOfRowsInTableView(tableView: NSTableView!) -> Int { println("\(self.questions.count) questions found"); return self.questions.count }
	
}