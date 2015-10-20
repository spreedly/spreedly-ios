//
//  CreditCardTests.swift
//  Spreedly
//
//  Created by David Santoso on 10/20/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import XCTest
import Spreedly

class CreditCardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreatesCreditCardWithCorrectAttributes() {
        let card = CreditCard()
        card.firstName = "John"
        card.lastName = "Doe"
        card.number = "4111111111111111"
        card.verificationValue = "123"
        card.month = "01"
        card.year = "2100"
        card.address1 = "123 West Main Street"
        card.city = "Durham"
        card.state = "NC"
        card.zip = "12345"
        card.phoneNumber = "123-456-7890"
        
        XCTAssertEqual(card.firstName, "John", "Credit card first name does not match")
        XCTAssertEqual(card.lastName, "Doe", "Credit card last name does not match")
        XCTAssertEqual(card.number, "4111111111111111", "Credit card number does not match")
        XCTAssertEqual(card.verificationValue, "123", "Credit card CVV does not match")
        XCTAssertEqual(card.month, "01", "Credit card month does not match")
        XCTAssertEqual(card.year, "2100", "Credit card year does not match")
        XCTAssertEqual(card.address1, "123 West Main Street", "Credit card address1 does not match")
        XCTAssertNil(card.address2, "Credit card number does not match")
        XCTAssertEqual(card.city, "Durham", "Credit card city does not match")
        XCTAssertEqual(card.state, "NC", "Credit card state does not match")
        XCTAssertEqual(card.zip, "12345", "Credit card city does not match")
        XCTAssertEqual(card.phoneNumber, "123-456-7890", "Credit card phone number does not match")
    }

}
