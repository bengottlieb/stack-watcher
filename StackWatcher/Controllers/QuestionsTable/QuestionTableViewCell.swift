//
//  QuestionTableViewCell.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/4/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
	var question: SEQuestion? {
		didSet {
			//println("Question: \(question)")
			self.titleLabel.text = self.question!.title
			self.tagBubbles.tags = self.question!.tags
			self.answerCountLabel.text = "\(self.question!.answer_count)"
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.answerCountLabel.layer.borderColor = UIColor.blackColor().CGColor
		self.answerCountLabel.layer.borderWidth = 1.0
		self.answerCountLabel.layer.cornerRadius = self.answerCountLabel.layer.bounds.size.width / 2
    }

	
	@IBOutlet var tagBubbles : TagBubbleView
	@IBOutlet var titleLabel : UILabel
	@IBOutlet var answerCountLabel : UILabel
}
