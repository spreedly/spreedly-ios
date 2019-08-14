Pod::Spec.new do |s|
    s.name             = "Spreedly"
    s.version          = "1.0.0"
    s.summary          = "Spreedly iOS SDK"
    s.description      = <<-DESC
                            The Spreedly iOS SDK makes it easy for you to accept a users credit card details inside your iOS app. By creating payment method tokens, Spreedly handles the majority of your PCI compliance issues by preventing sensitive credit card data from ever hitting your servers.
                            DESC
    s.homepage         = "https://github.com/spreedly/spreedly-ios"
    s.license          = 'MIT'
    s.author           = { "David Santoso" => "david@spreedly.com" }

    s.source           = { :git => "https://github.com/spreedly/spreedly-ios.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/spreedly'
    s.platform     = :ios, '10.3'
    s.requires_arc = true

    s.source_files = 'Spreedly/*.swift'
    s.frameworks = 'Foundation'

    s.dependency 'Adyen3DS2'
    s.dependency 'SwiftyJSON', '~> 4.0'
end
