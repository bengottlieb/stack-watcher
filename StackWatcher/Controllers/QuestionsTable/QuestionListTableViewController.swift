//
//  QuestionListTableViewController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class QuestionListTableViewController: UITableViewController {
	var questions: SEQuestion[]
	var searchTag = "swift-language"
	
    init() {
		questions = []
        super.init(style: UITableViewStyle.Plain)
		title = "Questions"
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "questionsUpdated:", name: StackInterface.DefaultInterface.questionsAvailableNotificationName, object: nil)
    }
	
	init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		questions = []
		super.init(nibName: nil, bundle: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if self.questions.count == 0 {
			self.updateQuestions()
		}
		
		self.tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
		self.tableView.rowHeight = 67
		//self.tableView.registerClass(QuestionTableViewCell.self, forCellReuseIdentifier: "cell")
		
//		self.tableView.registerClass(UITableViewCell(), forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	func updateQuestions() {
		if !StackInterface.DefaultInterface.isAuthorized { return }
		
		StackInterface.DefaultInterface.fetchQuestionsForTag(self.searchTag, completion: {(results: SEQuestion[], error: NSError?) -> Void in
				self.questions = results
				dispatch_async(dispatch_get_main_queue()) {
					self.tableView.reloadData()
				}
			})
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
		return self.questions.count
    }
	
	func questionsUpdated(note: NSNotification) {
		self.questions = note.object as SEQuestion[]
		dispatch_async(dispatch_get_main_queue()) {
			self.tableView.reloadData()
		}
		
	}

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
		let cell: QuestionTableViewCell = tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as QuestionTableViewCell
		let question = self.questions[indexPath!.row]
		
		
		cell.question = question
		
        return cell
    }

	override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		let question = self.questions[indexPath!.row]
		
		NSNotificationCenter.defaultCenter().postNotificationName(StackInterface.DefaultInterface.questionSelectedNotificationName, object: question)
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
