//
//  DebugMeTests.swift
//  DebugTest
//
//  Created by Jayant Varma on 28/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//
// Code : Chapter_15
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit
import XCTest

class DebugMeTests: XCTestCase {

    var debugMe:DebugMe!
    
    override func setUp() {
        super.setUp()
        
        self.debugMe = DebugMe()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        self.debugMe = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testDebugMeHasStringProperty() {
        XCTAssert(self.debugMe.respondsToSelector("string"), "expected DebugMe to have a 'string' selector")
    }
    
    func testDebugMeIsTrue() {
        let result = self.debugMe.isTrue()
        XCTAssertTrue(result, "expected DebugMe isTrue to be true, got \(result)")
    }
    
    func testDebugMeIsFalse() {
        let result = self.debugMe.isFalse()
        XCTAssertFalse(result, "expected DebugMe isFalse to be false, got \(result)")
    }
    
    func testDebugHelloWorld() {
        let result = self.debugMe.helloWorld()
        XCTAssertEqual(result, "Hello, World!", "expected DebugMe helloWorld to be 'Hello, World!', got \(result)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
