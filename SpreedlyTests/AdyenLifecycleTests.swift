//
//  AdyenLifecycleTests.swift
//  Spreedly
//
//  Created by David Santoso on 8/21/19.
//  Copyright © 2019 Spreedly Inc. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON

class AdyenLifecycleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetDeviceFingerprintData() {
        let spreedly = Spreedly()
        let lifecycle = spreedly.threeDsInit(rawThreeDsContext: exampleDeviceFingerprintThreeDSContext())
        
        lifecycle.getDeviceFingerprintData(fingerprintDataCompletion: { deviceFingerprintData in
            XCTAssertNotNil(deviceFingerprintData)
            
            let decodedData = Data(base64Encoded: deviceFingerprintData)!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            let fingerprintData = JSON(parseJSON: decodedString)
            
            XCTAssertNotNil(fingerprintData["threeDS2RequestData"].stringValue)
            XCTAssertNotNil(fingerprintData["threeDS2RequestData"]["sdkEncData"].stringValue)
            XCTAssertNotNil(fingerprintData["threeDS2RequestData"]["sdkReferenceNumber"].stringValue)
            XCTAssertNotNil(fingerprintData["threeDS2RequestData"]["sdkTransID"].stringValue)
            XCTAssertNotNil(fingerprintData["threeDS2RequestData"]["messageVersion"].stringValue)
            XCTAssertNotNil(fingerprintData["threeDS2RequestData"]["sdkAppID"].stringValue)
            
            XCTAssert(fingerprintData["threeDS2RequestData"]["deviceChannel"].stringValue == "app")
        })
    }
    
    func exampleDeviceFingerprintThreeDSContext() -> String {
        let example = """
            {
                \"gateway_type\": \"adyen\",
                \"adyen\": {
                    \"threeds2.threeDS2Token\": \"BQABAQApf0IMSpwPAMqZjpFw8/zJJt7nVUqsV3HawfUdJqQwwf3+a5toeJqmRlIVV/938yylOoi8V6WyLHdzqet4V/8br6heiR+X33olbKh4YmLfLWeFmgET7Hk7q5gnhMZUcPPctKUfpxVUMINnjRUkrBpCpCMh6b7Kuoalj5lLlWM+IQk/iK4A5fmoPRs08tdMGapTFSZV28Da88J3tXJ4MaAbCttf0188a2vmIUdhPhtPE9H/laYpH1qZAS24G9IplX962GwAxpiPaa0E7NcPlPgdYhIgF0k6WOqnHyKQK3A2BvIdOhWxdBDo+UYex1n/mIHWT00czrr48RMA1gY3BFweENz/F1Jby7ZNvZJ20EH+458AAD7RPf7DGXLnlo3qyp2R+WxpNTc4N6toCFwnWNhHKBfVfevbBQeGKEtmagwunwrbKDWYLyzjRRq1R/JlH4qpyX4ehD55G6wm1+0tB69mv3DOjehIEh1s7NsDGAmI7TsMRyDO3UefRKT0eufukxFOJDRDLIIptnqeWXqOSXp+3HlmdXYbfhiM7eIJW2H9tWERE6jvr8RifXHl2mPBSEmm+y8OBvbjyesCy84cLJXvVm3DZintawgbvEg/rMLeLah1BPcSMiXPDG40+BmPVfIPpVo/2nPoHazJ9n4w/jiAQDVbdjIi9q0I6bTrZyLuQyxQhj+kL9xeBljUfGU3eUrMQ6eMlB35cAV1hSMAnQmLXiL13dxtcWF/fkepkOu7eCK+ceUB/FkTXpl6zy2VisbkqfovVGmINYy5qiYKLTEyEXibuwvJk6FqCtohpzrsyEfuzGKucI9WSK7dpv95hvlhkhg0wjwjT+HuraEjexXopCoWBFV0nVxLm5ORpykFrv4bzxIIXe3JQL7SXhag9qjF+lP5qn6XGrv7WryhZDf/SsgSHDYwMc2vXzwWDfNokT4ozfSfdv7PEcxCIQ+Q7MtZv68MijLxpwKjMDpO6x+EdnhWGcGIDa29eB25IKmYQbD1sw5W2Vb8CiUKq1pTPw6Du1hEkBkE0Tof3tr4UnzevuYxK4DGQWyYjM4bk9TGpBIHC4hwLosxigDAFQOlpwLNnYBiI0rsMrdDmAw4VlzuP7q1AM7FKk14Ka/J5RzJpItjxrkwuGacSJMNyS0d7pIzPTj77+kjhYEtoK3DomBTzDy2Az5KdxwUg6i9OG9/4WFe8pT/wV/qQCPcZ7oiyHOxoSx2vMWxrSG0KmP+fnL/9P0VDS2MbMBJQIRT/tGTiHMx4XAKJ9qAlyl8PpPcnDmX396AADBPWNDujhulXY6M/8kX2c9vQmkuNZ8Ln9fR+CUHJizqT4AyL3VEJPjZv3u0uf5+g3R4oaeg4Hxei+r+lge4X842QQmqCwwBVEbbYqh7bHlppkHnzA==\",
                    \"threeds2.threeDSServerTransID\": \"afa6be51-db3b-4683-9a98-80ad949c87fa\",
                    \"threeds2.threeDS2DirectoryServerInformation.algorithm\": \"RSA\",
                    \"threeds2.threeDS2DirectoryServerInformation.directoryServerId\": \"F013371337\",
                    \"threeds2.threeDS2DirectoryServerInformation.publicKey\": \"eyJrdHkiOiJSU0EiLCJlIjoiQVFBQiIsIm4iOiI4VFBxZkFOWk4xSUEzcHFuMkdhUVZjZ1g4LUpWZ1Y0M2diWURtYmdTY0N5SkVSN3lPWEJqQmQyaTBEcVFBQWpVUVBXVUxZU1FsRFRKYm91bVB1aXVoeVMxUHN2NTM4UHBRRnEySkNaSERkaV85WThVZG9hbmlrU095c2NHQWtBVmJJWHA5cnVOSm1wTTBwZ0s5VGxJSWVHYlE3ZEJaR01OQVJLQXRKeTY3dVlvbVpXV0ZBbWpwM2d4SDVzNzdCR2xkaE9RUVlQTFdybDdyS0pLQlUwNm1tZlktUDNpazk5MmtPUTNEak02bHR2WmNvLThET2RCR0RKYmdWRGFmb29LUnVNd2NUTXhDdTRWYWpyNmQyZkppVXlqNUYzcVBrYng4WDl6a1c3UmlxVno2SU1qdE54NzZicmg3aU9Vd2JiWmoxYWF6VG1GQ2xEb0dyY2JxOV80NncifQ==\"
                }
            }
            """
        
        return Data(example.utf8).base64EncodedString()
    }
}
