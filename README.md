# Spreedly iOS SDK

[![CI Status](http://img.shields.io/travis/Spreedly/Spreedly.svg?style=flat)](https://travis-ci.org/Spreedly/Spreedly)
[![Version](https://img.shields.io/cocoapods/v/Spreedly.svg?style=flat)](http://cocoapods.org/pods/Spreedly)
[![License](https://img.shields.io/cocoapods/l/Spreedly.svg?style=flat)](http://cocoapods.org/pods/Spreedly)
[![Platform](https://img.shields.io/cocoapods/p/Spreedly.svg?style=flat)](http://cocoapods.org/pods/Spreedly)

If you’re building an iOS app and want to accept payments, the Spreedly iOS library can make it easier. It removes the burden of PCI compliance by making sure sensitive credit card information never touches your servers. Just a token associated with that payment method. Our library also supports Apple Pay so you can enable users to make payments without entering their credit card information.

## Requirements

Our SDK is compatible with iOS apps supporting iOS 8.0 and above and requires Xcode 7.0+ to build the source.

## Usage

There is an example app included in the respository. To try it out, clone the repo and run the `Example` app. It includes creating a payment method token from a custom credit card form as well as from an Apple Pay payment authorization.

If you're planning on using Apple Pay, be sure to checkout the [Apple developer docs](https://developer.apple.com/apple-pay/) to get your app ready to accept Apple Pay payment information and the [Spreedly Apple Pay guide](https://docs.spreedly.com/guides/apple-pay/) to setup your backend.

More documentation and a guide to using the library can be found on the [Spreedly docs](https://docs.spreedly.com/guides/mobile/ios).

## Installation

Spreedly is available through [CocoaPods](http://cocoapods.org). To install
it, simply add `Spreedly` to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'App' do
  pod 'Spreedly'
end

```

If you're integrating into an existing Objective-C app, be sure to add the header file in the appropriate view controller.

```objective-c
#import "Spreedly-Swift.h"
```

## Author

David Santoso, david@spreedly.com

## License

Spreedly is available under the MIT license. See the LICENSE file for more info.
