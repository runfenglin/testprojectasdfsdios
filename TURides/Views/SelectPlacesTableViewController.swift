//
//  SelectPlacesTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 21/04/15.
//
//

import UIKit
import CoreLocation

class SelectPlacesTableViewController: UITableViewController, CLLocationManagerDelegate, GooglePlaceSearchNearByServiceDelegate {

    var locationManager: CLLocationManager = CLLocationManager();
    var results = NSMutableArray()
    var hasPlacesLoad = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = NavBarLogoView(title: "Select A Place")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (results.count < 1) {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true).labelText = "Loading your nearby places..."
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasPlacesLoad ? results.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! UITableViewCell
        
        let a = cell.viewWithTag(1) as! UILabel
        let b = cell.viewWithTag(2) as! UILabel
       // let c = cell.viewWithTag(3) as! UILabel
        let d = cell.viewWithTag(4) as! UIImageView
        
        
        let item = results.objectAtIndex(indexPath.row) as! GooglePlace
        
        a.text = item.name
        b.text = item.address

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("to-post", sender: results.objectAtIndex(indexPath.row))
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let place: GooglePlace = sender as! GooglePlace
        let vc: CheckInViewController = segue.destinationViewController as! CheckInViewController
        vc.place = place
    }

    
    //MARK:
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
        case CLAuthorizationStatus.Denied, CLAuthorizationStatus.NotDetermined:
            println("Error")
            break
        case CLAuthorizationStatus.AuthorizedAlways, CLAuthorizationStatus.AuthorizedWhenInUse:
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
            break
        default:
            break;
        }
    }
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let locValue:CLLocationCoordinate2D = manager.location.coordinate
        
        GooglePlaceSearchNearByService(delegate: self).dispatch(NSString(format: "%d,%d", -36.78, 174.71))
    }

    func handleGooglePlaceSearchSuccess(results: NSArray) {
        self.results = results.mutableCopy() as! NSMutableArray
        hasPlacesLoad = true
        tableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
}
