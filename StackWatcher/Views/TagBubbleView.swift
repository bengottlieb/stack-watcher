//
//  TagBubbleView.swift
//  StackWatcher
//
//  Created by Ben Gottlieb on 6/5/14.
//  Copyright (c) 2014 Stand Alone, Inc. All rights reserved.
//

import UIKit

class TagBubbleView: UIScrollView {
	var tags: String[] = [] {
		didSet {
			while self.subviews.count > 0 { self.subviews[0].removeFromSuperview() }
			
			var x: CGFloat = 0.0
			var y: CGFloat = self.bounds.size.height / 2
			
			for tag in tags {
				var label = UILabel(frame: CGRect.zeroRect)
				label.text = "  \(tag)  "
				label.font = UIFont.systemFontOfSize(13)
				label.sizeToFit()
				label.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
				label.layer.cornerRadius = label.bounds.size.height / 2
				label.layer.masksToBounds = true
				label.backgroundColor = UIColor.lightGrayColor()
				label.textColor = UIColor.whiteColor()
				
				var labelWidth: CGFloat = label.bounds.size.width
				label.center = CGPoint(x: x + labelWidth / 2, y: y)
				x += labelWidth + 5
				self.addSubview(label)
			}
			
			self.contentSize = CGSize(width: x, height: self.bounds.size.height)
		}
	}
	
	
}
