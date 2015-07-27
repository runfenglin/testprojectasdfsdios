//
//  ActivityTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class ActivityTableViewController: UITableViewController, GetMyTripServiceDelegate, GetTripServiceDelegate, GetPairedTripServiceDelegate, GetTripOffersServiceDelegate, AcceptTripServiceDelegate, GetGroupTripServiceDelegate, CreateTripTableViewControllerDelegate, HideFriendsTripRequestServiceDelegate, DeleteTripServiceServiceDelegate {

    var friendsTripRequests: [Trip] = []
    var myTripRequests: [Trip] = []
    var myGroupTrip: [Trip] = []
    var pairedTrip: [Trip] = []
    var selectedTrip: Trip?
    var tripOffers: [TripOffer] = []
    
    @IBOutlet var tripSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
        self.tableView.estimatedRowHeight = 105
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadTrips",
            name: "SHOULERELOADTRIPS",
            object: nil)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = GetTripService.mConstant.LOADING_MESSAGE
        GetMyTripService(delegate: self).dispathWithParams(NSDictionary())
        //GetGroupTripService(delegate: self).dispathWithParams(NSDictionary())
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("getTrips"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }

    @IBAction func menuButtonTouched(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showMenu();
    }
    
    @IBAction func segmentedControlValueChanged(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    func reloadTrips() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = GetTripService.mConstant.LOADING_MESSAGE
        GetMyTripService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    func getTrips() {
        GetMyTripService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tripSegmentedControl.selectedSegmentIndex == 0 {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tripSegmentedControl.selectedSegmentIndex == 0 {
            if section == 0 {
                return myTripRequests.count
            } else if section == 1 {
                return myGroupTrip.count
            } else {
                return friendsTripRequests.count
            }
        } else {
            return pairedTrip.count
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tripSegmentedControl.selectedSegmentIndex == 0 {
            if section == 0 {
                return "My Trips"
            } else if section == 1 {
                return "Group Trips"
            } else {
                return "Ride Request"
            }
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TripTableViewCell = tableView.dequeueReusableCellWithIdentifier("tripTableViewCell", forIndexPath: indexPath) as! TripTableViewCell
        
        let trip: Trip
        
        if tripSegmentedControl.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                trip = myTripRequests[indexPath.row]
            } else if indexPath.section == 1 {
                trip = myGroupTrip[indexPath.row]
            } else {
                trip = friendsTripRequests[indexPath.row]
            }
        } else {
            trip =  pairedTrip[indexPath.row]
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
        
        let selectedRow = indexPath.row
        let selectedSection = indexPath.section
        
        if tripSegmentedControl.selectedSegmentIndex == 0 {
            if selectedSection == 0 {
                selectedTrip = myTripRequests[selectedRow]
                if selectedTrip?.numberOfOffers > 0 {
                    let params = NSMutableDictionary()
                    params.setValue(selectedTrip!.tripID, forKey: "id")
                    MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = "Loading..."
                    GetTripOffersService(delegate: self).dispathWithParams(params)
                } else {
                    self.performSegueWithIdentifier("to-trip-details", sender: nil)
                }
            } else if selectedSection == 1 {
                selectedTrip = myGroupTrip[selectedRow]
                let vc = GroupTripDetailsViewController(nibName: "GroupTripDetailsViewController", bundle: nil)
                vc.trip = selectedTrip as? GroupTrip
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                selectedTrip = friendsTripRequests[selectedRow]
                self.performSegueWithIdentifier("to-trip-details", sender: nil)
            }
        } else {
            selectedTrip = pairedTrip[selectedRow]
            self.performSegueWithIdentifier("to-trip-details", sender: nil)
        }
        
        
        
//        if indexPath.section == 0 {
//            selectedTrip = pairedTrip[indexPath.row]
//        } else if indexPath.section == 1 {
//            selectedTrip = myTrip[indexPath.row]
//            if selectedTrip!.numberOfOffers > 0 {
//                let params = NSMutableDictionary()
//                params.setValue(selectedTrip!.tripID, forKey: "id")
//                MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = "Loading..."
//                GetTripOffersService(delegate: self).dispathWithParams(params)
//            } else {
//                let alertVC = UIAlertController(title: "Notice", message: "No Offers!", preferredStyle: UIAlertControllerStyle.Alert)
//                var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
//                    UIAlertAction in
//                }
//                alertVC.addAction(okAction)
//                self.presentViewController(alertVC, animated: true, completion: nil)
//            }
//        } else {
//            selectedTrip = allTrip[indexPath.row]
//            self.performSegueWithIdentifier("to-trip-details", sender: nil)
//        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var acceptAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Accept", handler:{action, indexpath in
            let trip = self.friendsTripRequests[indexPath.row]
            let params = NSMutableDictionary()
            params.setValue(trip.tripID, forKey: "trip")
            let service = AcceptTripService(delegate: self)
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            service.dispathWithParams(params)

        });
        acceptAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var aTitle = myGroupTrip[indexPath.row].orgnizer.id == Session.sharedInstance.me!.id ? "Delete" : "Hide"
        
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: aTitle, handler:{action, indexpath in
            let params = NSMutableDictionary()
            if indexPath == 0 {
                params.setValue(self.myTripRequests[indexPath.row].tripID, forKey: "id")
                DeleteTripService(delegate: self).dispathWithParams(params)
            } else {
                let trip = self.myGroupTrip[indexPath.row]
                if trip.orgnizer.id == Session.sharedInstance.me?.id {
                    params.setValue(self.myGroupTrip[indexPath.row].tripID, forKey: "id")
                    DeleteTripService(delegate: self).dispathWithParams(params)
                } else {
                    params.setValue(self.myGroupTrip[indexPath.row].tripID, forKey: "id")
                    HideFriendsTripRequestService(delegate: self).dispathWithParams(params)
                }
            }
            
        });
        
        if indexPath.section == 0 || indexPath.section == 1 {
            return [deleteAction]
        } else {
            
            var hideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Hide", handler:{action, indexpath in
                
                let params = NSMutableDictionary()
                params.setValue(self.friendsTripRequests[indexPath.row].tripID, forKey: "id")
                //params.setValue("delete", forKey: "_method")
                HideFriendsTripRequestService(delegate: self).dispathWithParams(params)
                self.friendsTripRequests.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            });
            return [acceptAction, hideAction];
        }
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
        } else if segue.identifier == "to-create-trip" {
            var destinationVC = segue.destinationViewController as! CreateTripTableViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    //MARK: -
    //MARK: ----- GetPairedTripServiceDelegate -----
    //MARK: -
    func handleGetPairedTripFail() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func handleGetPairedTripSuccess(trips: [Trip]) {
        pairedTrip = trips
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    //MARK: -
    //MARK: ----- GetTripOffersServiceDelegate -----
    //MARK: -
    func GetTripOffersSuccess(offers: [TripOffer]) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.tripOffers = offers
        self.performSegueWithIdentifier("to-pick-driver", sender: nil)
    }
    
    func GetTripOffersFail() {
        
    }
    
    //MARK: -
    //MARK: ----- AcceptTripServiceDelegate -----
    //MARK: -
    func handleAcceptTripSuccess() {
        
    }
    
    func handleAcceptTripFail() {
        
    }
    
    
    
    //MARK: -
    //MARK: ----- GetMyTripServiceDelegate -----
    //MARK: -
    func handleGetMyTripSuccess(trips: [Trip]) {
        myTripRequests.removeAll(keepCapacity: true)
        myTripRequests = trips
        GetTripService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    func handleGetMyTripFail() {
        GetTripService(delegate: self).dispathWithParams(NSDictionary())
        println("handleGetMyTripFail")
    }
    
    //MARK: -
    //MARK: ----- GetTripServiceDelegate -----
    //MARK: -
    func handleGetTripFail() {
        GetGroupTripService(delegate: self).dispathWithParams(NSDictionary())
        println("handleGetTripFail")
    }
    
    func handleGetTripSuccess(trips: [Trip]) {
        friendsTripRequests.removeAll(keepCapacity: true)
        friendsTripRequests = trips
        GetGroupTripService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    //MARK: -
    //MARK: ----- GetGroupTripServiceDelegate -----
    //MARK: -
    func handleGetGroupTripSuccess(trips: [Trip]) {
        myGroupTrip = trips
        GetPairedTripService(delegate: self).dispathWithParams(NSDictionary())
    }
    
    func handleGetGroupTripFail() {
        GetPairedTripService(delegate: self).dispathWithParams(NSDictionary())
        println("handleGetGroupTripFail")
    }
    
    //MARK: -
    //MARK: ----- GetGroupTripServiceDelegate -----
    //MARK: -
    func handleCreateTripSuccess() {
        self.getTrips()
    }
    
    //MARK: -
    //MARK: ----- HideFriendsTripRequestDelegate -----
    //MARK: -
    func handleHideFriendsTripRequestSuccess() {
        println("handleHideFriendsTripRequestSuccess")
    }
    
    func handleHideFriendsTripRequestFail() {
        println("handleHideFriendsTripRequestFail")
    }
    
    //MARK: -
    //MARK: ----- DeleteTripServiceDelegate -----
    //MARK: -
    func handleDeleteTripSuccess() {
        
    }
    
    func handleDeleteTripFail() {
        
    }
}
