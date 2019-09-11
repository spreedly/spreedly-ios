//
//  RedirectViewController.swift
//  Spreedly
//
//  Created by Jeremy Rowe on 9/10/19.
//  Copyright © 2019 Spreedly Inc. All rights reserved.
//

import UIKit
import WebKit

class RedirectViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView = WKWebView()
    var redirectUrl: String = ""
    var checkoutForm: String = ""
    var checkoutUrl: String = ""
    var completionHandler: (String) -> Void = { (token: String) -> Void in }
    
    convenience init(redirectUrl: String, checkoutForm: String, checkoutUrl: String, completionHandler: @escaping (String) -> Void) {
        self.init()
        self.redirectUrl = redirectUrl
        self.checkoutForm = checkoutForm
        self.checkoutUrl = checkoutUrl
        self.completionHandler = completionHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.frame = UIScreen.main.bounds
        self.view.addSubview(webView)
        
        if (!self.checkoutForm.isEmpty) {
            webView.loadHTMLString(self.checkoutForm, baseURL: nil)
        } else if (!self.checkoutUrl.isEmpty) {
            let myURL = URL(string: self.checkoutUrl)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url!
        let urlString: String? = url.absoluteString
        if urlString!.starts(with: self.redirectUrl) {
            let urlComponents = URLComponents(string: urlString!)
            let token = urlComponents!.queryItems!.filter({$0.name == "transaction_token"}).first!.value!
            completionHandler(token)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
