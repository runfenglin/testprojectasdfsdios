//
//  SelectFriendsTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 7/07/15.
//
//

import UIKit

protocol SelectFriendsTableViewControllerDelegate {
    func didSelectFriends(friends: [String])
}

class SelectFriendsTableViewController: UITableViewController {

    @IBOutlet var selectAllSwitch: UISwitch!
    
    var delegate: SelectFriendsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func postButtonTouched(sender: AnyObject) {
        
        var selectedFriends: [String] = []
        let allFriends: [User] = Session.sharedInstance.friends!
        
        for (var i=0; i < self.tableView.numberOfRowsInSection(0); i++) {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
            if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark {
                let user = allFriends[i]
                
                selectedFriends.append(user.id)
            }
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = "Loading..."
        delegate!.didSelectFriends(selectedFriends)
    }
    
    @IBAction func selectAllSwitchValueChanged(sender: AnyObject) {
        self.tableView .reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friends = Session.sharedInstance.friends {
            return friends.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("select-friends-cell", forIndexPath: indexPath) as! FriendTableViewCell

        cell.configureCell(Session.sharedInstance.friends![indexPath.row])
        if selectAllSwitch.on {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }

}
