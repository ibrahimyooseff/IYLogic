//
//  MainVC.swift
//  IYLogic
//
//  Created by RMS on 2019/10/7.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import UIKit
import FAPanels
import Segmentio

class MainVC: BaseViewController {

    var menuVC : MenuVC!
    @IBOutlet weak var ui_segment: Segmentio!
    @IBOutlet weak var ui_scrollView: UIScrollView!
    
    private lazy var viewControllers: [UIViewController] = {
        return self.preparedViewControllers()
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var scrollabelSegmentControl:DHSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfigurations()
        setSegmentData()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func setSegmentData() {
        
        /*
        //set segement data
        scrollabelSegmentControl = DHSegmentedControl(
            items: [DHSegmentTitle("Solis"),
                    DHSegmentTitle("Nutrition"),
                    DHSegmentTitle("Crops"),
                    DHSegmentTitle("Irrigation")]
        )
        scrollabelSegmentControl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        scrollabelSegmentControl.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,.flexibleWidth]
        scrollabelSegmentControl.addTarget(self, action: #selector(segmentControlValueChanged(segmentControl:)), for: .valueChanged)
        ui_segment.addSubview(scrollabelSegmentControl)
        */
        
        //other case
        
         
         //var segmentioStyle = SegmentioStyle.imageOverLabel, .onlyLabel, .imageBeforeLabel, .imageAfterLabel, .onlyImage:
         
         //        setupScrollView()
         SegmentioBuilder.buildSegmentioView(
         segmentioView: ui_segment,
         segmentioStyle: .onlyLabel
         )
         //SegmentioBuilder.setupBadgeCountForIndex(ui_segmentio, index: 0)
         
         ui_segment.valueDidChange = { [weak self] _, segmentIndex in
            
             if let scrollViewWidth = self?.ui_scrollView.frame.width {
                 let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                 self?.ui_scrollView.setContentOffset(
                     CGPoint(x: contentOffsetX, y: 0),
                     animated: true
                 )
             }
         }
         ui_segment.selectedSegmentioIndex = selectedSegmentioIndex()
        
    }
    
    // MARK: - Functions
    
    func viewConfigurations() {

        //  Resetting the Panel Configs...
        
        panel!.configs = FAPanelConfigurations()
        panel?.leftPanelPosition = .front //.back
        panel!.configs.panFromEdge = false
        panel!.configs.minEdgeForLeftPanel = 40 //CGFloat(Double(sliderValueAsText)!)
        panel!.configs.centerPanelTransitionDuration = 1 //TimeInterval(Double(valueAsText)!)
//        panel!.configs.rightPanelWidth = 50
        panel!.configs.leftPanelWidth = 100
        panel!.configs.canLeftSwipe = true
        
        let animOptions: FAPanelTransitionType = .moveLeft
//        .flipFromLeft, .flipFromRight, .flipFromTop, .flipFromBottom, .curlUp, .curlDown, .crossDissolve
//        .moveRight, .moveLeft, .moveUp, .moveDown, .splitHorizontally, .splitVertically, .dumpFall, .boxFade,
        panel!.configs.centerPanelTransitionType = animOptions
        panel!.configs.bounceOnRightPanelOpen = false
        panel!.configs.bounceDuration = 0.1
        
        panel!.delegate = self
    }
    
    @IBAction func onTapedMenu(_ sender: Any) {
        
        panel?.openLeft(animated: true)
        
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
    
    private func selectedSegmentioIndex() -> Int {
        return 0
    }
    
    private func preparedViewControllers() -> [MainContentVC] {
        let soilsVC = MainContentVC.create()
        soilsVC.disaster = Disaster(
            cardName: "Information of Solis",
            hints: Hints.soils, img: "soils"
        )
        
        let nutritionVC = MainContentVC.create()
        nutritionVC.disaster = Disaster(
            cardName: "Information of Nutrition",
            hints: Hints.nutrition, img: "round"
        )
        
        let cropsVC = MainContentVC.create()
        cropsVC.disaster = Disaster(
            cardName: "Information of Crops", hints: Hints.croops,
            img: nil
        )
        
        let irrgationVC = MainContentVC.create()
        irrgationVC.disaster = Disaster(
            cardName: "Information of Irrgation",
            hints: Hints.irrigation, img: nil
        )
        
        return [ soilsVC, nutritionVC, cropsVC, irrgationVC ]
    }
    
    private func setupScrollView() {
        
        ui_scrollView.contentSize = CGSize(
            width: ui_scrollView.bounds.width * CGFloat(viewControllers.count),
            height: ui_scrollView.frame.height
        )
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: ui_scrollView.bounds.width * CGFloat(index),
                y: 0,
                width: ui_scrollView.frame.width,
                height: ui_scrollView.frame.height
            )
            addChild(viewController)
            ui_scrollView.addSubview(viewController.view, options: .useAutoresize) // module's extension
            viewController.didMove(toParent: self)
        }
    }
    
    
    /*
 private func goToControllerAtIndex(_ index: Int) {
 ui_segment.selectedSegmentioIndex = index
 }
    
    @objc func segmentControlValueChanged(segmentControl:DHSegmentedControl) {

        print("segmentControl : \(segmentControl.selectedIndex)")
    }
 */
    
    
    
}

extension MainVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        ui_segment.selectedSegmentioIndex = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
}
extension MainVC: FAPanelStateDelegate {
    
    func centerPanelWillBecomeActive() {
        print("centerPanelWillBecomeActive called")
    }
    
    func centerPanelDidBecomeActive() {
        print("centerPanelDidBecomeActive called")
    }
    
    
    func leftPanelWillBecomeActive() {
        print("leftPanelWillBecomeActive called")
    }
    
    
    func leftPanelDidBecomeActive() {
        print("leftPanelDidBecomeActive called")
    }
    
    
    func rightPanelWillBecomeActive() {
        print("rightPanelWillBecomeActive called")
    }
    
    func rightPanelDidBecomeActive() {
        print("rightPanelDidBecomeActive called")
    }
    
}
