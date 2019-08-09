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

    @IBAction func handleBuyNowTapped(_ sender: AnyObject) {
        let creditCard = CreditCard()
        creditCard.firstName = self.cardFirstName.text!
        creditCard.lastName = self.cardLastName.text!
        creditCard.number = self.cardNumber.text!
        creditCard.month = extractMonth(self.cardExpiration.text!)
        creditCard.year = extractYear(self.cardExpiration.text!)
        creditCard.verificationValue = self.cardVerificationValue.text!
        
        let client = SpreedlyAPIClient(environmentKey: environmentKey)
        client.createPaymentMethodTokenWithCreditCard(creditCard) { paymentMethod, error -> Void in
            if error != nil {
                print(error!)
                self.showAlertView("Error", message: error!.description)
            } else {
                self.showAlertView("Success", message: "Token: \(paymentMethod!.token!)")
                
                // On success, you can now send a request to your backend to finish the charge
                // via an authenticated API call. Just pass the payment method token you recieved
            }
        }
    }
    
    func showAlertView(_ title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func extractMonth(_ expiration: String) -> String {
        return(splitExpirationString(expiration).first!)
    }
    
    func extractYear(_ expiration: String) -> String {
        return("20" + splitExpirationString(expiration).last!)
    }
    
    func splitExpirationString(_ expiration: String) -> [String] {
        let expirationArray = expiration.components(separatedBy: "/")
        return expirationArray
    }
}
