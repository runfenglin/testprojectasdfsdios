//
//  InviteFacebookFriendsViewController.swift
//  TURides
//
//  Created by Dennis Hui on 22/04/15.
//
//

import UIKit

class InviteFacebookFriendsViewController: BaseViewController, FBSDKAppInviteDialogDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mTableView: UITableView!
    var isFacebookFriendsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func skipButtonTouched(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showHomeScreen()
    }
    
    @IBAction func inviteButtonTouched(sender: AnyObject) {
        let dialog = FBSDKAppInviteDialog.showWithContent(FBSDKAppInviteContent(appLinkURL: NSURL(string: "https://thevoiceofonedotorg.files.wordpress.com/2015/02/lck75xpca.jpeg")), delegate: self)
        if dialog.canShow() {
            dialog.show()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isFacebookFriendsLoaded ? 1 : 0
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "3 Friends on TURide"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! UITableViewCell
    }
    
    //MARK: FBSDKAppInviteDialog Delegate
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        
    }
}
