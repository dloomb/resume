//
//  TestTableViewController.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/26/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit
import RxSwift

class TestTableViewController: UITableViewController, UIGestureRecognizerDelegate {
	
	private var start: CGPoint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for view in self.view.subviews {
			if let scroll = view as? UIScrollView {
				let pan = UIPanGestureRecognizer(target: self, action: #selector(TestTableViewController.handlePanGestureRecognizer(_:)))
				pan.delegate = self
				scroll.addGestureRecognizer(pan)
			}
		}
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		start = gestureRecognizer.locationInView(self.view!.window)
		return true
	}
	
	@objc private func handlePanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
		let point = gestureRecognizer.locationInView(self.view!.window)
		
		let dir = CGPoint(x: point.x - start.x, y: point.y - start.y)
		let a = pow(dir.x, 2)
		let b = pow(dir.y, 2)
		let scale = sqrt(a + b) / 1000

		print("\(dir) \(scale)")
	}
	
}
