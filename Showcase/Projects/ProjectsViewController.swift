//
//  ProjectsViewController.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/26/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit
import Dollar
import Cent

class ProjectsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	
	private var panOrigin: CGPoint!
	
	private var colors = [
		UIColor(red: 104/255.0, green: 219/255.0, blue: 146/255.0, alpha: 1),
		UIColor(red: 175/255.0, green: 104/255.0, blue: 207/255.0, alpha: 1),
		UIColor(red: 138/255.0, green: 161/255.0, blue: 239/255.0, alpha: 1)
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		attachPanGestureToCollectionView()
	}
	
	// MARK: - Collection View
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 20
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! BendyCollectionViewCell
		
		let index = indexPath.item % colors.count
		cell.shapeColor = colors[index]
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(CGRectGetWidth(collectionView.frame), 150)
	}
	
	// MARK: - Private
	
	private func attachPanGestureToCollectionView() {
		let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
		pan.delegate = self
		self.collectionView.addGestureRecognizer(pan)
	}
		
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc private func handlePan(gesture: UIPanGestureRecognizer) {
		let point = gesture.locationInView(self.collectionView)
		
		switch gesture.state {
		case .Began:
			panOrigin = point
			break
		case .Changed:
			let p = calculateDirection(point)
			if p.y != 0 {
				for cell in collectionView.visibleCells() as! [BendyCollectionViewCell] {
					cell.bend(p)
				}
			}
			break
		case .Ended:
			for cell in collectionView.visibleCells() as! [BendyCollectionViewCell] {
				cell.straighten()
			}
			break
		default: break
		}
	}
	
	private func calculateDirection(point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x - panOrigin.x, y: point.y - panOrigin.y)
	}
	
//	func scrollViewDidScroll(scrollView: UIScrollView) {
//		let v = scrollView.panGestureRecognizer.velocityInView(self.view)
//		print("DidScroll \(v)")
//		updateBendWithVelocity(v)
//	}
	
//	func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//		print("WillEnd \(velocity)")
//		updateBendWithVelocity(velocity)
//	}
//	
//	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//		for cell in collectionView.visibleCells() as! [BendyCollectionViewCell] {
//			cell.straighten()
//		}
//	}
//	
	private func updateBendWithVelocity(velocity: CGPoint) {
		if velocity.y != 0 {
			for cell in collectionView.visibleCells() as! [BendyCollectionViewCell] {
				cell.bend(velocity)
			}
		}
	}
}
