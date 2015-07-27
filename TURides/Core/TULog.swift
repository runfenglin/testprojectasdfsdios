//
//  TULog.swift
//  TURides
//
//  Created by Dennis Hui on 27/07/15.
//
//

import UIKit

class TULog: NSObject {
    

    static func Log(message: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateTime = dateFormatter.stringFromDate(NSDate())
        println("\(dateTime) \(message)" )
    }
}
