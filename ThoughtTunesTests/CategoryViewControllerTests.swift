//
//  CategoryViewControllerTests.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/8/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
import UIKit
@testable import ThoughtTunes

class CategoryViewControllerTests: XCTestCase {
    
    var viewController: CategoryViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.categoryViewController, bundle: nil)
        viewController = storyBoard.instantiateViewControllerWithIdentifier(VCNames.categoryViewController) as! CategoryViewController
        _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialViewController_IsCategoryViewController() {
        let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is CategoryViewController)
    }
    
    func testTableView_IsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.catTableView)
    }
    
    func testDataList_IsNotNil() {
        XCTAssertNotNil(viewController.dataList)
    }
    
    func testTableView_CellForRowIsNotNil() {
        let tableView = viewController.catTableView
        tableView.reloadData()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertNotNil(cell)
    }



}
