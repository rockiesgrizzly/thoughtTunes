//
//  ThoughtTunesUITests.swift
//  ThoughtTunesUITests
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit
import XCTest

@testable import ThoughtTunes

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
    
    
    func testArtistToTune() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let artistsStaticText = tablesQuery.staticTexts["Artists"]
        
        //Test Aerosmith
        artistsStaticText.tap()
        XCTAssert(tablesQuery.staticTexts["Aerosmith"].exists)
        tablesQuery.staticTexts["Aerosmith"].tap()
        XCTAssert(tablesQuery.cells.containingType(.StaticText, identifier:"Adam's Apple").element.exists)
        
        tablesQuery.cells.containingType(.StaticText, identifier:"Adam's Apple").element.tap()
    }
    
    
    func testAlbumToTune() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let albumsStaticText = tablesQuery.staticTexts["Albums"]
        
        albumsStaticText.tap()
        XCTAssert(tablesQuery.staticTexts["Achtung Baby"].exists)
        tablesQuery.staticTexts["Achtung Baby"].tap()
        
        tablesQuery.cells.containingType(.StaticText, identifier:"Acrobat").element.tap()
    }
    
    
    func testGenreToTune() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let genreStaticText = tablesQuery.staticTexts["Genre"]
        
        genreStaticText.tap()
        XCTAssert(tablesQuery.staticTexts["Alternative"].exists)
        tablesQuery.staticTexts["Alternative"].tap()
        
        //tablesQuery.cells.containingType(.StaticText, identifier:"Christmas Lights").element.tap()
    }
    
}
