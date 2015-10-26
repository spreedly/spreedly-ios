//
//  ViewController.swift
//  Example
//
//  Created by David Santoso on 10/8/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import UIKit
import PassKit
import Spreedly

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    @IBAction func unwindToRoot (segue: UIStoryboardSegue?) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleApplePayTapped(sender: AnyObject) {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = appleMerchantId
        paymentRequest.supportedNetworks = [PKPaymentNetworkVisa]
        paymentRequest.merchantCapabilities = PKMerchantCapability.Capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Snuggie", amount: NSDecimalNumber(string: "20.00")),
            PKPaymentSummaryItem(label: "Super Snuggles Inc.", amount: NSDecimalNumber(string: "20.00"))
        ]
        
        let paymentAuthVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        paymentAuthVC.delegate = self
        presentViewController(paymentAuthVC, animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion:((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

