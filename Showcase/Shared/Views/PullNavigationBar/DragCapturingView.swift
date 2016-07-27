//
//  DragCapturingView.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/25/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit

class DragCapturingView: UIView {
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
	
	private var startY: CGFloat = 0
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch = touches.first!
		let point = touch.locationInView(touch.window)
		startY = point.y
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch = touches.first!
		let point = touch.locationInView(touch.window)
		moveToYPos(point.y - startY)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		animateToOrigin()
	}
	
	private func moveToYPos(pos: CGFloat) {
		bottomConstraint.constant = -pos
	}
	
	private func animateToOrigin() {
		bottomConstraint.constant = 0
		UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
			(self.superview!).layoutIfNeeded()
			}, completion: nil)
	}
}
