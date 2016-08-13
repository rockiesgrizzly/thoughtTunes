//
//  ThoughtTunesUITests.swift
//  ThoughtTunesUITests
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit
import XCTest

class ThoughtTunesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()


    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStandardUseCase() {
        
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        
        
    }
    
    
}
