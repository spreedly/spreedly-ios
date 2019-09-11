//
//  TransactionLifecycle.swift
//  Spreedly
//
//  Created by David Santoso on 8/21/19.
//  Copyright © 2019 Spreedly Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Adyen3DS2

public class TransactionLifecycle {
    
    var initialThreeDsContext: JSON?
    var challengeThreeDsContext: JSON?
    
    init(_ threeDsContext: JSON) {
        initialThreeDsContext = threeDsContext
    }
    
    // Function stub
    public func getDeviceFingerprintData(fingerprintDataCompletion: @escaping (String) -> Void) {
    }
    
    // Function stub
    public func doChallenge(rawThreeDsContext: String, challengeCompletion: @escaping (String) -> Void) {
    }
    
    // Function stub
    public func doRedirect(window: UIWindow?, redirectUrl: String, checkoutForm: String, checkoutUrl: String, redirectCompletion: @escaping (String) -> Void) {
    }
    
    // Function stub
    public func cleanup() {
    }
    
}
