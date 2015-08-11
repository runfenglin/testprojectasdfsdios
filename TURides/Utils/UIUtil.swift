//
//  UIUtil.swift
//  TURides
//
//  Created by Dennis Hui on 16/04/15.
//
//

import UIKit

class UIUtil: NSObject {
    static func showErrorForTextField(textField: UITextField) {
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1
    }
    
    static func hideErrorForTextField(textField: UITextField) {
        //textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 0
    }
    
    static func showPopUpErrorDialog(message: String) {
        let dialog = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
        dialog.show()
    }
    
    static func formatDate(date: NSDate) -> NSString {
        var mDateFormatter: NSDateFormatter = NSDateFormatter()
        mDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        mDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return mDateFormatter.stringFromDate(date)
    }
}
