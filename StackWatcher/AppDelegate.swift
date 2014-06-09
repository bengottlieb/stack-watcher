//
//  AppDelegate.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
	var window: UIWindow?
	

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		// Override point for customization after application launch.
		self.window!.backgroundColor = UIColor.whiteColor()
		
		
		
		if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
			self.window!.rootViewController = MainController()
		} else {
			self.window!.rootViewController = UINavigationController(rootViewController: QuestionListTableViewController(nibName: nil, bundle: nil))
		}
		self.window!.makeKeyAndVisible()
		
		self.promptForAuthorization()
		
		return true
	}
	@IBAction func reauthorize(sender : AnyObject) {
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
	}

	var showingAuthorizationPrompt = false
	func promptForAuthorization() {
		if self.showingAuthorizationPrompt { return }
		
		if (!StackInterface.DefaultInterface.isAuthorized) {
			self.showingAuthorizationPrompt = true
			if StackInterface.DefaultInterface.clientKey == "" {
				AlertManager.DefaultManager.showAlertTitled("No Client Key Set", message: "Make sure you get an API key from api.stackexchange.com, and set it as your Client Key before trying to use this application.", buttonTitles: [  ])
			} else {
				AlertManager.DefaultManager.showAlertTitled("Not Authorized Yet", message: "You've not yet authorized with Stack Exchange. Would you like to do so now?", buttonTitles: [ "Cancel", "Authorize" ], completion: {(buttonIndex: Int) -> () in
					if buttonIndex == 1 {
						self.authenticate()
					}
					self.showingAuthorizationPrompt = false
				})
			}
		}
	}
	
	@IBAction func authenticate() {
		if (StackInterface.DefaultInterface.isAuthorized) {
			AlertManager.DefaultManager.showAlertTitled("Already Authorized", message: "You've already authorized with Stack Exchange.", buttonTitles: [ "OK" ])
		} else {
			let auth = AuthorizationViewController(URL: StackInterface.DefaultInterface.authorizationURL)
			let nav = UINavigationController(rootViewController: auth)
			nav.modalPresentationStyle = .PageSheet
			
			self.window?.rootViewController.presentViewController(nav, animated: true, completion: nil)
		}
	}
	
	
}

