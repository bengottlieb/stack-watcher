//
//  SEQuestion.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class SEQuestion : NSObject {

	var title, link: String
	var answer_count: Int;
	
	init(dictionary: NSDictionary) {
		title = (dictionary["title"] as NSString).filteredString()
		link = dictionary["link"] as String
		answer_count = dictionary["answer_count"] as Int
		super.init()
	}
	
	func description() -> String{
		return "\(title): \(link)"
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
