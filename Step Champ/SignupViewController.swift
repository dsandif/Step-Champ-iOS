//
//  SignupViewController.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/15/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit
import Material
import SwiftyJSON

class SignupViewController: UIViewController {
    
    @IBOutlet weak var backButton: RaisedButton!
    @IBOutlet weak var signupButton: RaisedButton!
    @IBOutlet weak var firstnameField: TextField!
    @IBOutlet weak var lastnameField: TextField!
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var emailField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signupButtonPressed(sender: RaisedButton) {
        if firstnameField.text == ""{
            firstnameField.detailLabel.highlighted = true
        }
        else if lastnameField.text == ""{
            lastnameField.detailLabel.highlighted = true
        }
        else if usernameField.text == ""{
            usernameField.detailLabel.highlighted = true
        }
        else if passwordField.text == ""{
            passwordField.detailLabel.highlighted = true
        }
        else if emailField.text == ""{
            emailField.detailLabel.highlighted = true
        }
        else{
            let user = NewUser(firstname: firstnameField.text!,lastname: lastnameField.text!,username: usernameField.text!,password: passwordField.text!,email: emailField.text!)
            
            Endpoints.apiManager.createNewUser(user){ response in
                print(response)
                if response["success"].boolValue == true{
                    let message = response["message"].stringValue
                    self.messagePopup(message)

                    SharingManager.sharedInstance.keychain["authtoken"] = response["token"].stringValue
                    SharingManager.sharedInstance.keychain["username"] = response["user"]["username"].stringValue
                    SharingManager.sharedInstance.keychain["password"] = self.passwordField.text
                    
                    self.signupButton.enabled = false
                    self.signupButton.hidden = true
                    self.backButton.setTitle("Login!", forState: .Normal)
                }
                else{
                    
                    let message = response["message"].stringValue
                    self.messagePopup(message)
                }
            }
        }
    }
    
    func messagePopup(message: String){
        //create the next scene
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let errorPopupViewController = storyboard.instantiateViewControllerWithIdentifier("ErrorPopupViewController") as?
        ErrorPopupViewController
        
        errorPopupViewController?.popupMessage = message
        
        // Load search scene
        errorPopupViewController?.modalInPopover = true
        errorPopupViewController?.modalPresentationStyle = .OverCurrentContext
        errorPopupViewController?.modalTransitionStyle = .CrossDissolve
        presentViewController(errorPopupViewController!, animated: true, completion: nil)
    }
}