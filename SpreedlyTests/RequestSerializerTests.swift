//
//  RequestSerializerTests.swift
//  Spreedly
//
//  Created by David Santoso on 10/20/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import XCTest
import Spreedly

class RequestSerializerTests: XCTestCase {
    
    var paymentDataBlob: NSString?
    
    override func setUp() {
        super.setUp()
        
        paymentDataBlob = "{\"version\":\"EC_v1\",\"data\":\"QlzLxRFnNP9/GTaMhBwgmZ2ywntbr9iOcBY4TjPZyNrnCwsJd2cq61bDQjo3agVU0LuEot2VIHHocVrp5jdy0FkxdFhGd+j7hPvutFYGwZPcuuBgROb0beA1wfGDi09I+OWL+8x5+8QPl+y8EAGJdWHXr4CuL7hEj4CjtUhfj5GYLMceUcvwgGaWY7WzqnEO9UwUowlDP9C3cD21cW8osn/IKROTInGcZB0mzM5bVHM73NSFiFepNL6rQtomp034C+p9mikB4nc+vR49oVop0Pf+uO7YVq7cIWrrpgMG7ussnc3u4bmr3JhCNtKZzRQ2MqTxKv/CfDq099JQIvTj8hbqswv1t+yQ5ZhJ3m4bcPwrcyIVej5J241R7dNPu9xVjM6LSOX9KeGZQGud\",\"signature\":\"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\",\"header\":{\"ephemeralPublicKey\":\"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEQwjaSlnZ3EXpwKfWAd2e1VnbS6vmioMyF6bNcq/Qd65NLQsjrPatzHWbJzG7v5vJtAyrf6WhoNx3C1VchQxYuw==\",\"transactionId\":\"e220cc1504ec15835a375e9e8659e27dcbc1abe1f959a179d8308dd8211c9371\",\"publicKeyHash\":\"/4UKqrtx7AmlRvLatYt9LDt64IYo+G9eaqqS6LFOAdI=\"}}"
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSerializesApplePayPaymentData() {
        let requestJSON = "{ \"payment_method\": { \"apple_pay\": { \"payment_data\": \(paymentDataBlob!) }}}"
        let expectation = requestJSON.data(using: String.Encoding.utf8)
        let serializedRequest = RequestSerializer.serialize(paymentDataBlob!.data(using: String.Encoding.utf8.rawValue)!)
        
        XCTAssertEqual(serializedRequest, expectation, "Payment data was not correctly serialized")
    }
    
    func testSerializesCreditCard() {
        let requestDict = [
            "payment_method": [
                "credit_card": [
                    "number": "4111111111111111",
                    "verification_value": "123",
                    "month": "01",
                    "year": "2100"
                ]
            ]
        ]
        let expectation = (try? JSONSerialization.data(withJSONObject: requestDict, options: []))!
        
        let card = CreditCard()
        card.number = "4111111111111111"
        card.verificationValue = "123"
        card.month = "01"
        card.year = "2100"
        
        let serializedRequest = RequestSerializer.serialize(card)
        XCTAssertTrue(serializedRequest.data! != expectation, "Credit card was not correctly serialized")
    }
}
