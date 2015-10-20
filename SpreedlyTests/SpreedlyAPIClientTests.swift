//
//  SpreedlyTests.swift
//  SpreedlyTests
//
//  Created by David Santoso on 10/8/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import XCTest
import Spreedly

class SpreedlyAPIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatesClientWithCustomAPIUrl() {
        let client = SpreedlyAPIClient(environmentKey: "env-key", apiUrl: "api-url")
        XCTAssertEqual(client.environmentKey, "env-key")
        XCTAssertEqual(client.apiUrl, "api-url")
    }
}
