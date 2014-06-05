//
//  QuestionDetailsViewController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class QuestionDetailsViewController: UIViewController {
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
    init() {
        super.init(nibName: nil, bundle: nil)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reload")
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectQuestion:", name: StackInterface.DefaultInterface.questionSelectedNotificationName, object: nil)
        // Custom initialization
    }
	
	func reload() {
		self.webView.reload()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func didSelectQuestion(note: NSNotification) {
		var question = note.object as SEQuestion
		var link = question.link
		var url = NSURL(string: link)
		var request = NSURLRequest(URL: url)
		
		self.title = question.title
		self.webView.loadRequest(request)
	}

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

	@IBOutlet var webView : UIWebView
}
