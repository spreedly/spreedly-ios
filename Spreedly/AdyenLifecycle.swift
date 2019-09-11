//
//  AdyenLifecycle.swift
//  Spreedly
//
//  Created by David Santoso on 8/19/19.
//  Copyright © 2019 Spreedly Inc. All rights reserved.
//

import Foundation
import Adyen3DS2
import SwiftyJSON

public class AdyenLifecycle: TransactionLifecycle {
    
    var adyTransaction: ADYTransaction?
    var adyService: ADYService?
    
    override init(_ threeDsContext: JSON) {
        super.init(threeDsContext)
    }
    
    override public func getDeviceFingerprintData(fingerprintDataCompletion: @escaping (String) -> Void) {
        let params = ADYServiceParameters()
        params.directoryServerIdentifier = initialThreeDsContext!["adyen"]["threeds2.threeDS2DirectoryServerInformation.directoryServerId"].stringValue
        params.directoryServerPublicKey = initialThreeDsContext!["adyen"]["threeds2.threeDS2DirectoryServerInformation.publicKey"].stringValue
        
        ADYService.service(with: params, appearanceConfiguration: nil, completionHandler: { service in
            do {
                self.adyService = service
                self.adyTransaction = try self.adyService?.transaction(withMessageVersion: nil)
                let authenticationRequestParameters = self.adyTransaction?.authenticationRequestParameters

                let sdkEphemPubKeyParams = JSON(parseJSON: authenticationRequestParameters?.sdkEphemeralPublicKey ?? "{}")

                let fingerprintData: [String: Any] = [
                    "threeDS2RequestData": [
                        "deviceChannel": "app",
                        "sdkEncData": authenticationRequestParameters?.deviceInformation ?? "",
                        "sdkAppID": authenticationRequestParameters?.sdkApplicationIdentifier ?? "",
                        "sdkTransID": authenticationRequestParameters?.sdkTransactionIdentifier ?? "",
                        "sdkReferenceNumber": authenticationRequestParameters?.sdkReferenceNumber ?? "",
                        "sdkEphemPubKey": [
                            "y": sdkEphemPubKeyParams["y"].stringValue,
                            "x": sdkEphemPubKeyParams["x"].stringValue,
                            "kty": sdkEphemPubKeyParams["kty"].stringValue,
                            "crv": sdkEphemPubKeyParams["crv"].stringValue,
                        ],
                        "messageVersion": authenticationRequestParameters?.messageVersion ?? ""
                    ]
                ]

                let jsonDeviceData = try! JSONSerialization.data(withJSONObject: fingerprintData, options: [])
                let decoded = String(data: jsonDeviceData, encoding: .utf8)!
                let utf8str = decoded.data(using: String.Encoding.utf8)
                let base64Encoded = utf8str!.base64EncodedString()

                fingerprintDataCompletion(base64Encoded)
            } catch let error as NSError {
                print("Error: \(error)")
            }
        })
    }
    
    override public func doChallenge(rawThreeDsContext: String, challengeCompletion: @escaping (String) -> Void) {
        let decodedData = Data(base64Encoded: rawThreeDsContext)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        challengeThreeDsContext = JSON(parseJSON: decodedString)
        
        let serverTransId = challengeThreeDsContext?["adyen"]["threeds2.threeDS2ResponseData.threeDSServerTransID"].stringValue
        let TransId = challengeThreeDsContext?["adyen"]["threeds2.threeDS2ResponseData.acsTransID"].stringValue
        let referenceNumber = challengeThreeDsContext?["adyen"]["threeds2.threeDS2ResponseData.acsReferenceNumber"].stringValue
        let signedContent = challengeThreeDsContext?["adyen"]["threeds2.threeDS2ResponseData.acsSignedContent"].stringValue

        let challengeParameters = ADYChallengeParameters(
            serverTransactionIdentifier: serverTransId!,
            acsTransactionIdentifier: TransId!,
            acsReferenceNumber: referenceNumber!,
            acsSignedContent: signedContent!
        )
        
        adyTransaction?.performChallenge(with: challengeParameters, completionHandler: { (result, error) in
            if (result != nil) {
                let challengeResponseData = [
                    "threeDS2Result": [
                        "transStatus": result!.transactionStatus
                    ]
                ]
                
                let jsonDeviceData = try! JSONSerialization.data(withJSONObject: challengeResponseData, options: [])
                let decoded = String(data: jsonDeviceData, encoding: .utf8)!
                let utf8str = decoded.data(using: String.Encoding.utf8)
                let base64Encoded = utf8str!.base64EncodedString()
                
                challengeCompletion(base64Encoded)
            } else {
                print("Unable to complete challenge")
            }
        })
    }
    
    override public func doRedirect(window: UIWindow?, redirectUrl: String, checkoutForm: String, checkoutUrl: String, redirectCompletion: @escaping (String) -> Void) {
        guard let _ = window else {
            print("Aborting doRedirect window was nil")
            return
        }
        
        let existingView = window!.rootViewController
        let enhancedRedirectCompletion = { (token: String) -> Void in
            window!.rootViewController = existingView
            window!.makeKeyAndVisible()
            redirectCompletion(token)
        }
        
        let viewController = RedirectViewController(redirectUrl: redirectUrl, checkoutForm: checkoutForm, checkoutUrl: checkoutUrl, completionHandler: enhancedRedirectCompletion)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }
    
    override public func cleanup() {
        self.adyService = nil
        self.adyTransaction = nil
        self.initialThreeDsContext = nil
        self.challengeThreeDsContext = nil
    }
}
