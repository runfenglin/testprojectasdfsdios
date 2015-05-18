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
        static let KEY_DATA = "data"
        static let KEY_NAME = "name"
        static let KEY_ID = "id"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
    }
    
    //MARK: Facebook Login
    @IBAction func facebookImageViewTapped(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() != nil && false{
            //Handle already logged in
            doFacebookLogin()
        } else {
            FBSDKLoginManager().logOut()
            
            FBSDKLoginManager().logInWithReadPermissions(mConstant.FACEBOOK_PERMISSION, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    UIUtil.showPopUpErrorDialog("Facebook login error: \(error)")
                } else if result.isCancelled {
                    UIUtil.showPopUpErrorDialog("Facebook login User cancelled")
                } else {
                    self.doFacebookLogin()
                }
            })
        }
    }
    
    private func doFacebookLogin() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = FacebookLoginService.mConstant.LOADING_MESSAGE
        let params = NSMutableDictionary()
        params.setValue(FBSDKAccessToken.currentAccessToken().tokenString, forKey: FacebookLoginService.mConstant.PAREMETER_KEY_TOKEN)
        params.setValue("json", forKey: "format")
        FacebookLoginService(delegate: self).dispathWithParams(params)
    }
    
    //MARK: FacebookLoginServiceDelegate
    func handleFacebookLoginSuccess(apikey: NSString, isNewUser: Bool) {
        KeyChainUtil.set(Constant.KEYCHAIN_KEY_APIKEY, value: apikey as String)
        if isNewUser {
            FBSDKGraphRequest(graphPath: "me/friends", parameters: nil).startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, responseObject: AnyObject!, error: NSError!) -> Void in
                    var friends = NSMutableArray()
                
                    if (error == nil) {
                        let resultDict = responseObject as! NSDictionary
                        let resultArray = resultDict.objectForKey(mConstant.KEY_DATA) as! NSMutableArray
                        
                        for friend in resultArray {
                            let fbFriend = FBFriend(
                                name: friend.objectForKey(mConstant.KEY_NAME) as! String,
                                id: friend.objectForKey(mConstant.KEY_ID) as! String)
                            friends.addObject(fbFriend)
                        }
                    } else {
                        UIUtil.showPopUpErrorDialog("Facebook get friends error: \(error)")
                }
                
                self.performSegueWithIdentifier(mConstant.SEQUE_TO_INVITE_FRIENDS, sender: friends)
            })
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(Constant.NOTIFICATION_SHOW_HOME_SCREEN, object: nil)
        }
    }
    
    //MARK: Sign Up
    @IBAction func signupButtonTouched(sender: AnyObject) {
        //self.performSegueWithIdentifier(mConstant.SEGUE_TO_SIGN_UP, sender: sender)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.logout()
    }
    
    //MARK: Phone Login
    @IBAction func loginButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier(mConstant.SEGUE_TO_LOGIN, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == mConstant.SEQUE_TO_INVITE_FRIENDS {
            let vc: InviteFacebookFriendsViewController = segue.destinationViewController as! InviteFacebookFriendsViewController
            vc.friends = sender as! NSMutableArray
        }
    }
}
