//
//  BaseViewController.swift
//  TURides
//
//  Created by Dennis Hui on 13/04/15.
//
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.navigationItem.titleView = NavBarLogoView(title: "ThumbsUp")
    }
}
