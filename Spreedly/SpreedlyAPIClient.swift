//
//  SpreedlyAPIClient.swift
//  Spreedly
//
//  Created by David Santoso on 9/22/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import Foundation

public class SpreedlyAPIClient {
    public typealias SpreedlyAPICompletionBlock = (token: String?, response: NSURLResponse?, error: NSError?) -> Void
    
    let apiUrl = "http://core.spreedly.com/v1/payment_methods.json?environment_key="
    let environmentKey: String

    public init(environmentKey: String) {
        self.environmentKey = environmentKey
    }
    
    public func createPaymentMethodTokenWithCreditCard(creditCard: CreditCard, completion: SpreedlyAPICompletionBlock) {
        let formattedRequest = SpreedlyAPIRequestFormatter.format(creditCard)
        if formattedRequest.error == nil {
            self.createPaymentMethodTokenWithData(formattedRequest.data!, completion: completion)
        }
    }

    func createPaymentMethodTokenWithData(data: NSData, completion: SpreedlyAPICompletionBlock) {
        let url = NSURL(string: apiUrl + "\(self.environmentKey)")

        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()

        request.HTTPBody = data
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
            guard data != nil else {
                print("No data returned. Error: \(error)")
                return
            }

            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    if let transaction = json["transaction"] as? NSDictionary {
                        if let paymentMethod = transaction["payment_method"] as? NSDictionary {
                            if let theToken = paymentMethod["token"] as? String {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completion(token: theToken, response: response, error: nil)
                                })
                            }
                        }
                    }
                }
            } catch let parseError as NSError {
                completion(token: nil, response: response, error: parseError)
            }
        }

        task.resume()
    }
}
