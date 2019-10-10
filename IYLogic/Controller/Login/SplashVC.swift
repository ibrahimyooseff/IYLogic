//
//  ViewController.swift
//  IYLogic
//
//  Created by RMS on 2019/10/2.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit

class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            self.dissmisAndGotoVC("LoginVC")
            /*
            let toVC = self.storyboard?.instantiateViewController( withIdentifier: "LoginVC")
            self.present(toVC!, animated: true, completion: nil)*/
            
        })
    }


}

