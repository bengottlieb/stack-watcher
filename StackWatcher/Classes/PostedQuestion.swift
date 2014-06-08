//
//  PostedQuestion.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreData

class PostedQuestion : NSManagedObject {
	
	@NSManaged var title, link, tagsList: NSString
	@NSManaged var answer_count, view_count, score: NSNumber;
	@NSManaged var question_id: NSNumber;
	@NSManaged var last_activity_date, last_edit_date, creation_date: NSDate
	var tags: String[]?
	
	
	func description() -> String{
		return "\(title): \(link)"
	}
	
	class func questionFromDictionary(dict: NSDictionary, inContext moc: NSManagedObjectContext) -> PostedQuestion {
		var questionID = dict["question_id"] as NSNumber
		
		var request = NSFetchRequest(entityName: "PostedQuestion")
		
		request.predicate = NSPredicate(format: "question_id == %@", argumentArray: [ questionID ] )
		
		var error: NSError?
		var existing = moc.executeFetchRequest(request, error: &error)
		var question: PostedQuestion?
		if existing.count > 0 {
			question = existing[0] as? PostedQuestion
		} else {
			question = NSEntityDescription.insertNewObjectForEntityForName("PostedQuestion", inManagedObjectContext: moc) as? PostedQuestion
			question!.question_id = questionID as NSNumber
		}
		
		if let createdAt: NSTimeInterval = dict["creation_date"] as? NSTimeInterval { question!.creation_date = NSDate(timeIntervalSince1970: createdAt) }
		if let activeAt: NSTimeInterval = dict["last_activity_date"] as? NSTimeInterval { question!.last_activity_date = NSDate(timeIntervalSince1970: activeAt) }
		if let editedAt: NSTimeInterval = dict["last_edit_date"] as? NSTimeInterval { question!.last_edit_date = NSDate(timeIntervalSince1970: editedAt) }

		question!.title = (dict["title"] as NSString).filteredString()
		question!.link = dict["link"] as String
		question!.answer_count = dict["answer_count"] as Int
		question!.score = dict["score"] as Int
		question!.view_count = dict["view_count"] as Int
		
		return question!
	}
}


/*
"answer_count" = 1;
"creation_date" = 1401920811;
"is_answered" = 1;
"last_activity_date" = 1401921248;
"last_edit_date" = 1401921223;
link = "http://stackoverflow.com/questions/24048640/quesion-of-swift-learing";
owner =             {
"display_name" = alex;
link = "http://stackoverflow.com/users/3626653/alex";
"profile_image" = "https://www.gravatar.com/avatar/382f99dc91e133198522b19b0e49d16d?s=128&d=identicon&r=PG&f=1";
reputation = 8;
"user_id" = 3626653;
"user_type" = registered;
};
"question_id" = 24048640;
score = 0;
tags =             (
"swift-language"
);
title = "Quesion of swift learing";
"view_count" = 20;
*/
