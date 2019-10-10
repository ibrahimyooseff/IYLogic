//
//  MenuVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/7.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit

class MenuVC: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapedWater(_ sender: Any) {
        gotoVC("WaterVC")
//        self.dissmisAndGotoVC("WaterVC")
    }
    
    @IBAction func onTapedWeather(_ sender: Any) {
        gotoVC("WeatherVC")
    }
    
    @IBAction func onTapedLeaf(_ sender: Any) {
        gotoVC("LeafVC")
    }
    
    @IBAction func onTapedLocation(_ sender: Any) {
        gotoVC("LocationVC")
    }
    
    @IBAction func onTapedLogout(_ sender: Any) {
        let alert = UIAlertController(title: R.string.CONFIRM_LOGOUT, message: "", preferredStyle: .alert)
        //preferredStyle: .actionSheet
        alert.addAction(UIAlertAction(title: R.string.CANCEL, style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: R.string.LOGOUT, style: .default, handler : {(action) -> Void in
            self.dissmisAndGotoVC("LoginVC")
        }))
        
        DispatchQueue.main.async(execute:  {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    func gotoVC(_ vcName: String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: vcName)
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        
        panel!.configs.bounceOnCenterPanelChange = true
        
        /*
         // Simple way of changing center PanelVC
         _ = panel!.center(centerNavVC)
         
         New Feature Added, You can change the center panelVC and after completion of the animations you can execute a closure
         */
        
        panel!.center(centerNavVC, afterThat: {
            print("Executing block after changing center panelVC From Left Menu")
//            _ = self.panel!.left(nil)
        })
    }
}
