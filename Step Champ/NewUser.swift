//
//  User.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/15/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation


class NewUser {
    var firstname:String
    var lastname:String
    var username:String
    var password:String
    var email:String
    
    init(firstname: String,lastname: String,username: String,password: String,email: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.password = password
        self.email = email
    }
}