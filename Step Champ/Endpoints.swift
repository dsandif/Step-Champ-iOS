//
//  Endpoints.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/6/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Endpoints{
    
    //STATIC/GLOBAL INSTANCE
    static var  apiManager = Endpoints()
    
    // **** ENDPOINT URLS ****
    
    var loginEndpoint = "http://www.step-champ.com/login"
    
    var userEndpoint = SharingManager.sharedInstance.baseDomain + "/user"
    
    var searchUsersEndpoint = SharingManager.sharedInstance.baseDomain + "/search/users/?term="
    
    var syncStepsEndpoint = SharingManager.sharedInstance.baseDomain + "/test"
    
    func login(username: String, password: String, completion: (JSON) -> ()) {
        let headers = [
            "Accept": "application/json",
        ]
        
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, self.loginEndpoint, headers: headers,parameters: parameters).validate().responseJSON { response in print(response)
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(json)
                }
            case .Failure(let error):
                print(error)
                
            }
        }
    }
    
    func createNewUser (newUser: NewUser, completion: (JSON) -> ()) {
        let headers = [
            "Accept": "application/json",
        ]
        
        let parameters = [
            "firstname": newUser.firstname,
            "lastname": newUser.lastname,
            "username": newUser.username,
            "password": newUser.password,
            "email": newUser.email
        ]
        
        Alamofire.request(.POST, self.userEndpoint, headers: headers,parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    completion(json)
                }
            case .Failure(let error):
                print(error)
                
            }
        }
    }
    
    func searchUsers(term:String, completion: (JSON) ->()) {
        
        let headers = [
            "Authorization": SharingManager.sharedInstance.keychain["authtoken"]!
        ]
    
        Alamofire.request(.GET, self.searchUsersEndpoint+term, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(json)
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func syncSteps(steps steps: [JSON], completion:(JSON) ->()) {

        let headers = [
            "Authorization": SharingManager.sharedInstance.keychain["authtoken"]!
        ]
        
        let parameters = ["steps": String(steps)]
        
        Alamofire.request(.POST, self.syncStepsEndpoint, headers: headers, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(json)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
