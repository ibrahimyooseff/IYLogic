//
//  LeafVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/9.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit

class LeafVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onTapedMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
        //        self.dissmisAndGotoVC("WaterVC")
    }
    
    @IBAction func onTapedMain(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        
        _ = panel!.center(centerNavVC)
        
        self.navigationController?.popViewController(animated: false)
    }
    
}

