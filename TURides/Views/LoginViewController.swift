//
//  LoginViewController.swift
//  TURides
//
//  Created by Dennis Hui on 13/04/15.
//
//

import UIKit

class LoginViewController: BaseViewController, RegistrationServiceDelegate {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = NavBarLogoView(title: "Login")
    }
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        var pass = true
        
        if phoneNumberTextField.text.isEmpty {
            UIUtil.showErrorForTextField(phoneNumberTextField)
            pass = false
        } else {
            UIUtil.hideErrorForTextField(phoneNumberTextField)
        }
        
        if passwordTextField.text.isEmpty {
            UIUtil.showErrorForTextField(passwordTextField)
            pass = false
        } else {
            UIUtil.hideErrorForTextField(passwordTextField)
        }
        
        if pass {
            let service = RegistrationService(delegate: self)
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            service.dispatch("")
        }
    }
    
    func handleRegistrationSuccess() {

    }
    
    func handleRegistrationFail() {
        
    }
}
