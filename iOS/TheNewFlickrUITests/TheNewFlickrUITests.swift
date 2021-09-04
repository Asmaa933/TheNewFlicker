//
//  TheNewFlickrUITests.swift
//  TheNewFlickrUITests
//
//  Created by Abdoelrhman Eaita on 13/07/2021.
//

import XCTest

class TheNewFlickrUITests: XCTestCase {

    override class func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override class func tearDown() {
        
    }
    
    func testSnapshot() {
        let app = XCUIApplication()
        snapshot("HomeViewController")
        let firstChild = app.collectionViews.children(matching: .any).element(boundBy: 0)
        if firstChild.exists {
            firstChild.tap()
            snapshot("DetailsViewController")
        }
    }
}
