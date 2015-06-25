//
//  ActivityTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class ActivityTableViewController: UITableViewController, GetTripServiceDelegate {

    var allTrip: [Trip] = []
    var myTrip: [Trip] = []
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = GetTripService.mConstant.LOADING_MESSAGE
        GetTripService(delegate: self).dispathWithParams(NSDictionary())

        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("getTrips"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }

    func getTrips() {
        GetTripService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if allTrip.count == 0 && myTrip.count == 0 {
            return 0
        } else {
            return 2
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return allTrip.count
        } else {
            return myTrip.count
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return section == 0 ? "All Trips" : "My Trips"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TripTableViewCell = tableView.dequeueReusableCellWithIdentifier("tripTableViewCell", forIndexPath: indexPath) as! TripTableViewCell
        
        let trip: Trip = indexPath.section == 0 ? allTrip[indexPath.row] as Trip : myTrip[indexPath.row] as Trip
        
        cell.configureCellWithTrip(trip)
        
        cell.tripOrgnizerImageView.image = trip.orgnizer.profileIcon
        
        var mDateFormatter: NSDateFormatter = NSDateFormatter()
        mDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        mDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var lblText = "From: "
        lblText = lblText.stringByAppendingString(trip.departure.name)
        lblText = lblText.stringByAppendingString("\nTo: ")
        lblText = lblText.stringByAppendingString(trip.destination.name)
        lblText = lblText.stringByAppendingString("\n")
        lblText = lblText.stringByAppendingString(mDateFormatter.stringFromDate(trip.departureTime))
        cell.tripRouteLabel.text = lblText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedTrip = data[indexPath.row]
        self.performSegueWithIdentifier("to-trip-details", sender: nil)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "to-trip-details" {
            var destinationVC = segue.destinationViewController as! TripDetailsViewController
            destinationVC.trip = selectedTrip
        }
    }
    
    func handleGetTripFail() {
        
    }
    
    func handleGetTripSuccess(trips: [Trip]) {
        for trip in trips {
            if trip.orgnizer.name == Session.sharedInstance.me?.name {
                myTrip.append(trip)
            } else {
                allTrip.append(trip)
            }
        }
        //data = trips
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
