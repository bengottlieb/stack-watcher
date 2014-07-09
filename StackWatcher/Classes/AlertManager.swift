//
//  AlertManager.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/5/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class AlertManager : NSObject, UIAlertViewDelegate {
	class var DefaultManager: AlertManager {
		get {
			struct singletonMetaData { static var instance: AlertManager?; static var token: dispatch_once_t = 0 }
			dispatch_once(&singletonMetaData.token) { singletonMetaData.instance = AlertManager() }
			return singletonMetaData.instance!
		}
	}

	var alertCompletionBlocks: Dictionary<Int, (buttonIndex: Int) -> ()> = [:]
	
	func showAlertTitled(title: NSString, message: NSString, buttonTitles: [String], completion: (buttonIndex: Int) -> () = {(buttonIndex: Int) -> () in }) {
		dispatch_async(dispatch_get_main_queue()) {
			var alertController: AnyClass? = NSClassFromString("UIAlertController")
			
			if let controller: AnyClass = alertController {
				var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
				
				for (index, title) in enumerate(buttonTitles) {
					alert.addAction(UIAlertAction(title: title, style: (index == 0) ? UIAlertActionStyle.Cancel :  UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) -> Void in
						completion(buttonIndex: index)
					}))
				}
				
				UIApplication.sharedApplication().delegate?.window?.rootViewController.presentViewController(alert, animated: true, completion: nil)
			} else {
				var alertView = UIAlertView()
				alertView.title = title
				alertView.message = message
				for button in buttonTitles {
					alertView.addButtonWithTitle(button)
				}
				alertView.cancelButtonIndex = 0
				alertView.tag = self.alertCompletionBlocks.count
				self.alertCompletionBlocks[alertView.tag] = completion
				
				alertView.delegate = self
				alertView.show()
			}
		}
	}
	
	func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
		self.alertCompletionBlocks[alertView.tag]?(buttonIndex: buttonIndex)
	}
}
