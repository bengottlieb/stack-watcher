//
//  MainViewController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIWebViewDelegate {
	var naggedAboutAuth: Bool
	let table = QuestionListTableViewController()
	
	init() {
		self.naggedAboutAuth = false
		super.init(nibName: nil, bundle: nil)
		self.addChildViewController(self.table)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.table.view.frame = self.view.bounds
		self.view.addSubview(self.table.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if (!StackInterface.DefaultInterface.isAuthorized) && !self.naggedAboutAuth {
			AlertManager.DefaultManager.showAlertTitled("Not Authorized Yet", message: "You've not yet authorized with Stack Exchange. Would you like to do so now?", buttonTitles: [ "Cancel", "Authorize" ], completion: {(buttonIndex: Int) -> () in
				if buttonIndex == 1 {
					self.authenticate()
				}
			})
			self.naggedAboutAuth = true
		}

	}
	
	

	var webView: UIWebView?
	
	@IBAction func authenticate() {
		if (StackInterface.DefaultInterface.isAuthorized) {
			AlertManager.DefaultManager.showAlertTitled("Already Authorized", message: "You've already authorized with Stack Exchange.", buttonTitles: [ "OK" ])
			
//			var alert = UIAlertController(title: "Already Authorized", message: "You've already authorized with Stack Exchange.", preferredStyle: .Alert)
//
//			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) -> Void in
//				
//				}))
//			self.presentViewController(alert, animated: true, completion: nil)
		} else {
			let auth = AuthorizationViewController(URL: StackInterface.DefaultInterface.authorizationURL)
			let nav = UINavigationController(rootViewController: auth)
			self.presentViewController(nav, animated: true, completion: nil)
		}
	}
	
	
	//-----------------
}
