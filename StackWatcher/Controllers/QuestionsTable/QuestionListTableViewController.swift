//
//  QuestionListTableViewController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit
import CoreData

class QuestionListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	//var questions: PostedQuestion[]
	var searchTag = "swift-language"
	var fetchRequest = NSFetchRequest(entityName: "PostedQuestion")
	var fetchedResultsController: NSFetchedResultsController?
	
	init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		//questions = []
		
		
		super.init(nibName: nil, bundle: nil)
		title = "Questions"
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateQuestions", name: StackInterface.DefaultInterface.didAuthenticateNotificationName, object: nil)
	
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "last_activity_date", ascending: false) ]
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Store.DefaultStore.mainQueueContext, sectionNameKeyPath: nil, cacheName: "Questions")
		fetchedResultsController!.performFetch(nil)
		fetchedResultsController!.delegate = self
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: "updateQuestions", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refreshControl)
		self.updateQuestions()
		
		self.tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
		self.tableView.rowHeight = 67
    }

	func updateQuestions() {
		if !StackInterface.DefaultInterface.isAuthorized {
			(UIApplication.sharedApplication().delegate as AppDelegate).promptForAuthorization()
			return
		}
		
		self.refreshControl.beginRefreshing()
		StackInterface.DefaultInterface.fetchQuestionsForTag(self.searchTag, completion: {(error: NSError?) -> Void in
				dispatch_async(dispatch_get_main_queue()) {
					self.refreshControl.endRefreshing()
					self.reloadQuestions()
				}
			})
	}
	
	func reloadQuestions() {
		var request = NSFetchRequest(entityName: "PostedQuestion")
		
		//var error: NSError?
		//self.questions = Store.DefaultStore.mainQueueContext.executeFetchRequest(request, error: error) as PostedQuestion[]
		
		self.tableView.reloadData()
	}
	
    // #pragma mark - Table view data source ----------------------------------------------------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
		if let controller = self.fetchedResultsController {
			return controller.sections.count }
		return 0
	}

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
		if let controller = self.fetchedResultsController {
			return controller.sections[section].numberOfObjects }
		return 0
	}

	override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
		let question = self.fetchedResultsController!.objectAtIndexPath(indexPath) as PostedQuestion
		let cell: QuestionTableViewCell = tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as QuestionTableViewCell
		
		
		cell.question = question
		
        return cell
    }

	override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		let question = self.fetchedResultsController!.objectAtIndexPath(indexPath) as PostedQuestion
		
		if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
			NSNotificationCenter.defaultCenter().postNotificationName(StackInterface.DefaultInterface.questionSelectedNotificationName, object: question)
		} else {
			self.navigationController.pushViewController(QuestionDetailsViewController(question: question), animated: true)
		}
	}
}

extension QuestionListTableViewController : NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(controller: NSFetchedResultsController!) { self.tableView.beginUpdates() }
	
	func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
		switch type {
			case NSFetchedResultsChangeInsert:
				self.tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation: .Top)
				
			case NSFetchedResultsChangeDelete:
				self.tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: .Top)
				
			case NSFetchedResultsChangeMove:
				self.tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
				
			case NSFetchedResultsChangeUpdate:
				self.tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .None)
				
			default:
				break
		}
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController!) { self.tableView.endUpdates() }
	

	
}
