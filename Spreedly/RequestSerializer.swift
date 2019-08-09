//
//  RequestSerializer.swift
//  Spreedly
//
//  Created by David Santoso on 10/10/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import Foundation

open class RequestSerializer {
    public static func serialize(_ paymentData: Data) -> (Data) {
        let paymentDataJSON = NSString(data: paymentData, encoding: String.Encoding.utf8.rawValue)!
        let body = "{ \"payment_method\": { \"apple_pay\": { \"payment_data\": \(paymentDataJSON) }}}"
        return(body.data(using: String.Encoding.utf8))!
    }
    
    public static func serialize(_ creditCard: CreditCard) -> (data: Data?, error: NSError?) {
        var dict = [String: String]()
        
        if let creditCardFirstName = creditCard.firstName {
            dict["first_name"] = creditCardFirstName
        }
        
        if let creditCardLastName = creditCard.lastName {
            dict["last_name"] = creditCardLastName
        }
        
        if let creditCardNumber = creditCard.number {
            dict["number"] = creditCardNumber
        }
        
        if let creditCardCVV = creditCard.verificationValue {
            dict["verification_value"] = creditCardCVV
        }
        
        if let creditCardExpMonth = creditCard.month {
            dict["month"] = creditCardExpMonth
        }
        
        if let creditCardExpYear = creditCard.year {
            dict["year"] = creditCardExpYear
        }
        
        if let creditCardAddress1 = creditCard.address1 {
            dict["address1"] = creditCardAddress1
        }
        
        if let creditCardAddress2 = creditCard.address2 {
            dict["address2"] = creditCardAddress2
        }
        
        if let creditCardCity = creditCard.city {
            dict["city"] = creditCardCity
        }
        
        if let creditCardState = creditCard.state {
            dict["state"] = creditCardState
        }
        
        if let creditCardZip = creditCard.zip {
            dict["zip"] = creditCardZip
        }
        
        if let creditCardCountry = creditCard.country {
            dict["country"] = creditCardCountry
        }
        
        if let creditCardPhoneNumber = creditCard.phoneNumber {
            dict["phone_number"] = creditCardPhoneNumber
        }
        
        let body = [ "payment_method": [ "credit_card": dict ]]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            return (data, nil)
        } catch let serializeError as NSError {
            return (nil, serializeError)
        }
    }
}
