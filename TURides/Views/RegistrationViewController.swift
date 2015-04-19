//
//  RegistrationViewController.swift
//  TURides
//
//  Created by Dennis Hui on 12/04/15.
//
//

import UIKit

class RegistrationViewController: BaseViewController, FacebookLoginServiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
    }
    
    //MARK: Facebook Login
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
    
    func handleFacebookLoginSuccess(apikey: NSString) {
        KeyChainUtil.set(Constant.KEYCHAIN_KEY_APIKEY, value: apikey as String)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        delegate.showHomeScreen()
    }
    
    func getUserInfo() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result:
            AnyObject!, error: NSError!) -> Void in
            if error != nil {
                
            } else if result == nil {
                
            } else {
                NSLog("\(result)")
                let userInfo = result as! NSDictionary
                let userID: AnyObject? = userInfo.objectForKey("id")
                let email: AnyObject? = userInfo.objectForKey("email")
                let token: AnyObject? = FBSDKAccessToken.currentAccessToken().tokenString
                
                if userID != nil && email != nil && token != nil {
                    let params = NSMutableDictionary()
                    
                    params.setValue(userID, forKey: FacebookLoginService.PARAMETER_KEY_USERNAME)
                    params.setValue(email, forKey: FacebookLoginService.PARAMETER_KEY_EMAIL)
                    params.setValue(token, forKey: FacebookLoginService.PARAMETER_KEY_TOKEN)
                    
                    FacebookLoginService(delegate: self).dispathWithParams(params)
                }
                
            }
        }
    }
    
    //MARK: Sign Up
    @IBAction func signupButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("to-signup", sender: sender)
    }
    
    //MARK: Phone Login
    @IBAction func loginButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("to-login", sender: sender)
    }
}
