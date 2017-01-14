//
//  PaymentMethod.swift
//  Spreedly
//
//  Created by David Santoso on 10/22/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import Foundation

open class PaymentMethod: NSObject {
    open var token, paymentMethodType, storageState, firstName, lastName, fullName: String?
    open var cardType, lastFourDigits, firstSixDigits, address1, address2, city, state, zip: String?
    open var country, phoneNumber, shippingAddress1, shippingAddress2, shippingCity: String?
    open var shippingState, shippingZip, shippingCountry, shippingPhoneNumber: String?
    open var verificationValue, number: String?
    open var month, year: Int?
    
    convenience init(attributes: [String: AnyObject]) {
        self.init()
        
        for (key, value) in attributes {
            switch key {
            case "token":
                self.token = value as? String
            case "storage_state":
                self.storageState = value as? String
            case "payment_method_type":
                self.paymentMethodType = value as? String
            case "first_name":
                self.firstName = value as? String
            case "last_name":
                self.lastName = value as? String
            case "full_name":
                self.fullName = value as? String
            case "card_type":
                self.cardType = value as? String
            case "last_four_digits":
                self.lastFourDigits = value as? String
            case "first_six_digits":
                self.firstSixDigits = value as? String
            case "month":
                self.month = value as? Int
            case "year":
                self.year = value as? Int
            case "address1":
                self.address1 = value as? String
            case "address2":
                self.address2 = value as? String
            case "city":
                self.city = value as? String
            case "state":
                self.state = value as? String
            case "zip":
                self.zip = value as? String
            case "country":
                self.country = value as? String
            case "phone_number":
                self.phoneNumber = value as? String
            case "shipping_address1":
                self.shippingAddress1 = value as? String
            case "shipping_address2":
                self.shippingAddress2 = value as? String
            case "shipping_city":
                self.shippingCity = value as? String
            case "shipping_state":
                self.shippingState = value as? String
            case "shipping_zip":
                self.shippingZip = value as? String
            case "shipping_country":
                self.shippingCountry = value as? String
            case "shipping_phone_number":
                self.shippingPhoneNumber = value as? String
            case "verification_value":
                self.verificationValue = value as? String
            case "number":
                self.number = value as? String
            default:
                break;
            }
        }
    }
}
