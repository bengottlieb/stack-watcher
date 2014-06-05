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
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	
	@IBOutlet var titleLabel : UILabel
}
