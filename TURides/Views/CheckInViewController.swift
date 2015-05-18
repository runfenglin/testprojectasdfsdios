//
//  CheckInViewController.swift
//  TURides
//
//  Created by Dennis Hui on 21/04/15.
//
//

import UIKit

class CheckInViewController: BaseViewController, CreateCheckInServiceDelegate{

    @IBOutlet weak var checkInCommentTextView: UITextView!
    var place: GooglePlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = NavBarLogoView(title: "Check In")
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    @IBAction func postButtonTouched(sender: AnyObject) {
        let service = CreateCheckInService(delegate: self)
        let params = NSMutableDictionary()
        //params.setValue(KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY), forKey: Constant.KEYCHAIN_KEY_APIKEY)
        params.setValue(checkInCommentTextView.text, forKey: CreateCheckInService.mConstant.PARAMETER_KEY_COMMENT)
        params.setValue(place?.id, forKey: CreateCheckInService.mConstant.PARAMETER_KEY_PLACE_ID)
        params.setValue(place?.name, forKey: CreateCheckInService.mConstant.PARAMETER_KEY_PLACE_NAME)
        
        service.dispathWithParams(params)
        
    }
    
    func handleCreateCheckInServiceSuccess() {
        
    }
}
