
//
//  StackWatcher.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreData

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
		
		if let date: NSDate = NSUserDefaults.standardUserDefaults().objectForKey(self.lastCheckedDateKey) as? NSDate {
			self.lastCheckDate = date
		} else {
			let cal = NSCalendar.currentCalendar()
			var comp = cal.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate: NSDate())
			
			comp.hour = 0
			comp.minute = 0
			comp.second = 0
			self.lastCheckDate = cal.dateFromComponents(comp)
		}
	}
	
	let clientId = "3091"
	let authTokenKey = "auth-token"
	let lastCheckedDateKey = "last-check"
	let validationURI = "https://stackexchange.com/oauth/login_success"
	let clientKey = "ajLLBq1xNwKq7SZY3MZ0Zw(("
	let site = "stackoverflow.com"
	let apiVersion = "2.2"
	
	let didAuthenticateNotificationName = "didAuthenticateNotificationName"
	let questionsAvailableNotificationName = "questionsAvailableNotificationName"
	let questionSelectedNotificationName = "questionSelectedNotificationName"
	
	var isAuthorized : Bool { return self.authToken != "" }
	func resetAuthorization() {
		self.authToken = ""
		
		var url = NSURL.URLWithString("https://stackexchange.com")
		var jar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
		var cookies = jar.cookiesForURL(url)
		
		for cookie in (cookies as [NSHTTPCookie]) {
			jar.deleteCookie(cookie)
		}
	}
	
	var authToken : String {
		willSet  {
			var def = NSUserDefaults.standardUserDefaults()
			def.setObject(newValue, forKey: self.authTokenKey)
			def.synchronize()
		}
	}
	
	var authorizationURL : NSURL { return NSURL.URLWithString("https://stackexchange.com/oauth/dialog?client_id=\(self.clientId)&scope=no_expiry&redirect_uri=\(validationURI)") }
	
	var lastCheckDate: NSDate
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
		var	string = "http://api.stackexchange.com/\(self.apiVersion)/questions/unanswered?fromdate=\(from.stackExchangeDateString())&order=desc&sort=activity&tagged=\(tag)&site=\(self.site)&key=\(self.clientKey)"
		return NSURL(string: string)
	}
	
	func fetchQuestionsForTag(tag: String, completion: (error: NSError?) -> Void) {
		let date = self.lastCheckDate
		
		var url = self.unanswerURLForTag(tag, from: date)
		var task = self.generateSession().dataTaskWithURL(url, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
			Store.DefaultStore.runClosureInContextQueue({ (moc: NSManagedObjectContext) -> () in
				var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
				
				if let errorNumber = dict["error_id"] as? NSNumber {
					var name = dict["error_name"] as? NSString
					var message = dict["error_message"] as? NSString
					var title = "\(name): \(message)"
					
					AlertManager.DefaultManager.showAlertTitled(title, message: "", buttonTitles: [ "OK "])
					return
				}
				
				var	questions = [PostedQuestion]()
				
				for item in dict["items"] as [NSDictionary] {
					var question = PostedQuestion.questionFromDictionary(item, inContext: moc)
					questions.append(question)
				}
				println("Downloaded \(questions.count) new questions (from \(date) onward)")
				
				var error: NSError?
				if !moc.save(&error) {
					AlertManager.DefaultManager.showAlertTitled("Failed to save", message: error!.localizedDescription, buttonTitles: [ "OK "])
				}
				var note = NSNotification(name: self.questionsAvailableNotificationName, object: nil)
				
				self.lastCheckDate = NSDate()
				NSUserDefaults.standardUserDefaults().setObject(self.lastCheckDate, forKey: self.lastCheckedDateKey)
				NSUserDefaults.standardUserDefaults().synchronize()

				completion(error:  nil)
			})
		})
		task.resume()
	}
}



extension NSDate {
	func stackExchangeDateString() -> String {
		var seconds = Int(self.timeIntervalSince1970)
		return "\(seconds)"
	}
}
