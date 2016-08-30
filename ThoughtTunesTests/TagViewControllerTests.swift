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
    var tableView: UITableView!
    
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.tagViewController, bundle: nil)
        viewController = storyBoard.instantiateViewControllerWithIdentifier(VCNames.tagViewController) as! TagViewController
        
        _ = viewController.view
    }
    
    
    override func tearDown() {
        super.tearDown()
        
        //OHHTTPStubs.removeAllStubs()
    }
    
    
    func testInitialViewController_IsTagViewController() {
        let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is TagViewController)
    }
    
    func testRefreshControl_IsNotNil() {
        let refreshControl = viewController.refreshControl
        
        XCTAssertNotNil(refreshControl)
    }
    
    func testDataList_IsNotNil() {
        viewController.dataHandler?.fetchData(.Tag)
        XCTAssertNotNil(viewController.dataHandler?.tagDataList)
    }
    
    
    func testTableView_IsNotNilAfterViewDidLoad() {
        let tableView = viewController.tagTableView
        XCTAssertNotNil(tableView)
    }


}
