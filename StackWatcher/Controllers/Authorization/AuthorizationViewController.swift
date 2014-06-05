//
//  AuthorizationViewController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet var webView : UIWebView
	
	let initialURL: NSURL?
	
	init(URL: NSURL) {
		self.initialURL = URL
		
		super.init(nibName: nil, bundle: nil)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
		self.navigationItem.title = "Authorize Stack Exchange"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

		self.webView.loadRequest(NSURLRequest(URL: self.initialURL))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
		if (StackInterface.DefaultInterface.validateAuthorizationURLRequest(request)) {
			let fragComponents = request.URL.fragment?.componentsSeparatedByString("=") as Array?
			
			if fragComponents?.count >= 2 {
				StackInterface.DefaultInterface.authToken = fragComponents![1] as String
				self.dismissViewControllerAnimated(true, completion: nil)
				
			}
		}
		
		return true
	}
	func cancel() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
