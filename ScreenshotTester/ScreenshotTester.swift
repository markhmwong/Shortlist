//
//  ScreenshotTester.swift
//  ScreenshotTester
//
//  Created by Mark Wong on 24/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import XCTest

class ScreenshotTester: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let app = XCUIApplication()
		setupSnapshot(app)
		app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
//		let app = XCUIApplication()
//        app.launch()
		
		let app = XCUIApplication()
		snapshot("01Main")
		app.navigationBars["Shortlist.MainView"].buttons["Settings"].tap()
		snapshot("02Settings")
		app.navigationBars["Settings"].buttons["Back"].tap()
		
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
