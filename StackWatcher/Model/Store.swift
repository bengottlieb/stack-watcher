//
//  Store.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/6/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit
import CoreData

class Store {
	var privateContext, mainQueueContext: NSManagedObjectContext
	
	init() {
		let path: NSString = "~/Documents/Questions.db".stringByExpandingTildeInPath
		let url = NSURL.fileURLWithPath(path)
		let model = NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("Model", withExtension: "momd"))
		var coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		var options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
		var error: NSError?
		
		coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error)
		
		privateContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
		privateContext.persistentStoreCoordinator = coordinator
		mainQueueContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
		mainQueueContext.persistentStoreCoordinator = coordinator
		
		NSNotificationCenter().addObserver(self, selector: "willMergeContextChanges", name: NSManagedObjectContextDidSaveNotification, object: nil)
	}
	
	func runClosureInContextQueue(closure: (moc: NSManagedObjectContext) -> ()) {
		self.privateContext.performBlock {
			closure(moc: self.privateContext)
		}
	}
	
	func willMergeContextChanges(note: NSNotification) {
		var moc = note.object as NSManagedObjectContext
		
		if moc == self.privateContext {
			dispatch_async(dispatch_get_main_queue()) {
				self.mainQueueContext.mergeChangesFromContextDidSaveNotification(note)
			}
		} else if moc == self.mainQueueContext {
			self.runClosureInContextQueue({(moc: NSManagedObjectContext) -> () in
				moc.mergeChangesFromContextDidSaveNotification(note)
			})
		}
	}

	class var DefaultStore: Store {
		get {
			struct singletonMetaData { static var instance: Store?; static var token: dispatch_once_t = 0 }
			dispatch_once(&singletonMetaData.token) { singletonMetaData.instance = Store() }
			return singletonMetaData.instance!
		}
	}
	
}
