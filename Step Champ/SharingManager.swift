//
//  SharingManager.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/6/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftyJSON
import HealthKit

class SharingManager{
    var keychain = Keychain(service: "com.Step-Champ")
        .label("Step-Champ iOS Credentials")
        .synchronizable(true)
    var currentUsername = ""
    
    //base domain for all api endpoints
    var baseDomain: String = "http://www.step-champ.com/api/v1"
    
    static var sharedInstance = SharingManager()
}
