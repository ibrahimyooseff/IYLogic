//
//  MainContentVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/9.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit

private func yal_isPhone6() -> Bool {
    let size = UIScreen.main.bounds.size
    let minSide = min(size.height, size.width)
    let maxSide = max(size.height, size.width)
    return (abs(minSide - 375.0) < 0.01) && (abs(maxSide - 667.0) < 0.01)
}

class MainContentVC: BaseViewController {

    @IBOutlet weak var ui_lblCardName: UILabel!
    @IBOutlet weak var ui_txvContent: UITextView!
    @IBOutlet weak var ui_imgMain: UIImageView!
    @IBOutlet weak var imgWidthConstrant: NSLayoutConstraint!
    
    
    var disaster: Disaster?
    fileprivate var hints: [String]?
    
    class func create() -> MainContentVC {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! MainContentVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let disaster = disaster {
            ui_lblCardName.text = disaster.cardName
            hints = disaster.hints
            
            var str = ""
            for index : Int in 0 ..< hints!.count {
                str += hints![index] + "\n"
            }
            ui_txvContent.text = str

            if disaster.img == nil {
                ui_imgMain.image = nil
                imgWidthConstrant.constant = 0
            } else {
                ui_imgMain.image = UIImage(named: disaster.img!)
                imgWidthConstrant.constant = UIScreen.main.bounds.width * 0.8
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ui_txvContent.setContentOffset(CGPoint.zero, animated: false)
    }
}
