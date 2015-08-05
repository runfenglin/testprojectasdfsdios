//
//  FriendsTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 2/08/15.
//
//

import UIKit

class FriendsTableViewController: UITableViewController, GetNewFriendRequestServiceDelegate, FriendTableViewCellDelegate, AcceptAddFriendRequestServiceDelegate, DeclineAddFriendRequestServiceDelegate {
    
    var newFriendsRequests: [User] = []
    var friendToAdd: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        GetNewFriendRequestService(delegate: self).dispathWithParams(NSDictionary())
    }

    @IBAction func addButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("to-add-friends", sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if newFriendsRequests.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if newFriendsRequests.count > 0 {
            return section == 0 ? "New Friend Request" : "My Friends"
        } else {
            return "My Friends"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newFriendsRequests.count > 0 && section == 0 {
            return newFriendsRequests.count
        } else {
        
            if let friends = Session.sharedInstance.friends {
                return friends.count
            } else {
                return 0
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var friend: User
        
        if newFriendsRequests.count > 0 && indexPath.section == 0 {
            friend = newFriendsRequests[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("newFriendsCell", forIndexPath: indexPath) as! FriendTableViewCell
            cell.configureCell(friend)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! UITableViewCell
            friend = Session.sharedInstance.friends![indexPath.row]
            cell.imageView!.image = friend.profileIcon
            cell.textLabel!.text = friend.name
            return cell
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func handleGetNewFriendRequestFail() {
        
    }
    
    func handleGetNewFriendRequestSuccess(friends: NSArray) {
        newFriendsRequests = friends as! [User]
        self.tableView.reloadData()
    }
    
    func didAccept(user: User) {
        let params = NSMutableDictionary()
        params.setValue(user.id, forKey: "id")
        friendToAdd = user
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        AcceptAddFriendRequestService(delegate: self).dispathWithParams(params)
    }
    
    func didDecline(user: User) {
        let params = NSMutableDictionary()
        params.setValue(user.id, forKey: "id")
        DeclineFriendRequestService(delegate: self).dispathWithParams(params)
        for var i=0; i < newFriendsRequests.count; i++ {
            if newFriendsRequests[i].id == user.id {
                newFriendsRequests.removeAtIndex(i)
                self.tableView.reloadData()
                return
            }
        }
       
    }
    
    func handleAcceptAddFriendRequestFail() {
        TULog.Log("handleAcceptAddFriendRequestFail")
    }
    
    func handleAcceptAddFriendRequestSuccess() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        Session.sharedInstance.friends?.append(friendToAdd!)
        for var i=0; i < newFriendsRequests.count; i++ {
            if newFriendsRequests[i].id == friendToAdd!.id {
                newFriendsRequests.removeAtIndex(i)
                break
            }
        }
        self.tableView.reloadData()
        TULog.Log("handleAcceptAddFriendRequestSuccess")
    }
    
    func handleDeclineAddFriendRequestFail() {
        TULog.Log("handleDeclineAddFriendRequestFail")
    }
    
    func handleDeclineAddFriendRequestSuccess() {
        TULog.Log("handleDeclineAddFriendRequestSuccess")
    }

}
