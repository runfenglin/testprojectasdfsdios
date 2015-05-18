//
//  MenuViewController.swift
//  TURides
//
//  Created by Dennis Hui on 11/05/15.
//
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mTableView: UITableView!

    @IBOutlet weak var profileImageView: CircleImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    let menuArray = ["Home", "Event", "Chat", "Friends", "Invite Friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.image = Session.sharedInstance.me?.profileIcon
        userNameLabel.text = Session.sharedInstance.me?.name

        mTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel!.text = menuArray[indexPath.row]
        cell!.backgroundColor = UIColor.clearColor()
        cell!.contentView.backgroundColor = UIColor.clearColor()
        return cell!
    }
}
