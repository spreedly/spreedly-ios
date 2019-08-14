//
//  Spreedly.swift
//  Spreedly
//
//  Created by David Santoso on 8/13/19.
//  Copyright © 2019 Spreedly Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Spreedly {
    
    public static let instance = Spreedly()
    
    var lifecycle: TransactionLifecycle?
    
    public init() {}
    
    public func threeDsInit(rawThreeDsContext: String) -> TransactionLifecycle {
        let decodedData = Data(base64Encoded: rawThreeDsContext)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        let threeDsContext = JSON(parseJSON: decodedString)
        
        if threeDsContext["gateway_type"] == "adyen" {
            self.lifecycle = AdyenLifecycle(threeDsContext)
        } else {
            self.lifecycle = TransactionLifecycle(threeDsContext)
        }

        return lifecycle!
    }
}
