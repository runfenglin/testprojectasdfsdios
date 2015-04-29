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
//        let url = NSURL(string: item.iconImageUrl)
//        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        //d.setImageWithURL(NSURL(item.iconImageUrl))
//        if !item.iconImageUrl.isEmpty {
//        d.setImageWithURL(NSURL(string: item.iconImageUrl))
//        }
        //c.text = item.types[0] as! String
        // Configure the cell...

        return cell
        
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("to-post", sender: nil)
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
        
        
        
//        FTGooglePlacesAPIService.provideAPIKey("AIzaSyAd3AhgQ1Gv-MF6DSt0qfH8Zda2Reia5tk")
//        
//        let request = FTGooglePlacesAPINearbySearchRequest(locationCoordinate: CLLocationCoordinate2DMake(-36.78, 174.71))
//       // request.locationCoordinate = CLLocationCoordinate2DMake(-36.78, 174.71)
//        request.rankBy = FTGooglePlacesAPIRequestParamRankBy.Distance
//        //request.radius = 10000
//        request.types = ["food","park","gym"]
//        
//        
//        FTGooglePlacesAPIService.executeSearchRequest(request, withCompletionHandler: { (response: FTGooglePlacesAPISearchResponse?, error: NSError?) -> Void in
//            
//            if let resultsa = response?.results {
//                let a  = resultsa as NSArray
//                
//                self.results = a.mutableCopy() as! NSMutableArray;
//                self.hasPlacesLoad = true
//                self.tableView.reloadData()
//                MBProgressHUD.hideHUDForView(self.view, animated: true)
////                for item in results {
////                    let item1 = item as! FTGooglePlacesAPISearchResultItem
////                    
////                    println ("\(item.name)")
////                    
////                    
////                }
//                
//            }
//            
//            
//            
//            println("\(error)")
//        })
    }

    func handleGooglePlaceSearchSuccess(results: NSArray) {
        self.results = results.mutableCopy() as! NSMutableArray
        hasPlacesLoad = true
        tableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
}
