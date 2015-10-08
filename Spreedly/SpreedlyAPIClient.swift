//
//  SpreedlyAPIClient.swift
//
//  Created by David Santoso on 9/22/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import Foundation

public class SpreedlyAPIClient: NSObject {
    let environmentKey: String

    public init(environmentKey: String) {
        self.environmentKey = environmentKey
        super.init()
    }

    public func createPaymentMethodToken(cardData: [String: String], completion: (token: String?, error: NSError?) -> Void) {
        let url = NSURL(string: "http://core.spreedly.dev/v1/payment_methods.json?environment_key=\(self.environmentKey)")
        let body = [ "payment_method": [ "credit_card": cardData ]]

        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()

        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: [])
        } catch let serializeError as NSError {
            completion(token: nil, error: serializeError)
        }

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
                                print("Before the completion block")
                                dispatch_async(dispatch_get_main_queue(), {
                                    completion(token: theToken, error: nil)
                                })
                            }
                        }
                    }
                }
            } catch let parseError as NSError {
                completion(token: nil, error: parseError)
            }
        }

        task.resume()
    }
}
