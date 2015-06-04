//
//  TUSearchDisplayController.swift
//  TURides
//
//  Created by Dennis Hui on 19/05/15.
//
//

import UIKit

class TUSearchDisplayController: UISearchDisplayController {
    override func setActive(visible: Bool, animated: Bool) {
      //  super.setActive(visible, animated: animated)
        
        super.setActive(visible, animated: false)
        self.searchContentsController.navigationController? .setNavigationBarHidden(false, animated: false)
    }
}
