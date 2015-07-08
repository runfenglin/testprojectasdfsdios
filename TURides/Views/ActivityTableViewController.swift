//
//  ActivityTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class ActivityTableViewController: UITableViewController, GetTripServiceDelegate, GetPairedTripServiceDelegate, GetTripOffersServiceDelegate {

    var allTrip: [Trip] = []
    var myTrip: [Trip] = []
    var pairedTrip: [Trip] = []
    var selectedTrip: Trip?
    var tripOffers: [TripOffer] = []
    
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
        if allTrip.count == 0 && myTrip.count == 0 && pairedTrip.count == 0 {
            return 0
        } else {
            return 3
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pairedTrip.count
        } else if (section == 1){
            return myTrip.count
        } else {
            return allTrip.count
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My Rides"
        } else if section == 1 {
            return "My Trip Requests"
        } else {
            return "Friends Trip Requests"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TripTableViewCell = tableView.dequeueReusableCellWithIdentifier("tripTableViewCell", forIndexPath: indexPath) as! TripTableViewCell
        
        let trip: Trip
        if indexPath.section == 0 {
            trip = pairedTrip[indexPath.row]
        } else if indexPath.section == 1 {
            trip = myTrip[indexPath.row]
        } else {
            trip = allTrip[indexPath.row]
        }
        
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
        if indexPath.section == 0 {
            selectedTrip = pairedTrip[indexPath.row]
        } else if indexPath.section == 1 {
            selectedTrip = myTrip[indexPath.row]
            if selectedTrip!.numberOfOffers > 0 {
                let params = NSMutableDictionary()
                params.setValue(selectedTrip!.tripID, forKey: "id")
                MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = "Loading..."
                GetTripOffersService(delegate: self).dispathWithParams(params)
            } else {
                let alertVC = UIAlertController(title: "Notice", message: "No Offers!", preferredStyle: UIAlertControllerStyle.Alert)
                var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                }
                alertVC.addAction(okAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
            }
        } else {
            selectedTrip = allTrip[indexPath.row]
            self.performSegueWithIdentifier("to-trip-details", sender: nil)
        }
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Accept", handler:{action, indexpath in
            println("MORE•ACTION");
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            println("DELETE•ACTION");
        });
        
        return [deleteRowAction, moreRowAction];
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        } else if segue.identifier == "to-pick-driver" {
            var destinationVC = segue.destinationViewController as! PickDriverViewController
            destinationVC.offers = self.tripOffers
        }
    }
    
    func handleGetTripFail() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func handleGetTripSuccess(trips: [Trip]) {
        myTrip.removeAll(keepCapacity: true)
        allTrip.removeAll(keepCapacity: true)
        for trip in trips {
            if trip.orgnizer.name == Session.sharedInstance.me?.name {
                myTrip.append(trip)
            } else {
                allTrip.append(trip)
            }
        }
        GetPairedTripService(delegate: self).dispathWithParams(NSDictionary())
        //self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
       
    }
    
    func handleGetPairedTripFail() {
         MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func handleGetPairedTripSuccess(trips: [Trip]) {
        pairedTrip = trips
        self.tableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
    }
    
    func GetTripOffersSuccess(offers: [TripOffer]) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.tripOffers = offers
        self.performSegueWithIdentifier("to-pick-driver", sender: nil)
    }
    
    func GetTripOffersFail() {
        
    }
}
