//
//  InviteFacebookFriendsViewController.swift
//  TURides
//
//  Created by Dennis Hui on 22/04/15.
//
//

import UIKit

class InviteFacebookFriendsViewController: BaseViewController, FBSDKAppInviteDialogDelegate, UITableViewDataSource, UITableViewDelegate {

    struct mConstant  {
        static let VIEW_TAG_FRIEND_IMAGE = 10
        static let VIEW_TAG_FRIEND_NAME = 11
        static let CELL_ID_FRIEND = "friend-cell"
        static let APP_STORE_URL = "http://www.google.co.nz"
    }
    
    @IBOutlet weak var mTableView: UITableView!
    var friends: NSArray = NSArray();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        mTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func skipButtonTouched(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(Constant.NOTIFICATION_SHOW_HOME_SCREEN, object: nil)
    }
    
    @IBAction func inviteButtonTouched(sender: AnyObject) {
        let dialog = FBSDKAppInviteDialog.showWithContent(FBSDKAppInviteContent(appLinkURL: NSURL(string: mConstant.APP_STORE_URL)), delegate: self)
        if dialog.canShow() {
            dialog.show()
        }
    }
    
    //MARK: UITableViewDataSource/Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "You have \(friends.count) Friends on TURide"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(mConstant.CELL_ID_FRIEND, forIndexPath: indexPath) as! UITableViewCell
        let friend = friends.objectAtIndex(indexPath.row) as! FBFriend
        
        let imageView = cell.viewWithTag(mConstant.VIEW_TAG_FRIEND_IMAGE) as! UIImageView
        let label = cell.viewWithTag(mConstant.VIEW_TAG_FRIEND_NAME) as! UILabel
        
        imageView.setImageWithURL(NSURL(string: friend.iconUrl))
        label.text = friend.name
       
        return cell
    }
    
    //MARK: FBSDKAppInviteDialog Delegate
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        NSNotificationCenter.defaultCenter().postNotificationName(Constant.NOTIFICATION_SHOW_HOME_SCREEN, object: nil)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        NSNotificationCenter.defaultCenter().postNotificationName(Constant.NOTIFICATION_SHOW_HOME_SCREEN, object: nil)
    }
}
