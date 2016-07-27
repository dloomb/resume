//
//  PageViewController.swift
//  Showcase
//
//  Created by Daniel Loomb on 7/25/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

import UIKit
import RxSwift

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
	let changed = PublishSubject<Int>()
	
	var pageNavigationController: PageNavigationViewController!
	var pages:[UIViewController]! {
		return pageNavigationController.pages
	}
	
	private var currentPage = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource = self
		delegate = self
		
		for view in self.view.subviews {
			if let scroll = view as? UIScrollView {
				scroll.delegate = self
			}
		}
		
		setViewControllers([pages.first!], direction: .Forward, animated: true, completion: nil)
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		return getViewControllerRelativeToCurrentViewController(viewController, direction: 1)
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		return getViewControllerRelativeToCurrentViewController(viewController, direction: -1)
	}
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let controller = self.viewControllers!.last!
		currentPage = pages.indexOf(controller)!
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let width = CGRectGetWidth(scrollView.frame)
		let half = width / 2
		var index = currentPage
		
		// Left
		if scrollView.contentOffset.x < half {
			index = max(0, index - 1)
		}
		// Right
		else if scrollView.contentOffset.x > width + half {
			index = min(pages.count - 1, index + 1)
		}
		
		changed.onNext(index)
	}
	
	private func getViewControllerRelativeToCurrentViewController(currentViewController: UIViewController, direction: Int) -> UIViewController? {
		guard let index = pages.indexOf(currentViewController) else {
			return nil
		}
		
		let newIndex = index + direction
		let pageCount = pages.count
		
		guard newIndex >= 0 else {
			return nil
		}
		
		guard pageCount != newIndex else {
			return nil
		}
		
		guard pageCount > newIndex else {
			return nil
		}
		
		return pages[newIndex]
	}

}
