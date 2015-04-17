//
//  RegistrationViewController.swift
//  TURides
//
//  Created by Dennis Hui on 12/04/15.
//
//

import UIKit

class RegistrationViewController: BaseViewController, RegistrationServiceDelegate, FacebookLoginServiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
    }
    
    func getUserInfo() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: 
            AnyObject!, error: NSError!) -> Void in
            if error != nil {
                
            } else if result == nil {
                
            } else {
                println("\(result)")
                let userInfo = result as! NSDictionary
                let userID: AnyObject? = userInfo.objectForKey("id")
                let email: AnyObject? = userInfo.objectForKey("email")
                let token: AnyObject? = FBSDKAccessToken.currentAccessToken().tokenString
                
                if userID != nil && email != nil && token != nil {
                    println("\(userID)")
                    println("\(email)")
                    println("\(token)")
                   
                    let params = NSMutableDictionary()
                    
                    params.setValue(userID, forKey: "username")
                    params.setValue(email, forKey: "email")
                    params.setValue(token, forKey: "token")
                    
                    FacebookLoginService(delegate: self).dispathWithParams(params)
                }
                
            }
        }
    }
    
    @IBAction func facebookImageViewTapped(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            //Handle already logged in
            getUserInfo()
        } else {
            let facebookReadPermissions = ["public_profile", "email", "user_friends"]
            FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    //Handle Error
                } else if result.isCancelled {
                    //Handle Cancelled
                } else {
                    self.getUserInfo()
                }
            })
            
        }
    }
    
    @IBAction func signupButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("to-signup", sender: sender)
    }
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("to-login", sender: sender)
    }
    
    func handleRegistrationSuccess() {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.showHomeScreen()
    }
    
    func handleRegistrationFail() {
        
    }
    
    func handleFacebookLoginFaile() {
        
    }
    
    func handleFacebookLoginSuccess() {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        MBProgressHUD.hideHUDForView(self.view, animated: true)
       // delegate.showHomeScreen()
    }
}
