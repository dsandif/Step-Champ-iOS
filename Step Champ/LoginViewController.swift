//
//  LoginViewController.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/2/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import UIKit
import SwiftyJSON
import Material
import KeychainAccess
import Spring
import HealthKit

class LoginViewController: UIViewController {

    @IBOutlet weak var animatedLogo: SpringImageView!
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var loginButton: MaterialButton!
    @IBOutlet weak var signUpButton: MaterialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedLogo.animation = "pop"
        animatedLogo.curve = "easeInQuad"
        animatedLogo.force = 2.6
        animatedLogo.duration = 2.3
        animatedLogo.animate();
        if(SharingManager.sharedInstance.keychain["username"] != nil && (SharingManager.sharedInstance.keychain["password"] == nil) != nil){
            usernameField.text = SharingManager.sharedInstance.keychain["username"]
            passwordField.text = SharingManager.sharedInstance.keychain["password"]
            
            loginButtonPressed(loginButton)
        }
        
    }

    @IBAction func loginButtonPressed(sender: MaterialButton) {
        if (usernameField.text == "") {
            usernameField.detailLabel.text = "Please enter your username"
        }
        else if (passwordField.text == "") {
            passwordField.detailLabel.text = "Please enter your password"
        }else{
            Endpoints.apiManager.login(usernameField.text!, password: passwordField.text!){ response in
                if response["success"].boolValue == true{

                    //save the auth token
                    SharingManager.sharedInstance.keychain["authtoken"] = response["token"].stringValue
                    SharingManager.sharedInstance.keychain["username"] = self.usernameField.text
                    SharingManager.sharedInstance.keychain["password"] = self.passwordField.text

                    //create the next scene
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabViewController = storyboard.instantiateViewControllerWithIdentifier("TabViewController")
                    
                    // Load search scene
                    self.presentViewController(tabViewController, animated: true, completion: nil)
                }else{
                    
                    let message = response["message"].stringValue
                    self.errorPopup(message)
                    
                }
            }
        }
    }
    
    func errorPopup(message: String){
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
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

