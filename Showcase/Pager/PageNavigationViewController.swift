//
//  PageNavigationViewController.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/25/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit

class PageNavigationViewController: UIViewController, PullNavigationBarDataSource {
	
	@IBOutlet weak var pullNavigationBar: PullNavigationBar!
	var pages: [UIViewController]!
	
	override func loadView() {
		super.loadView()
		loadPages()
		pullNavigationBar.dataSource = self
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "EmbeddedSegueIdentifier" {
			let controller = segue.destinationViewController as! PageViewController
			controller.pageNavigationController = self
		
			_ = controller.changed
				.distinctUntilChanged()
				.subscribeNext { next in
					self.pullNavigationBar.onPageChanged(next)
			}
		}
	}
	
	func pullNavigationBarNumberOfTitles(bar: PullNavigationBar) -> Int {
		return pages.count
	}
	
	func pullNavigationBar(bar: PullNavigationBar, TitleForIndex index: Int) -> String {
		let controller = pages[index]
		return controller.title!
	}
	
	private func loadPages() {
		let sb = self.storyboard!
		pages = [
			sb.instantiateViewControllerWithIdentifier("PageOneStoryboardIdentifier"),
			sb.instantiateViewControllerWithIdentifier("PageTwoStoryboardIdentifier"),
			sb.instantiateViewControllerWithIdentifier("PageThreeStoryboardIdentifier")
		]
	}
}
