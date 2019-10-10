
import UIKit
import Toast_Swift
import FAPanels

class BaseViewController: UIViewController {

    var darkView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isValidEmail(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
        
    }
    
    func gotoMainVC() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC: MenuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let mainVC: MainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        let centerNavVC = UINavigationController(rootViewController: mainVC)
        
        //  Case 1: With Code only approah
        let rootController = FAPanelController()
        
        //  Case 2: With Xtoryboards, Xibs And NSCoder
        //        let rootController: FAPanelController = window?.rootViewController as! FAPanelController
        
        rootController.configs.leftPanelWidth = 100
        rootController.configs.bounceOnRightPanelOpen = false
        
        _ = rootController.center(centerNavVC).left(menuVC)
        //_ = rootController.center(centerNavVC).right(rightMenuVC)
        rootController.leftPanelPosition = .front
        /*rootController.rightPanelPosition = .front
         */
        
        
        //        //  For Case 1 only
        //        window?.rootViewController = rootController
        //
        
        self.present(rootController, animated: true, completion: nil)
    }
    
    // dissmis current VC and Goto one VC
    func dissmisAndGotoVC (_ nameVC: String) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC = storyBoard.instantiateViewController(withIdentifier: nameVC)
//        self.present(nextVC, animated: false, completion: nil)
        
        self.storyboard?.instantiateInitialViewController()?.dismiss(animated: true, completion: nil)
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        self.present(toVC!, animated: true, completion: nil)
    }
    
    func showAlertDialog(title: String!, message: String!, positive: String?, negative: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //preferredStyle: .actionSheet
        if (positive != nil) {
            
            alert.addAction(UIAlertAction(title: positive, style: .default, handler: nil))
        }
        
        if (negative != nil) {
            
            alert.addAction(UIAlertAction(title: negative, style: .default, handler: nil))
        }
        
        DispatchQueue.main.async(execute:  {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func showError(_ message: String!) {

        showAlertDialog(title: R.string.ERROR, message: message, positive: R.string.OK, negative: nil)
    }

    func showAlert(_ title: String!) {
        showAlertDialog(title: title, message: "", positive: R.string.OK, negative: nil)
    }
    
    func showHUD() {
        
        showHUDWithTitle(title: "")
    }
    
    func showHUDWithTitle(title: String) {
        
        if title == "" {
            ProgressHUD.show()
        } else {
            ProgressHUD.showWithStatus(string: title)
        }
    }
    
    func showSuccess() {
        
        DispatchQueue.main.async(execute:  {
            ProgressHUD.showSuccessWithStatus(string: R.string.SUCCESS)
        })
    }
    
    // hide loading view
    func hideHUD() {
        
        ProgressHUD.dismiss()
    }
    
    func showToast(_ message : String) {
        self.view.makeToast(message)
    }
    
    func showToast(_ message : String, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = .center) {
    
        self.view.makeToast(message, duration: duration, position: position)
    }
    
    var blackView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.backgroundColor = UIColor.init(white: 0.70, alpha: 0.5)
        view.backgroundColor = UIColor.black
        
        return view
    }()
    
    func showToastProgress(){
        
        //self.navigationController?.isNavigationBarHidden = true
        
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.addSubview(darkView)
        self.view.makeToastActivity(ToastPosition.center)
    }
    
    func hideToastProgress(){
        //self.navigationController?.isNavigationBarHidden = false
        darkView.removeFromSuperview()
        self.view.hideToastActivity()
    }
}


