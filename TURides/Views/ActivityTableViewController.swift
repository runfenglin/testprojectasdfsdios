//
//  ActivityTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class ActivityTableViewController: UITableViewController, GetTripServiceDelegate {

    var data: [Trip] = []
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        GetTripService(delegate: self).dispathWithParams(NSDictionary())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TripTableViewCell = tableView.dequeueReusableCellWithIdentifier("tripTableViewCell", forIndexPath: indexPath) as! TripTableViewCell
        let trip: Trip = data[indexPath.row] as Trip
        
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
        selectedTrip = data[indexPath.row]
        self.performSegueWithIdentifier("to-trip-details", sender: nil)
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
        data = trips
        self.tableView.reloadData()
    }
}
