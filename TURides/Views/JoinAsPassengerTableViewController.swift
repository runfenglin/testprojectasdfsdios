//
//  JoinAsPassengerTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 18/07/15.
//
//

import UIKit

class JoinAsPassengerTableViewController: UITableViewController, ChooseLocationTableViewControllerDelegate, CreateTripServiceDelegate, JoinGroupTripServiceDelegate {
    
    static let INDEXPATH_FROM: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    static let INDEXPATH_TIME: NSIndexPath = NSIndexPath(forRow: 3, inSection: 0)
    
    var isChoosingTime: Bool = false
    var mDateFormatter: NSDateFormatter = NSDateFormatter()
    var tripToJoin: Trip?
    var modifiedDate: NSDate?
    var modifiedDepature: GooglePlace?
    
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var fromAddressLine1: UILabel!
    @IBOutlet var fromAddressLine2: UILabel!
    @IBOutlet var toAddressLine1: UILabel!
    @IBOutlet var toAddresLine2: UILabel!
    @IBOutlet var driverSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.title = "Join Group Trip"
        
        mDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        mDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        startTimeLabel.text = mDateFormatter.stringFromDate(tripToJoin!.departureTime)
        
        let fromAddress = tripToJoin!.departure.address as NSString
        let toAddress = tripToJoin!.destination.address as NSString
        
        let sFromAddressLine1 = fromAddress.substringToIndex(fromAddress.rangeOfString(",").location)
        let sFromAddressLine2 = fromAddress.substringFromIndex(fromAddress.rangeOfString(",").location + 2)
        let sToAddressLine1 = toAddress.substringToIndex(toAddress.rangeOfString(",").location)
        let sToAddressLine2 = toAddress.substringFromIndex(toAddress.rangeOfString(",").location + 2)
        fromAddressLine1.text = sFromAddressLine1
        fromAddressLine2.text = sFromAddressLine2
        toAddressLine1.text = sToAddressLine1
        toAddresLine2.text = sToAddressLine2
    }
    
    @IBAction func datePickerViewValueChanged(sender: AnyObject) {
        let datePicker = sender as! UIDatePicker
        startTimeLabel.text = mDateFormatter.stringFromDate(datePicker.date)
        modifiedDate = datePicker.date
    }
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTouched(sender: AnyObject) {
        
        let params = NSMutableDictionary()
        params.setValue(tripToJoin!.tripID, forKey: "id")
        JoinGroupTripService(delegate: self).dispathWithParams(params)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return isChoosingTime ? 160 : 0
        } else {
            return 44
        } 
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == JoinAsPassengerTableViewController.INDEXPATH_FROM {
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("choose-location") as! ChooseLocationTableViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath == JoinAsPassengerTableViewController.INDEXPATH_TIME {
            tableView.beginUpdates()
            isChoosingTime = !isChoosingTime
            startTimeLabel.textColor = isChoosingTime ? UIColor.redColor() : UIColor.blackColor()
            tableView.endUpdates()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    //
    func didSelectLocation(place: GooglePlace) {
        let address = place.address as NSString
        modifiedDepature = place
        let addressLine1 = address.substringToIndex(address.rangeOfString(",").location)
        let addressLine2 = address.substringFromIndex(address.rangeOfString(",").location + 2)
        fromAddressLine1.text = addressLine1 as String
        fromAddressLine2.text = addressLine2 as String
    }
    
    func handleCreateTripSuccess() {
        
    }
    
    func handleCreateTripFail() {
        
    }
    
    func handleJoinGroupTripSuccess() {
        if driverSwitch.on {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let params = NSMutableDictionary()

            params.setValue(tripToJoin?.tripID, forKey: "parent")
            if let departure = modifiedDepature {
                params.setValue(departure.address, forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE)
                params.setValue(departure.id, forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE_ID)
            } else {
                params.setValue(tripToJoin!.departure.address, forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE)
                params.setValue(tripToJoin!.departure.id, forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE_ID)
                
            }

            params.setValue(tripToJoin!.destination.address, forKey: CreateTripService.mConstant.PAREMETER_KEY_DESTINATION)
            params.setValue(tripToJoin!.destination.id, forKey: CreateTripService.mConstant.PAREMETER_KEY_DESTINATION_ID)
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"

            var dateTime: String
            params.setValue(1, forKey: CreateTripService.mConstant.PAREMETER_KEY_VISIBILITY)

            if let depatureTime = modifiedDate {
                dateTime = dateFormatter.stringFromDate(depatureTime)
            } else {
                dateTime = dateFormatter.stringFromDate(tripToJoin!.departureTime)
            }
            params.setValue(dateTime, forKey: CreateTripService.mConstant.PAREMETER_KEY_TIME)

            CreateTripService(delegate: self).dispathWithParams(params)
        }
    }
    
    func handleJoinGroupTripFail() {
        
    }
}
