//
//  AppDelegate.swift
//  TURides
//
//  Created by Dennis Hui on 12/04/15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LogoutServiceDelegate, REFrostedViewControllerDelegate, UpdateDeviceTokenServiceDelegate {

    var window: UIWindow?

    private func showLoginScreen() {
        let storyboard  = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("root") as! UINavigationController
        
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }
    
    func showHomeScreen() {
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
       
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("root") as! UITabBarController
        
        let frostedViewController = REFrostedViewController(contentViewController: vc, menuViewController: MenuViewController(nibName: "MenuViewController", bundle: nil))
        frostedViewController.direction = REFrostedViewControllerDirection.Left;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyle.Dark;
        frostedViewController.liveBlur = false
        frostedViewController.delegate = self
        
        window!.rootViewController = frostedViewController
        window!.makeKeyAndVisible()
    }
    
    func showMenu() {
        let vc = window!.rootViewController as! REFrostedViewController
        vc.presentMenuViewController()
    }
    
    func hideMenu() {
        let vc = window!.rootViewController as! REFrostedViewController
        vc.hideMenuViewController()
    }
    
    //MARK: -
    //MARK: ==========Logout==========
    //MARK: -
    func logout() {
        var params = NSMutableDictionary()
        params.setValue(KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY), forKey: Constant.KEYCHAIN_KEY_APIKEY)
        LogoutService(delegate: self).dispathWithParams(params)
    }
    
    func handleLogoutFail() {
        
    }
    
    func handleLogoutSuccess() {
        KeyChainUtil.delete(Constant.KEYCHAIN_KEY_APIKEY)
        FBSDKLoginManager().logOut()
        showLoginScreen()
    }
    
    //MARK: -
    //MARK: ==========Push Notification==========
    //MARK: -
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println(deviceToken)
        let service = UpdateDeviceTokenService(delegate: self)
        let params = NSMutableDictionary();
        
        var str: String = String()
        let p = UnsafePointer<UInt8>(deviceToken.bytes)
        let len = deviceToken.length
        
        for var i=0; i<len; ++i {
            str += String(format: "%02.2X", p[i])
        }
        
        //let a = NSString(data: deviceToken, encoding:NSUTF8StringEncoding)
        params.setValue(str, forKey: "device_token")
        service.dispathWithParams(params)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error)
        
    }
    
    func updateDeviceTokenSuccess() {
        println("updateDeviceTokenSuccess");
    }
    
    func updateDeviceTokenFail() {
        
    }
    
    //MARK: -
    //MARK: ==========Application Lifecycle==========
    //MARK: -
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showHomeScreen", name: Constant.NOTIFICATION_SHOW_HOME_SCREEN, object: nil)
        //FBSDKLoginManager().logOut()

        if let token = KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY) {
            //KeyChainUtil.delete(Constant.KEYCHAIN_KEY_APIKEY)
            //FBSDKLoginManager().logOut()
            showHomeScreen()
            //GetUserProfileService(delegate: self).dispatchWithParams(NSDictionary())
        } else {
            showLoginScreen()
        }
        
        UITabBar.appearance().tintColor = UIColor(netHex: 0x3F5C73)
        UINavigationBar.appearance().barTintColor = UIColor(netHex: 0x3F5C73)
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

