//
//  StackWatcher.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Foundation

class StackInterface {
	class var DefaultInterface: StackInterface {
		get {
			struct singletonMetaData { static var instance: StackInterface?; static var token: dispatch_once_t = 0 }
			dispatch_once(&singletonMetaData.token) { singletonMetaData.instance = StackInterface() }
			return singletonMetaData.instance!
		}
	}
	
	init() {
		if let token = NSUserDefaults.standardUserDefaults().stringForKey(self.authTokenKey) {
			self.authToken = token
			println("Authorized with token \(token)")
		} else {
			self.authToken = ""
		}
	}
	
	let clientId = "3091"
	let authTokenKey = "auth-token"
	let validationURI = "https://stackexchange.com/oauth/login_success"
	let clientKey = ""
	let site = "stackoverflow.com"
	let apiVersion = "2.2"
	
	let didAuthenticateNotificationName = "didAuthenticateNotificationName"
	let questionsAvailableNotificationName = "questionsAvailableNotificationName"
	let questionSelectedNotificationName = "questionSelectedNotificationName"
	
	var isAuthorized : Bool { return self.authToken != "" }
	
	var authToken : String {
		willSet  {
			var def = NSUserDefaults.standardUserDefaults()
			def.setObject(newValue, forKey: self.authTokenKey)
			def.synchronize()
		}
	}
	
	var authorizationURL : NSURL { return NSURL.URLWithString("https://stackexchange.com/oauth/dialog?client_id=\(self.clientId)&scope=no_expiry&redirect_uri=\(validationURI)") }
	
	var session : NSURLSession?
	
	func generateSession() -> NSURLSession {
		if let internalSession = self.session {
			return internalSession
		}
		
		var config = NSURLSessionConfiguration.defaultSessionConfiguration()
		self.session = NSURLSession(configuration: config)
		return self.session!
	}
	
	func validateAuthorizationURLRequest(request: NSURLRequest) -> Bool {
		if (request.URL.absoluteString.hasPrefix(self.validationURI)) {
			
			return true
		}
		return false
	}
	
	
	func unanswerURLForTag(tag: String, from: NSDate) -> NSURL {
		var	string = "http://api.stackexchange.com/\(self.apiVersion)/questions/unanswered?fromdate=\(from.stackExchangeDateString)&order=desc&sort=activity&tagged=\(tag)&site=\(self.site)&key=\(self.clientKey)"
		return NSURL(string: string)
	}
	
	func fetchQuestionsForTag(tag: String, completion: (results: SEQuestion[], error: NSError?) -> Void) {
		var url = self.unanswerURLForTag(tag, from: NSDate())
		var task = self.generateSession().dataTaskWithURL(url, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
			var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary

			var	questions = SEQuestion[]()
			
			for item in dict["items"] as NSDictionary[] {
				var question = SEQuestion(dictionary: item)
				questions.append(question)
			}
			
			var note = NSNotification(name: self.questionsAvailableNotificationName, object: questions as AnyObject)
			
			completion(results: questions, error:  nil)
		})
		task.resume()
	}
}



extension NSDate {
	var stackExchangeDateString: String {
		
		return "1401840000"
	}
}
