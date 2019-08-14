# Spreedly iOS SDK

[![Version](https://img.shields.io/cocoapods/v/Spreedly.svg?style=flat)](http://cocoapods.org/pods/Spreedly)
[![License](https://img.shields.io/cocoapods/l/Spreedly.svg?style=flat)](http://cocoapods.org/pods/Spreedly)
[![Platform](https://img.shields.io/cocoapods/p/Spreedly.svg?style=flat)](http://cocoapods.org/pods/Spreedly)

Spreedly's official iOS SDK. Tokenize credit cards and Apple Pay payment methods directly in your app. Native support for 3DS 2.0 authentication flows using Adyen with more gateways actively being added.

## Requirements

* Swift 5
* iOS 10.3+
* Xcode 10.0+

## Installation

Spreedly is available through [CocoaPods](http://cocoapods.org). To install
it, simply add `Spreedly` to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.3'
use_frameworks!

target 'App' do
  pod 'Spreedly'
end

```

## Tokenization

_Note: Tokenization improvements are being actively developed. Future versions may change how this is currently works._

### Credit Card

1. Create a `CreditCard` object using data from your checkout form:

```swift
let creditCard = CreditCard()
creditCard.firstName = self.cardFirstName.text!
creditCard.lastName = self.cardLastName.text!
creditCard.number = self.cardNumber.text!
creditCard.month = extractMonth(self.cardExpiration.text!)
creditCard.year = extractYear(self.cardExpiration.text!)
creditCard.verificationValue = self.cardVerificationValue.text!
```

2. Once you have the card data, instantiate the Spreedly API client with an environment key and tokenize:

```swift
let client = SpreedlyAPIClient(environmentKey: environmentKey)
client.createPaymentMethodTokenWithCreditCard(creditCard) { paymentMethod, error -> Void in
  if error != nil {
    print(error!)
    self.showAlertView("Error", message: error!.description)
  } else {
    print(paymentMethod!.token!)
    self.showAlertView("Success", message: "Token: \(paymentMethod!.token!)")
  }
}
```

3. Once you have a token, you can send that to your backend to run an authenticated request to charge the card. Note that the card will *NOT* be automatically retained. You must make a separate `retain` call if you would like to keep the card in your Spreedly vault.

### Apple Pay

If you're planning on using Apple Pay, be sure to checkout the [Apple developer docs](https://developer.apple.com/apple-pay/) to get your app ready to accept Apple Pay payment information and the [Spreedly Apple Pay guide](https://docs.spreedly.com/guides/apple-pay/) to setup your backend.

Documentation and a guide to using the iOS SDK's Apple Pay tokenization features can be found on the [Spreedly docs](https://docs.spreedly.com/guides/mobile/ios).

## 3DS 2.0

_Note: At time of writing, only Adyen 3DS 2.0 is supported through the iOS SDK. More gateways are being added._

To fully utilize the 3DS 2.0 flows you'll need to ensure you're backend is ready to send 3DS related data and handle 3DS response fields from Spreedly. For security reasons, all 3DS interactions with your payment gateway will need to happen from your mobile app's backend where you can securely store your Spreedly API credentials.

See the Spreedly [3DS guides](https://docs.spreedly.com/guides/3dsecure-landing/) for additional documentation.

1. Starting from your mobile app making a request to your backend to execute a purchase (from a checkout screen or similar), make an `authorize` or `purchase` request from your mobile backend with the following fields to initiate a possible 3DS authentication flow.

* `attempt_3dsecure`: true
* `three_ds_version`: 2
* `channel`: "app"
* `callback_url`: "https://example.com/callback"
* `redirect_url`: ""https://example.com/redirect"

Note that you will replace both `callback_url` and `redirect_url` with your own endpoints in the case of an issuing bank not being 3DS 2.0 ready and falling back to 3DS 1.0. Here is an example request body:

```json
{
  "transaction": {
    "payment_method_token": "56wyNnSmuA6CWYP7w0MiYCVIbW6",
    "amount": 100,
    "currency_code": "USD",
    "attempt_3dsecure": true,
    "three_ds_version": 2,
    "channel": "app",
    "callback_url": "https://example.com/callback",
    "redirect_url": "https://example.com/redirect"
  }
}
```

2. Assuming the response from your payment gateway denotes that the card should go through 3DS authentication, you'll want to check of 3 fields from the Spreedly API response and their corresponding values:

* `state`: `pending`
* `required_action`: either `device_fingerprint` or `challenge`
* `three_ds_context`: blob of 3DS specific data

Your backend should respond to your mobile app's purchase request with that Spreedly API response data so your app knows how to proceed with the transaction and the Spreedly iOS SDK can do it's work to handle the 3DS flow. Specifically, the Spreedly iOS SDK will need the `three_ds_context` to continue.

3. In your app, create a `Lifecycle` object to handle the full lifecycle of the purchase flow passing in the value of the `three_ds_context`:

```swift
let lifecycle = Spreedly.instance.threeDsInit(rawThreeDsContext: "ZXhhZSAzZHMgcmVzcG9uc2UgZGF0YQ==....")
```

4. If the `required_action` is `"device_fingerprint"`, call the `getDeviceFingerprint()` function to generate the fingerprint to send back to your gateway. Note that the fingerprint will be returned in a completion handler.

```swift
lifecycle.getDeviceFingerprintData(fingerprintDataCompletion: { fingerprintData in
  // send the fingerprint data to your backend to send back to Spreedly
})
```

5. Your backend should take the fingerprint data returned in your mobile app and call Spreedly's `continue` endpoint to see if a challenge is required for this transaction.

```
POST /v1/transactions/<transaction-token>/continue.<format>
Host: core.spreedly.com
Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
Content-Type: application/<format>

{
  "three_ds_data": "the fingerprint data..."
}
```

6. If a challenge is required, the Spreedly API will send back the following fields in the transaction response:

* `state`: `pending`
* `required_action`: `challenge`
* `three_ds_context`: blob of 3DS specific data

Send that data back to your mobile app again and use the Spreedly iOS SDK to bring up the challenge window, passing in the value of the `three_ds_context` field.

```swift
lifecycle.doChallenge(rawThreeDsContext: "ZXhhbXBsZSAzZHMgY2hhbGxdlIGRhdGE=...", challengeCompletion: { challengeData in
  // send the returned challenge data to your backend
})
```

7. Send the returned challenge data in the completion handler to the `continue` endpoint to see if the user successfully authenticated.

```
POST /v1/transactions/<transaction-token>/continue.<format>
Host: core.spreedly.com
Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
Content-Type: application/<format>

{
  "three_ds_data": "the fingerprint data..."
}
```

At this point, if the user did successfully authenticate then the card was charged (or in the case of an authorize, funds are now being held for capture later) and you and direct your mobile app screen to a success page.

## Sample app

To see a full example of the 3DS flow in a mobile app, see the following Spreedly example app:

https://github.com/spreedly/spreedly-ios-sample


## Authors

[David Santoso](https://github.com/davidsantoso)
<br/>
[Jeremy Rowe](https://github.com/jeremywrowe)

## License

Spreedly is available under the MIT license. See the LICENSE file for more info.
