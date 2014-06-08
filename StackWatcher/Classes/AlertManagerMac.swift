//
//  AlertManagerMac.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/8/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Foundation

class AlertManager : NSObject {
	class var DefaultManager: AlertManager {
		get {
			struct singletonMetaData { static var instance: AlertManager?; static var token: dispatch_once_t = 0 }
			dispatch_once(&singletonMetaData.token) { singletonMetaData.instance = AlertManager() }
			return singletonMetaData.instance!
		}
	}
	
	func showAlertTitled(title: NSString, message: NSString, buttonTitles: String[], completion: (buttonIndex: Int) -> () = {(buttonIndex: Int) -> () in }) {
		
	}
}