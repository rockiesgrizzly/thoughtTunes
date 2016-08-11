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
        viewController.updateDataFromTagType()
        viewController.dataHandler?.fetchData(.Category)
        XCTAssertNotNil(viewController.dataHandler?.categoryDataList)
    }
    
//    //TODO: resolve cell returning as nil here though not nil in tableView itself
//    func testTableView_CellForRow_ProducesCell() {
//        let tableView = viewController.catTableView
//        tableView.reloadData()
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        XCTAssertNotNil(cell)
//    }

    func testTagTypeUpdate() {
        XCTAssertNil(viewController.tagChosen, "tagChosen should start as nil")
        
        viewController.tagChosen = TagType.Artists
        XCTAssertNotNil(viewController.tagChosen)
    }


}
