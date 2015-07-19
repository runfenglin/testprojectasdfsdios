//
//  GroupTripDetailsViewController.swift
//  TURides
//
//  Created by Dennis Hui on 14/07/15.
//
//

import UIKit

class GroupTripDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet var tripLabel: UILabel!
    
    var trip: GroupTrip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var label = "From: \(trip!.departure.name)\nTo: \(trip!.destination.name)\nDate: \(trip!.departureTime)"
        tripLabel.text = label

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func joinAsPassengerButtonTouched(sender: AnyObject) {
        let nvc = UIStoryboard(name: "JoinAsPassenger", bundle: nil).instantiateViewControllerWithIdentifier("main") as! UINavigationController
        nvc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let vc = nvc.viewControllers[0] as! JoinAsPassengerTableViewController
        vc.tripToJoin = self.trip
        let pop = nvc.popoverPresentationController
        pop?.delegate = self
        pop?.sourceView = self.view
        pop?.sourceRect = self.view.frame
        pop?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    @IBAction func joinAsDriverButtonTouched(sender: AnyObject) {
        UIUtil.showPopUpErrorDialog("Join as driver API not ready")
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Orgnizer"
        case 1:
            return "Drivers"
        case 2:
            return "Passengers"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            if let count = trip?.drivers?.count {
                return count
            } else {
                return 0
            }
        case 2:
            if let count = trip?.passengers?.count {
                return count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("userCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "userCell")
        }
        cell!.imageView!.image = trip?.orgnizer.profileIcon
        cell?.textLabel?.text = trip?.orgnizer.name
        return cell!
    }
}
