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
    }
    
    
    func testInitialViewController_IsTagViewController() {
        let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is TagViewController)
    }
    
    
    func testDataList_IsNotNil() {
        viewController.dataHandler?.fetchData(.Tag)
        XCTAssertNotNil(viewController.dataHandler?.tagDataList)
   
    }
    
    
    func testTableView_IsNotNilAfterViewDidLoad() {
        let tableView = viewController.tagTableView
        XCTAssertNotNil(tableView)
    }
    
//    //TODO: resolve cell returning as nil here though not nil in tableView itself
//    func testTableView_CellForRow_ProducesCell() {
//        let tableView = viewController.tagTableView
//        tableView.reloadData()
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        XCTAssertNotNil(cell)
//    }
    


}
