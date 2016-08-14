//
//  DataHandlerTests.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/9/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
@testable import ThoughtTunes

class DataHandlerTests: XCTestCase {
    
    var sut: DataHandler!

    override func setUp() {
        super.setUp()
        
        sut = DataHandler()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUpdateData_updatesDataListAndRetrievesFromCoreData(){
        sut.updateData(.Tag, ifCategoryThenTagType: nil, ifTuneThenQueryString:  nil)
        sut.fetchData(.Tag)
        XCTAssertNotNil(sut.tagDataList)
        
        sut.updateData(.Category, ifCategoryThenTagType: TagType.Artists, ifTuneThenQueryString: nil)
        sut.fetchData(.Category)
        XCTAssertNotNil(sut.categoryDataList)
        
        sut.updateData(.Category, ifCategoryThenTagType: TagType.Albums, ifTuneThenQueryString:  nil)
        sut.fetchData(.Category)
        XCTAssertNotNil(sut.categoryDataList)
        
        sut.updateData(.Category, ifCategoryThenTagType: TagType.Genre, ifTuneThenQueryString:  nil)
        sut.fetchData(.Category)
        XCTAssertNotNil(sut.categoryDataList)
        
        sut.updateData(.Tune, ifCategoryThenTagType: nil, ifTuneThenQueryString: TestStrings.tuneQueryStringTwoValues)
        sut.fetchData(.Tune)
        XCTAssertNotNil(sut.tuneDataList)
    }
    
    func testClearCoreDataEntity_Clears(){
        sut.clearCoreDataEntity(.Tag)
        XCTAssertNotNil(sut.fetchData(.Tag))
        
        sut.clearCoreDataEntity(.Category)
        XCTAssertNotNil(sut.fetchData(.Category))
        
        sut.clearCoreDataEntity(.Tune)
        XCTAssertNotNil(sut.fetchData(.Tune))
    }
    

    


}
