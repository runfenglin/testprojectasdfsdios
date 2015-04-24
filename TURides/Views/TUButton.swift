//
//  TUButton.swift
//  TURides
//
//  Created by Dennis Hui on 22/04/15.
//
//

import UIKit

@IBDesignable
class TUButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 6.0
        
        self.layer.borderColor = UIColor(netHex: 0x8EB2BE).CGColor
        self.layer.borderWidth = 1.0
        setTitleColor(UIColor(netHex: 0x8EB2BE), forState: UIControlState.Highlighted)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        
        set {
            if newValue {
                backgroundColor = UIColor.whiteColor()
            }
            else {
                backgroundColor = UIColor(netHex: 0x8EB2BE)
            }
            super.highlighted = newValue
        }
    }
}
