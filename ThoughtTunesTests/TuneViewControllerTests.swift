//
//  TuneViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/8/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
import UIKit
@testable import ThoughtTunes

class TuneViewControllerTests: XCTestCase {

    var viewController: TuneViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.tuneViewController, bundle: nil)
        viewController = storyBoard.instantiateViewControllerWithIdentifier(VCNames.tuneViewController) as! TuneViewController
        _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialViewController_IsCategoryViewController() {
        let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is TuneViewController)
    }
    
    func testRefreshControl_IsNotNil() {
        let refreshControl = viewController.refreshControl
        
        XCTAssertNotNil(refreshControl)
    }
    
    func testDataList_IsNotNil() {
        viewController.dataHandler?.fetchData(.Tune)
        XCTAssertNotNil(viewController.dataHandler?.tuneDataList)
    }
    
    
    func testTableView_IsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.tuneTableView)
    }
    
    
//    func testTableView_CellForRowIsNotNil() {
//        let tableView = viewController.tuneTableView
//        tableView.reloadData()
//        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
//        XCTAssertNotNil(cell)
//    }
    
    
    
}
