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
	var hideMasterList = false
	
	init() {
		super.init(nibName: nil, bundle: nil)
		viewControllers = [ UINavigationController(rootViewController: masterController), UINavigationController(rootViewController: detailController) ]

		self.detailController.navigationItem.rightBarButtonItems = self.rightButtons
		
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
	
	func toggleMasterList() {
		self.hideMasterList = !self.hideMasterList
		self.delegate = nil
		self.delegate = self
		self.view.setNeedsLayout()
		self.willRotateToInterfaceOrientation(UIApplication.sharedApplication().statusBarOrientation, duration: 1)
		self.detailController.navigationItem.rightBarButtonItems = self.rightButtons
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
		self.detailController.navigationItem.rightBarButtonItems = self.rightButtons
	}
	
	func splitViewController(svc: UISplitViewController!, shouldHideViewController vc: UIViewController!, inOrientation orientation: UIInterfaceOrientation) -> Bool {
		
		if (vc == self.masterController.navigationController) {
			if self.hideMasterList { return true }
			if UIInterfaceOrientationIsPortrait(orientation) { return true }
		}
		return false
	}
	
	var rightButtons: UIBarButtonItem[] {
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) { return [ self.detailController.reloadButton ] }
		return [ self.detailController.reloadButton, self.expandButton ]
	}

	var expandButton: UIBarButtonItem {
		var imageName = self.hideMasterList ? "show_tabs" : "hide_tabs"
		
		return UIBarButtonItem(title: self.hideMasterList ? ">" : "<", style: .Bordered, target: self, action: "toggleMasterList")
//			return UIBarButtonItem(image: UIImage(named: imageName), style: .Bordered, target: self, action: "toggleMasterList")
	}
}
