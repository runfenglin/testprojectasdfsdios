//
//  TUPrimaryButton.swift
//  TURides
//
//  Created by Dennis Hui on 28/04/15.
//
//

import UIKit

@IBDesignable
class TUPrimaryButton: TUButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButtonStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtonStyle()
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
    
    private func setUpButtonStyle() {
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = UIColor(netHex: 0x8EB2BE).CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor(netHex: 0x8EB2BE)
        setTitleColor(UIColor(netHex: 0x8EB2BE), forState: UIControlState.Highlighted)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
    }

}