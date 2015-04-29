//
//  CheckInViewController.swift
//  TURides
//
//  Created by Dennis Hui on 21/04/15.
//
//

import UIKit

class CheckInViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "Check In")
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
