//
//  UIView+Extension.swift
//

import Foundation
import UIKit

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
}

extension UIView {
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    class func NibObject() -> UINib {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // assert
            return UINib()
        }
        return UINib(nibName: self.nameOfClass, bundle:nil)
    }
    
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil: nibNameOrNil)
        return v!
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = "\(T.self)".components(separatedBy: ".").last!
        }
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }

    // MARK: Frame of UIView - do not touch
    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize  {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.centerY)
        }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.centerX, y: newValue)
        }
    }
    
    var top : CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var bottom : CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var right : CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    var left : CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x  = newValue
            self.frame = frame
        }
    }
    
    func origin (_ point : CGPoint) {
        frame.origin.x = point.x
        frame.origin.y = point.y
    }
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIView.keyboardWillChange(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    func unbindToKeyboard() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        })
    }
    
    //set selected corner only
    //ex : ui_viewTxt.roundCornersWithLayerMask(cornerRadius: 10, corners: [.topRight, .bottomLeft, .bottomRight])
    func roundCornersWithLayerMask(cornerRadius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set { layer.shadowOpacity = newValue }
        get{ return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set { layer.shadowOffset = newValue }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set { layer.shadowRadius = newValue }
        get{ return layer.shadowRadius }
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // MARK: - Customized UIView Shadow
    func dropShadow(cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
    }
    
    func roundShadow(cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = .zero
        self.layer.shouldRasterize = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

class dropShadowView: UIView {
    override func didMoveToWindow() {
        
        self.layer.cornerRadius = self.height / 2
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
    }
}

class roundShadowView: UIView {
    override func didMoveToWindow() {
        self.layer.cornerRadius = self.height / 2
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = .zero
        self.layer.shouldRasterize = true
    }
}

class topShadowView: UIView {
    override func didMoveToWindow() {
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = .zero
        self.layer.shouldRasterize = true
    }
}

class roundView: UIView {
    override func didMoveToWindow() {
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }
}
