//
//  CreateTripTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 20/05/15.
//
//
import UIKit

class CreateTripTableViewController: UITableViewController, ChooseLocationTableViewControllerDelegate, SelectFriendsTableViewControllerDelegate, CreateTripServiceDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    static let INDEXPATH_FROM: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    static let INDEXPATH_TO: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    
    @IBOutlet weak var fromAddressLine1: UILabel!
    @IBOutlet weak var fromAddressLine2: UILabel!
    @IBOutlet weak var toAddressLine1: UILabel!
    @IBOutlet weak var toAddressLine2: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var shareWithTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet var groupTripSwitch: UISwitch!
    @IBOutlet var noteUITextView: UITextView!
    
    var isChoosingFromAddress: Bool = false
    var isChoosingTime: Bool = false
    var mDateFormatter: NSDateFormatter = NSDateFormatter()
    var departure: GooglePlace?
    var destination: GooglePlace?
    
    let shareOptionArray = ["Friends", "Friends' Friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = NavBarLogoView(title: "New Trip")
        
        let now = NSDate()
        let pickerView = UIPickerView()
        pickerView.sizeToFit()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
    
        shareWithTextField.inputView = pickerView
        shareWithTextField.delegate = self
        shareWithTextField.text = "Friends"
        
        fromAddressLine1.text = ""
        fromAddressLine2.text = ""
        toAddressLine1.text = ""
        toAddressLine2.text = ""
        
        mDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        mDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        startTimeLabel.text = mDateFormatter.stringFromDate(now)
        datePickerView.minimumDate = now
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to-choose-location" {
            let destinationVC = segue.destinationViewController as! ChooseLocationTableViewController
            destinationVC.delegate = self
        }
        
        if segue.identifier == "to-select-friends" {
            let destinationVC = segue.destinationViewController as! SelectFriendsTableViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func postButtonTouched(sender: AnyObject) {
        
        if departure == nil || destination == nil {
            UIUtil.showPopUpErrorDialog("You must select a from address and a to address.")
        } else {
            self.performSegueWithIdentifier("to-select-friends", sender: nil)
        }
    }

    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(sender: AnyObject) {
        let datePicker = sender as! UIDatePicker
        startTimeLabel.text = mDateFormatter.stringFromDate(datePicker.date)
    }
    
    //MARK: -
    //MARK: ==========UIPickerView DataSource/Delegate==========
    //MARK: -
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel(frame: CGRectMake(0, 0, pickerView.rowSizeForComponent(component).width, pickerView.rowSizeForComponent(component).height))
        }
        
        label!.textAlignment = NSTextAlignment.Center
        label!.text = shareOptionArray[row]
        return label!
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shareWithTextField.text = shareOptionArray[row]
        shareWithTextField.resignFirstResponder()
    }
    
    //MARK:
    //MARK: ========== UITextField Delegate ==========
    //MARK:
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    //MARK:
    //MARK: ========== UITableView DataSource/Delegate ==========
    //MARK:
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
            
        case 2:
            return 1
            
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return isChoosingTime ? 162 : 0
        }
        
        if indexPath.section == 2 {
            return 100
        }
        
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath == CreateTripTableViewController.INDEXPATH_FROM) {
            isChoosingFromAddress = true
            self.performSegueWithIdentifier("to-choose-location", sender: nil)
        } else if (indexPath == CreateTripTableViewController.INDEXPATH_TO) {
            isChoosingFromAddress = false
            self.performSegueWithIdentifier("to-choose-location", sender: nil)
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            tableView.beginUpdates()
            isChoosingTime = !isChoosingTime
            startTimeLabel.textColor = isChoosingTime ? UIColor.redColor() : UIColor.blackColor()
            tableView.endUpdates()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    //MARK:
    //MARK: ========== ChooseLocationTableViewControllerDelegate ==========
    //MARK:
    func didSelectLocation(place: GooglePlace) {
        let address = place.address as NSString
        
        let addressLine1 = address.substringToIndex(address.rangeOfString(",").location)
        let addressLine2 = address.substringFromIndex(address.rangeOfString(",").location + 2)
        
        if isChoosingFromAddress {
            departure = place
            fromAddressLine1.text = addressLine1 as String
            fromAddressLine2.text = addressLine2 as String
        } else {
            destination = place
            toAddressLine1.text = addressLine1 as String
            toAddressLine2.text = addressLine2 as String
        }
    }
    
    //MARK:
    //MARK: ========== SelectFriendsTableViewControllerDelegate ==========
    //MARK:
    func didSelectFriends(friends: [String]) {
        
        let params = NSMutableDictionary()
        if groupTripSwitch.on {
            params.setValue(1, forKey: CreateTripService.mConstant.PARAMETER_KEY_GROUP)
        }
        
        params.setValue(departure?.address, forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE)
        params.setValue(departure?.id, forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE_ID)
        params.setValue(destination?.address, forKey: CreateTripService.mConstant.PAREMETER_KEY_DESTINATION)
        params.setValue(destination?.id, forKey: CreateTripService.mConstant.PAREMETER_KEY_DESTINATION_ID)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateTime = dateFormatter.stringFromDate(datePickerView.date)
        params.setValue(dateTime, forKey: CreateTripService.mConstant.PAREMETER_KEY_TIME)
        
        if noteUITextView.text != "Note" {
            params.setValue(noteUITextView.text, forKey: CreateTripService.mConstant.PAREMETER_KEY_COMMENT)
        } else {
            params.setValue("", forKey: CreateTripService.mConstant.PAREMETER_KEY_COMMENT)
        }
        
        if shareWithTextField.text == "Friends" {
            params.setValue(1, forKey: CreateTripService.mConstant.PAREMETER_KEY_VISIBILITY)
        } else {
            params.setValue(2, forKey: CreateTripService.mConstant.PAREMETER_KEY_VISIBILITY)
        }
        
        if friends.count == Session.sharedInstance.friends!.count {
            
        } else {
            
        }

        
        CreateTripService(delegate: self).dispathWithParams(params)
    }
    
    //MARK:
    //MARK: ========== CreateTripServiceDelegate ==========
    //MARK:
    func handleCreateTripSuccess() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleCreateTripFail() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
