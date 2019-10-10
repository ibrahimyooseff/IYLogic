//
//  LoginVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/2.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftQRScanner
import FAPanels

class LoginVC: BaseViewController {

    @IBOutlet weak var ui_txtEmail: UITextField!
    @IBOutlet weak var ui_txtPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui_txtEmail.delegate = self
        ui_txtPwd.delegate = self
        ui_txtEmail.text = Defaults[.email]
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//
//    }
    
    @IBAction func onTapedQRcode(_ sender: Any) {
        
        let scanner = QRCodeScannerController()
//        let scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "flash-on"), flashOffImage: UIImage(named: "flash-off"))
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)

        
    }
    
    @IBAction func onTapSignin(_ sender: Any) {
        isVaildFormData()
    }
    
    @IBAction func onTapGotoSignup(_ sender: Any) {
        
        self.dissmisAndGotoVC("SignupVC")
    }
    
    func isVaildFormData(){
        
        let email = ui_txtEmail.text!.trimmed
        let pwd = ui_txtPwd.text!.trimmed
        
        if email.isEmpty {
            showToast(R.string.INPUT_EMAIL, duration: 2, position: .center)
            return
        } else if !isValidEmail(email: email) && email != Defaults[.email] {
            showToast(R.string.INVALID_EMAIL, duration: 2, position: .center)
            return
        }
        
        if pwd.isEmpty {
            showToast(R.string.INPUT_PWD, duration: 2, position: .center)
            return
        } else if pwd != Defaults[.pwd] {
            showToast(R.string.INVALID_PWD, duration: 2, position: .center)
            return
        }
        
        self.gotoMainVC()
        
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
            ui_txtPwd.becomeFirstResponder()
            
        } else if textField.tag == 2  {
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

extension LoginVC: QRScannerCodeDelegate {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        
//        self.showToast(result, duration: 1, position: .center)
        if isValidEmail(email: result) {
            self.ui_txtEmail.text = result
        } else {
            self.ui_txtEmail.text = ""
            self.showToast("Invalid Email", duration: 1, position: .center)
        }
        
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
    
}
