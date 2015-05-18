//
//  HomeViewController.swift
//  TURides
//
//  Created by Dennis Hui on 16/04/15.
//
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, GetActivityServiceDelegate, GetUserProfileServiceDelegate {
    @IBOutlet weak var mTableView: UITableView!
    
    var data: [CheckInActivity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        GetActivityService(delegate: self).dispathWithParams(NSDictionary())
        //GetUserProfileService(delegate: self).dispatchWithParams(NSDictionary())
        
        mTableView.registerNib(UINib(nibName: "TUTableViewCellType1TableViewCell", bundle: nil), forCellReuseIdentifier: "TUTableViewCellType1TableViewCell")
    }
    
    @IBAction func menuBarItemTouched(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showMenu();
    }

    @IBAction func checkInButtonTouched(sender: AnyObject) {
        let storyboard  = UIStoryboard(name: "CheckIn", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("root") as! UINavigationController

        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonTouched(sender: AnyObject) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let checkin = data[indexPath.row] as CheckInActivity
        if let message = checkin.message {
            let cell = tableView.dequeueReusableCellWithIdentifier("TUTableViewCellType1TableViewCell") as! TUTableViewCellType1TableViewCell
            cell.nameLabel.text = checkin.user.name
            cell.placeLabel.text = checkin.place.name
            
            let lable = UILabel(frame: CGRectMake(0, 0, cell.commentWrapperView.frame.width-20, 0))
            lable.numberOfLines = 0
            lable.text = message
            lable.sizeToFit()
            
            return 70 + lable.frame.height
        } else {
            return 70
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TUTableViewCellType1TableViewCell") as! TUTableViewCellType1TableViewCell
        
        let checkin = data[indexPath.row] as CheckInActivity
        
        cell.nameLabel.text = checkin.user.name
        cell.placeLabel.text = checkin.place.name
        cell.numberOfLikesLabel.text = checkin.numberOfLikes.stringValue
        
        if let comment = checkin.message {
            let lable = UILabel(frame: CGRectMake(0, 0, cell.commentWrapperView.frame.width-20, 20))
            lable.numberOfLines = 0
            lable.text = comment
            lable.sizeToFit()
      
            var frame = cell.commentWrapperView.frame
            frame.size.height = lable.frame.size.height
            cell.commentWrapperView.frame = frame
            cell.commentWrapperView.addSubview(lable)
        }

        return cell
    }
    
    //MARK:
    func handleGetActivityServiceServiceFail() {
        //TODO
    }
    
    func handleGetActivityServiceSuccess(activities: [CheckInActivity]) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        data = activities
        mTableView.reloadData()
    }
    
    //MARK:
    func handleGetUserProfileServiceSucess() {
        GetActivityService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    func handleGetUserProfileServiceFail() {
        //TODO
    }
    
    
    //MARK: Temperary Logout
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        var actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Yes")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = LogoutService.mConstant.LOADING_MESSAGE
            appDelegate.logout()
        }
    }
}
