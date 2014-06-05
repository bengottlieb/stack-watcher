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
			struct singletonMetaData {
				static var instance: AlertManager?
				static var token: dispatch_once_t = 0
			}
			
			dispatch_once(&singletonMetaData.token) {
				singletonMetaData.instance = AlertManager()
			}
			
			return singletonMetaData.instance!
		}
	}

	var alertCompletionBlocks: Dictionary<Int, (buttonIndex: Int) -> ()> = [:]

	func showAlertTitled(title: NSString, message: NSString, buttonTitles: String[], completion: (buttonIndex: Int) -> () = {(buttonIndex: Int) -> () in }) {
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
		
		println("Alert delegate: \(alertView.delegate), blocks: \(self.alertCompletionBlocks)")
	}
	
	func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
		self.alertCompletionBlocks[alertView.tag]?(buttonIndex: buttonIndex)
	}
}




//			var alert = UIAlertController(title: "Not Authorized Yet", message: "You've not yet authorized with Stack Exchange. Would you like to do so now?", preferredStyle: .Alert)
//
//			alert.addAction(UIAlertAction(title: "Authorize", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) -> Void in
//				self.authenticate()
//				}))
//
//
//			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) -> Void in
//
//				}))
//
//			self.presentViewController(alert, animated: true, completion: nil)
