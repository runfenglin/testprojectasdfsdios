//
//  RegistrationViewController.swift
//  TURides
//
//  Created by Dennis Hui on 12/04/15.
//
//

import UIKit

class RegistrationViewController: BaseViewController, FacebookLoginServiceDelegate {
    
    struct mConstant {
        static let FACEBOOK_PERMISSION = ["public_profile", "email", "user_friends"]
        static let SEGUE_TO_LOGIN = "to-login"
        static let SEGUE_TO_SIGN_UP = "to-signup"
        static let SEQUE_TO_INVITE_FRIENDS = "to-invite-friends"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
    }
    
    //MARK: Facebook Login
    @IBAction func facebookImageViewTapped(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            //Handle already logged in
            doFacebookLogin()
        } else {
            FBSDKLoginManager().logInWithReadPermissions(mConstant.FACEBOOK_PERMISSION, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    //Handle Error
                } else if result.isCancelled {
                    //Handle Cancelled
                } else {
                    self.doFacebookLogin()
                }
            })
        }
    }
    
    func doFacebookLogin() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let params = NSMutableDictionary()
        params.setValue(FBSDKAccessToken.currentAccessToken().tokenString, forKey: FacebookLoginService.mConstant.PARAMETER_KEY_APIKEY)
        FacebookLoginService(delegate: self).dispathWithParams(params)
    }
    
    func handleFacebookLoginSuccess(apikey: NSString, isNewUser: Bool) {
        KeyChainUtil.set(Constant.KEYCHAIN_KEY_APIKEY, value: apikey as String)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if isNewUser {
            self.performSegueWithIdentifier(mConstant.SEQUE_TO_INVITE_FRIENDS, sender: nil)
        } else {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.showHomeScreen()
        }
    }
    
    //MARK: Sign Up
    @IBAction func signupButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier(mConstant.SEGUE_TO_SIGN_UP, sender: sender)
    }
    
    //MARK: Phone Login
    @IBAction func loginButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier(mConstant.SEGUE_TO_LOGIN, sender: sender)
    }
}
