//
//  HomeViewController.swift
//  TURides
//
//  Created by Dennis Hui on 16/04/15.
//
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    @IBOutlet weak var mTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.registerNib(UINib(nibName: "TUTableViewCellType1TableViewCell", bundle: nil), forCellReuseIdentifier: "TUTableViewCellType1TableViewCell")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return tableView.dequeueReusableCellWithIdentifier("TUTableViewCellType1TableViewCell") as! UITableViewCell
    }
    
    //MARK: Temperary Logout
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        var actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Yes")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            appDelegate.logout()
        }
    }

}
