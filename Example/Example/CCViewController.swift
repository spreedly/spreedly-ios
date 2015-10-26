//
//  CreditCardViewController.swift
//  Example
//
//  Created by David Santoso on 10/25/15.
//  Copyright © 2015 Spreedly Inc. All rights reserved.
//

import UIKit
import Spreedly

class CCViewController: UIViewController {
    
    let environmentKey = ""
    let backendChargeURL = "http://localhost:3001"
    let appleMerchantId = "merchant.com.you-company.testing"
    
    @IBOutlet weak var cardNumber: CCTextField!
    @IBOutlet weak var cardExpiration: CCTextField!
    @IBOutlet weak var cardVerificationValue: CCTextField!
    @IBOutlet weak var purchaseActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleBuyNowTapped(sender: AnyObject) {
        self.purchaseActivityIndicator.startAnimating()
        
        let creditCard = CreditCard()
        creditCard.number = self.cardNumber.text!
        creditCard.month = CreditCard.extractMonth(self.cardExpiration.text!)
        creditCard.year = CreditCard.extractYear(self.cardExpiration.text!)
        creditCard.verificationValue = self.cardVerificationValue.text!
        
        let client = SpreedlyAPIClient(environmentKey: environmentKey)
        client.createPaymentMethodTokenWithCreditCard(creditCard) { paymentMethod, error -> Void in
        }
    }
}
