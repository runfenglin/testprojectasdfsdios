//
//  CreateTripTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 20/05/15.
//
//
import UIKit

class CreateTripTableViewController: UITableViewController, ChooseLocationTableViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CreateTripServiceDelegate {
    
    static let INDEXPATH_ADDTOCALENDAR: NSIndexPath = NSIndexPath(forRow: 2, inSection: 1)
    
    @IBOutlet weak var fromAddressLine1: UILabel!
    @IBOutlet weak var fromAddressLine2: UILabel!
    @IBOutlet weak var toAddressLine1: UILabel!
    @IBOutlet weak var toAddressLine2: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var shareWithTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
   
    var isChoosingFromAddress: Bool = false
    var isChoosingTime: Bool = false
    var mDateFormatter: NSDateFormatter = NSDateFormatter()
    let shareOptionArray = ["Public", "Friends", "Friends' Friends"]
    
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
        
        fromAddressLine1.text = ""
        fromAddressLine2.text = ""
        toAddressLine1.text = ""
        toAddressLine2.text = ""
        alertLabel.text = ""
        
        mDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        mDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        startTimeLabel.text = mDateFormatter.stringFromDate(now)
        datePickerView.minimumDate = now
    }
    
    @IBAction func postButtonTouched(sender: AnyObject) {
        let params = NSMutableDictionary()
        params.setValue(0, forKey: CreateTripService.mConstant.PARAMETER_KEY_GROUP)
        params.setValue("67 Tamahere Drive Glenfield", forKey: CreateTripService.mConstant.PARAMETER_KEY_DEPARTURE)
        params.setValue("8 Tangihua Street CBD", forKey: CreateTripService.mConstant.PAREMETER_KEY_DESTINATION)
        params.setValue("2015-05-30 19:20:30", forKey: CreateTripService.mConstant.PAREMETER_KEY_TIME)
        params.setValue("Mock message", forKey: CreateTripService.mConstant.PAREMETER_KEY_COMMENT)
        params.setValue(1, forKey: CreateTripService.mConstant.PAREMETER_KEY_VISIBILITY)
        CreateTripService(delegate: self).dispathWithParams(params)
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
        return 3
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
    
    //MARK: ========== UITextField Delegate ==========
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    //MARK: ========== UITableView DataSource/Delegate ==========
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 5
            
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
        if indexPath == CreateTripTableViewController.INDEXPATH_ADDTOCALENDAR {
            NSLog("")
        }
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            isChoosingFromAddress = true
            self.performSegueWithIdentifier("to-choose-location", sender: nil)
        } else if (indexPath.section == 0 && indexPath.row == 2) {
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
    
    func didSelectLocation(addressLine1: NSString, addressLine2: NSString) {
        if isChoosingFromAddress {
            fromAddressLine1.text = addressLine1 as String
            fromAddressLine2.text = addressLine2 as String
        } else {
            toAddressLine1.text = addressLine1 as String
            toAddressLine2.text = addressLine2 as String
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! ChooseLocationTableViewController
        destinationVC.delegate = self
    }
    
    func handleCreateTripSuccess() {
        
    }
    
    func handleCreateTripFail() {
        
    }
}
