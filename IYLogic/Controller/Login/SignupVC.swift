//
//  SignupVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/6.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import FAPanels

class SignupVC: BaseViewController {

    @IBOutlet weak var ui_txtUsername: UITextField!
    @IBOutlet weak var ui_txtEmail: UITextField!
    @IBOutlet weak var ui_txtPwd: UITextField!
    @IBOutlet weak var ui_txtConfPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ui_txtUsername.delegate = self
        ui_txtEmail.delegate = self
        ui_txtPwd.delegate = self
        ui_txtConfPwd.delegate = self
        
    }
    
    @IBAction func onTapedSingup(_ sender: Any) {
        isVaildFormData()
    }
    
    @IBAction func onTapedSignin(_ sender: Any) {
        self.dissmisAndGotoVC("LoginVC")
    }
    
    
    func isVaildFormData () {
        
        let email = ui_txtEmail.text!.trimmed
        let username = ui_txtUsername.text!.trimmed
        let pwd = ui_txtPwd.text!.trimmed
        let confPwd = ui_txtConfPwd.text!.trimmed
        
        
        if username.isEmpty {
            showToast(R.string.INPUT_NAME, duration: 2, position: .center)
            return
        }
        
        if email.isEmpty {
            showToast(R.string.INPUT_EMAIL, duration: 2, position: .center)
            return
        } else if !isValidEmail(email: email) {
            showToast(R.string.INVALID_EMAIL, duration: 2, position: .center)
            return
        }
        
        if pwd.isEmpty {
            showToast(R.string.INPUT_PWD, duration: 2, position: .center)
            return
        }
        
        if confPwd.isEmpty {
            showToast(R.string.INPUT_CONFIRM_PWD, duration: 2, position: .center)
            return
        }
        
        if pwd != confPwd {
            showToast(R.string.INVALID_PWD, duration: 2, position: .center)
            return
        }
        
        Defaults[.username] = username
        Defaults[.email] = email
        Defaults[.pwd] = pwd
        
        self.gotoMainVC()
        
    }
}

extension SignupVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
            ui_txtEmail.becomeFirstResponder()
        } else if textField.tag == 2 {
            
            ui_txtPwd.becomeFirstResponder()
        } else if textField.tag == 3 {
            
            ui_txtConfPwd.becomeFirstResponder()
        } else if textField.tag == 4  {
            
            self.isVaildFormData()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    
}
