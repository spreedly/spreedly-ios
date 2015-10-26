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
    
    @IBOutlet weak var cardFirstName: CCTextField!
    @IBOutlet weak var cardLastName: CCTextField!
    @IBOutlet weak var cardNumber: CCTextField!
    @IBOutlet weak var cardExpiration: CCTextField!
    @IBOutlet weak var cardVerificationValue: CCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleBuyNowTapped(sender: AnyObject) {
        let creditCard = CreditCard()
        creditCard.firstName = self.cardFirstName.text!
        creditCard.lastName = self.cardLastName.text!
        creditCard.number = self.cardNumber.text!
        creditCard.month = CreditCard.extractMonth(self.cardExpiration.text!)
        creditCard.year = CreditCard.extractYear(self.cardExpiration.text!)
        creditCard.verificationValue = self.cardVerificationValue.text!
        
        if creditCard.isValid() {
            let client = SpreedlyAPIClient(environmentKey: environmentKey)
            client.createPaymentMethodTokenWithCreditCard(creditCard) { paymentMethod, error -> Void in
                if error != nil {
                    print(error)
                    self.showAlertView("Error", message: "Unable to create token from credit card")
                } else {
                    self.showAlertView("Success", message: "Token: \(paymentMethod!.token!)")
                    
                    // On success, you can now send a request to your backend to finish the charge
                    // via an authenticated API call. Just pass the payment method token you recieved
                }
            }
        } else {
            showAlertView("Invalid Credit Card", message: "The credit card entered was invalid")
        }
    }
    
    func showAlertView(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
