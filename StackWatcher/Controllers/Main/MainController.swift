//
//  MainController.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/5/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class MainController: UISplitViewController, UISplitViewControllerDelegate {
	var detailController = QuestionDetailsViewController()
	var masterController = QuestionListTableViewController(nibName: nil, bundle: nil)
	
	init() {
		super.init(nibName: nil, bundle: nil)
		viewControllers = [ UINavigationController(rootViewController: masterController), UINavigationController(rootViewController: detailController) ]

		self.delegate = self
		//self.detailController.navigationItem.leftBarButtonItem = self.displayModeButtonItem()
	}

	func splitViewController(svc: UISplitViewController!, willHideViewController aViewController: UIViewController!, withBarButtonItem barButtonItem: UIBarButtonItem!, forPopoverController pc: UIPopoverController!) {
		self.detailController.navigationItem.leftBarButtonItem = barButtonItem
	}
	
	func splitViewController(svc: UISplitViewController!, willShowViewController aViewController: UIViewController!, invalidatingBarButtonItem barButtonItem: UIBarButtonItem!) {
		if aViewController == masterController.navigationController {
			self.detailController.navigationItem.leftBarButtonItem = nil
		}
	}

}
