//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Michal Martinů on 16/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import XCTest
@testable import FallenMeteorite

class NetworkTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUp() {

        networkManager = NetworkManager()
    }

    override func tearDown() {

        networkManager = nil
    }

    func testUrlRequest() {

        let urlRequest = "https://data.nasa.gov/resource/gh4g-9sfh.json?$$app_token=3STavZkgZFubnTHrKZQg9ITmo&$where=year%20%3E%3D%20\'2011-01-01T00:00\'%20and%20mass%20IS%20NOT%20NULL&$order=mass%20DESC"

        XCTAssertEqual(UrlRequest.request?.absoluteString, urlRequest)
    }

    func testValidLoadData() {

        let promise = expectation(description: "Success")

        networkManager.loadDataWith(UrlRequest.request) { result in

            switch result {
                case .success:              promise.fulfill()
                case .error(let message):   XCTFail(message)
                case .offline:              XCTFail("Error: Offline")
            }
        }

        wait(for: [promise], timeout: 5)
    }

    func testInvalidLoadData() {

        let invalidURL = URL(string: "https://data.nasa.com")

        let promise = expectation(description: "Error")

        networkManager.loadDataWith(invalidURL) { result in

            switch result {
                case .success:              XCTFail("Success")
                case .error:                promise.fulfill()
                case .offline:              XCTFail("Error: Offline")
            }
        }

        wait(for: [promise], timeout: 5)
    }
}
