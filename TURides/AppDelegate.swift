//
//  AppDelegate.swift
//  TURides
//
//  Created by Dennis Hui on 12/04/15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LogoutServiceDelegate {

    var window: UIWindow?

    func showLoginScreen() {
        let storyboard  = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("root") as! UINavigationController
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }
    
    func showHomeScreen() {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("root") as! UITabBarController
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }
    
    //MARK: Logout
    func logout() {
        var params = NSMutableDictionary()
        params.setValue(KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY), forKey: Constant.KEYCHAIN_KEY_APIKEY)
        LogoutService(delegate: self).dispathWithParams(params)
    }
    
    func handleLogoutFail() {
        
    }
    
    func handleLogoutSuccess() {
        KeyChainUtil.delete(Constant.KEYCHAIN_KEY_APIKEY)
        showLoginScreen()
    }
    
    //MARK: Application Lifecycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showHomeScreen", name: Constant.NOTIFICATION_SHOW_HOME_SCREEN, object: nil)
        
        if let token = KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY) {
            showLoginScreen()
        } else {
            showLoginScreen()
        }
        
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

