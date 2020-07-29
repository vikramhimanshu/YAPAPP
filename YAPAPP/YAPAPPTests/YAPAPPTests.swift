//
//  YAPAPPTests.swift
//  YAPAPPTests
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import XCTest
@testable import YAPAPP

class YAPAPPTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class EndPointTest: XCTestCase {
    private var endpoint: FlickrEndpoint!
    
    override func setUp() {
        endpoint = FlickrEndpoint(queryItems: [URLQueryItem(name: "method", value: "some.value") ])
    }
    
    func testIfThereIsEmptySearchTextInEndpoint() {
        endpoint = FlickrEndpoint.photosSearch(withText: "", page: 1)
        
        let queryItems = endpoint.queryItems.contains { queryItem -> Bool in
            if let queryValue = queryItem.value {
                return (queryItem.name == "text") && !queryValue.isEmpty
            }
            return false
        }
        XCTAssertEqual(queryItems, false)
    }
    
}
