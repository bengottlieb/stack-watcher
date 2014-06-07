//
//  QuestionListTableViewController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit
import CoreData

class QuestionListTableViewController: UITableViewController {
	var questions: PostedQuestion[]
	var searchTag = "swift-language"
	
	init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		questions = []
		super.init(nibName: nil, bundle: nil)
		title = "Questions"
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateQuestions", name: StackInterface.DefaultInterface.didAuthenticateNotificationName, object: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: "updateQuestions", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refreshControl)
		
		if self.questions.count == 0 {
			self.updateQuestions()
		}
		
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
		
		var error: NSErrorPointer = nil
		self.questions = Store.DefaultStore.mainQueueContext.executeFetchRequest(request, error: error) as PostedQuestion[]
		
		self.tableView.reloadData()
	}
	
    // #pragma mark - Table view data source ----------------------------------------------------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int { return 1 }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int { return self.questions.count }

	override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
		let cell: QuestionTableViewCell = tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as QuestionTableViewCell
		let question = self.questions[indexPath!.row]
		
		
		cell.question = question
		
        return cell
    }

	override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		let question = self.questions[indexPath!.row]
		
		if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
			NSNotificationCenter.defaultCenter().postNotificationName(StackInterface.DefaultInterface.questionSelectedNotificationName, object: question)
		} else {
			self.navigationController.pushViewController(QuestionDetailsViewController(question: question), animated: true)
		}
	}
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
