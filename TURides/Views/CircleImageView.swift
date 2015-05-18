//
//  CircleImageView.swift
//  TURides
//
//  Created by Dennis Hui on 11/05/15.
//
//

import UIKit

class CircleImageView: UIImageView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }

}
