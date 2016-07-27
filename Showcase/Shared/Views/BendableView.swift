//
//  BendableView.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/26/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit
import RxSwift

struct Bend {
	var direction: CGPoint
	var scale: CGFloat
}

class BendableView: UIView {
	
	private var shapeLayer: CAShapeLayer!
	private var dir = CGPointZero
	private var scale: CGFloat = 1
	
	override func awakeFromNib() {
		shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = self.backgroundColor?.CGColor
		self.backgroundColor = UIColor.clearColor()
		shapeLayer.path = generatePath()
		layer.addSublayer(shapeLayer)
	}
	
	override func drawRect(rect: CGRect) {
		shapeLayer.path = generatePath()
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		shapeLayer.removeAllAnimations()
		
		let touch = touches.first!
		let point = touch.locationInView(touch.window)
		let center = touch.window!.convertPoint(self.center, fromView: self.superview)
		
		dir = CGPoint(x: point.x - center.x, y: point.y - center.y)
		let a = pow(dir.x, 2)
		let b = pow(dir.y, 2)
		scale = sqrt(a + b) / 1000
		
		print("dist \(scale), dir \(dir)")
		
		shapeLayer.path = generatePath()
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		dir = CGPointZero
		scale = 1
		let toPath = generatePath()
		
		let anim = CABasicAnimation(keyPath: "path")
		anim.duration = 0.3
		anim.fromValue = shapeLayer.path
		anim.toValue = toPath
		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		
		shapeLayer.addAnimation(anim, forKey: "PATH_BOUNCE_BACK")
		shapeLayer.path = toPath
	}
	
	private func generatePath() -> CGPath {
		let rect = self.bounds
		let path = UIBezierPath()
		let topLeft = rect.origin
		let topRight = CGPointMake(rect.size.width, rect.origin.y)
		let bottomRight = CGPointMake(topRight.x, topRight.y + rect.size.height)
		let bottomLeft = CGPointMake(rect.origin.x, bottomRight.y)
		
		let x = dir.x * scale
		let y = dir.y * scale
		
		let topControl = CGPointMake(CGRectGetMidX(rect) + x, y)
		let bottomControl = CGPointMake(CGRectGetMidX(rect) + x, bottomRight.y + y)
		
		path.moveToPoint(topLeft)
		path.addQuadCurveToPoint(topRight, controlPoint: topControl)
		path.addLineToPoint(bottomRight)
		path.addQuadCurveToPoint(bottomLeft, controlPoint: bottomControl)
		path.closePath()
		return path.CGPath
	}

}
