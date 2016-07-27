//
//  PullNavigationBar.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/25/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit

protocol PullNavigationBarDataSource {
	func pullNavigationBarNumberOfTitles(bar: PullNavigationBar) -> Int
	func pullNavigationBar(bar: PullNavigationBar, TitleForIndex index: Int) -> String
}

private enum PullNavigationBarConstants {
	static let cellHeight: CGFloat = 50
}

class PullNavigationBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	var dataSource: PullNavigationBarDataSource!
	
	private var currentIndex = 0
	
	func onPageChanged(pageNumber: Int) {
		currentIndex = pageNumber
		collectionView.reloadData()
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = dataSource.pullNavigationBarNumberOfTitles(self)
		heightConstraint.constant = CGFloat(count) * PullNavigationBarConstants.cellHeight
		return count;
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TitleCell", forIndexPath: indexPath) as! PullNavigationBarCell
		let max = self.collectionView(collectionView, numberOfItemsInSection: 0)
		let index = (indexPath.item + currentIndex) % max
		let title = dataSource.pullNavigationBar(self, TitleForIndex: index)
		cell.titleLabel.text = title
		return cell
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(collectionView.frame.size.width, PullNavigationBarConstants.cellHeight)
	}
}
