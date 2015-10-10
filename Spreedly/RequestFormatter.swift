//
//  RequestFormatter.swift
//  Spreedly
//
//  Created by David Santoso on 10/10/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import Foundation

public class SpreedlyAPIRequestFormatter {
    
    public static func format(creditCard: CreditCard) -> (data: NSData?, error: NSError?) {
        var cardDict = [String: String]()
        
        if let cardFirstName = creditCard.firstName {
            cardDict["first_name"] = cardFirstName
        }
        
        if let cardLastName = creditCard.lastName {
            cardDict["last_name"] = cardLastName
        }
        
        if let cardNumber = creditCard.number {
            cardDict["number"] = cardNumber
        }
        
        if let cardCVV = creditCard.verificationValue {
            cardDict["verification_value"] = cardCVV
        }
        
        if let cardExpMonth = creditCard.month {
            cardDict["month"] = cardExpMonth
        }
        
        if let cardExpYear = creditCard.year {
            cardDict["year"] = cardExpYear
        }
        
        let body = [ "payment_method": [ "credit_card": cardDict ]]
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(body, options: [])
            return (data, nil)
        } catch let serializeError as NSError {
            print("Error serializing credit card. Error: \(serializeError)")
            return (nil, serializeError)
        }
    }
}