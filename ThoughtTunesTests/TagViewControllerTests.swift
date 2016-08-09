//
//  TagViewControllerTests.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/8/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
import UIKit
@testable import ThoughtTunes

class TagViewControllerTests: XCTestCase {
    
    var viewController: TagViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.tagViewController, bundle: nil)
        viewController = storyBoard.instantiateViewControllerWithIdentifier(VCNames.tagViewController) as! TagViewController
        
        _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialViewController_IsTagViewController() {
        let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is TagViewController)
    }
    
    func testDataList_IsNotNil() {
        XCTAssertNotNil(viewController.dataList)
    }
    
    func testTableView_IsNotNilAfterViewDidLoad() {
        let tableView = viewController.tagTableView
        XCTAssertNotNil(tableView)
    }

    func testTableView_CellForRowIsNotNil() {
        let tableView = viewController.tagTableView
        tableView.reloadData()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertNotNil(cell)
    }



}
