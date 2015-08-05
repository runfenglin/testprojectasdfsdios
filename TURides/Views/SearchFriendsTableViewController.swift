//
//  SearchFriendsTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 2/08/15.
//
//

import UIKit

class SearchFriendsTableViewController: UITableViewController, UISearchBarDelegate, SearchFriendsServiceDelegate, AddFriendRequestServiceDelegate {

    @IBOutlet var mSearchBar: UISearchBar!
    
    var friends: [User] = []
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mSearchBar.becomeFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if (count(mSearchBar.text) > 2) {
            let params = NSMutableDictionary()
            params.setValue(mSearchBar.text, forKey: "keyword")
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            SearchFriendsService(delegate: self).dispathWithParams(params)
        } else {
            UIUtil.showPopUpErrorDialog("Your search must have at least 3 charactors!")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friend = friends[indexPath.row]
        selectedIndex = indexPath.row
        let params = NSMutableDictionary()
        params.setValue(friend.id, forKey: "id")
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        AddFriendRequestService(delegate: self).dispathWithParams(params)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        let friend: User = friends[indexPath.row]

        // Configure the cell...
        cell.imageView?.image = friend.profileIcon
        cell.textLabel?.text = friend.name
        return cell
    }
    
    func handleAddFriendRequestFail() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func handleAddFriendRequestSuccess() {
        friends.removeAtIndex(selectedIndex!)
        self.tableView.reloadData()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func handleSearchFriendsFail() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func handleSearchFriendsSuccess(friends: NSArray) {
        self.friends = friends as! [User]
        self.tableView.reloadData()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

}
