//
//  NavBarLogoView.swift
//  TURide
//
//  Created by Dennis Hui on 12/04/15.
//
//

import UIKit

class NavBarLogoView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    convenience init(title: NSString) {
        self.init(frame: CGRectMake(0, 0, 150, 40))
        
        let view = NSBundle.mainBundle().loadNibNamed("NavBarLogoView", owner: self, options: nil)[0] as? NavBarLogoView
        view?.frame = CGRectMake(0, 0, 150, 40)
        view?.titleLabel.text = title as String;
        self.addSubview(view!)
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
