//
//  BendyCollectionViewCell.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/26/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit

class BendyCollectionViewCell: UICollectionViewCell {
	var shapeLayer: CAShapeLayer!
	var shapeColor: UIColor = UIColor.clearColor() {
		didSet {
			shapeLayer.fillColor = shapeColor.CGColor
		}
	}
	
	private var bend = CGPointZero
	private let xIntensity:CGFloat = 1
	private let yIntensity:CGFloat = 0.5
	func bend(velocity: CGPoint) {
		bend = CGPoint(x: velocity.x * xIntensity, y: velocity.y * yIntensity)
		
		let path = newPath()
		animateTo(path)
	}
	
	func straighten() {
		let path = UIBezierPath(rect: bounds).CGPath
		animateTo(path)
	}
	
	private func animateTo(path: CGPath) {
		shapeLayer.removeAllAnimations()
		let anim = CABasicAnimation(keyPath: "path")
		anim.duration = 0.1
		anim.fromValue = shapeLayer.path
		anim.toValue = path
		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		
		shapeLayer.addAnimation(anim, forKey: "BEND")
		shapeLayer.path = path
	}
	
	override func awakeFromNib() {
		self.backgroundColor = UIColor.clearColor()
		initShapeLayer()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		invalidateShape()
	}
	
	override func drawRect(rect: CGRect) {
		invalidateShape()
	}
	
	private func initShapeLayer() {
		shapeLayer = CAShapeLayer()
		shapeLayer.path = UIBezierPath(rect: self.bounds).CGPath
		layer.addSublayer(shapeLayer)
	}
	
	private func invalidateShape() {
		let reset = UIBezierPath(rect: bounds)
		shapeLayer.path = reset.CGPath
	}
	
	private func newPath() -> CGPath {
		let w = CGRectGetWidth(self.frame)
		let h = CGRectGetHeight(self.frame)
		let tl = CGPointZero
		let tr = CGPointMake(w, 0)
		let br = CGPointMake(w, h)
		let bl = CGPointMake(0, h)
		let mid = w / 2.0
		
		let bezier = UIBezierPath()
		bezier.moveToPoint(tl)
		bezier.addQuadCurveToPoint(tr, controlPoint: CGPointMake(mid + bend.x, bend.y))
		bezier.addLineToPoint(br)
		bezier.addQuadCurveToPoint(bl, controlPoint: CGPointMake(mid + bend.x, h + bend.y))
		return bezier.CGPath
	}
}
