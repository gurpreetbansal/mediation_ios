//
//  Extension.swift
//  fashLOCO
//
//  Created by apple on 24/04/19.
//  Copyright © 2019 apple. All rights reserved.
//
import Foundation
import UIKit
import NVActivityIndicatorView
import UserNotifications
@available(iOS 11.0, *)
extension UIViewController: NVActivityIndicatorViewable ,UNUserNotificationCenterDelegate
{
    func checkNotification(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Already authorized
            }
            else {
                // Either denied or notDetermined
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    // add your own
                    UNUserNotificationCenter.current().delegate = self
                    let alertController = UIAlertController(title: "Notification Alert", message: "please enable notifications", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    //MARK: Add  image over navigastion bar
    func addNavigationBarImage(){
        //let img = UIImage(named: "navigationBG")
        //navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        
        let backgroundImage = UIImage(named: "navigationBG")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), resizingMode: UIImage.ResizingMode.stretch)
        
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, for: .default)

    }
    
    //MARK: show progress hud
    func showProgress() {
        let size = CGSize(width: 50, height:50)
        self.startAnimating(size, message:"Loading", messageFont: UIFont.systemFont(ofSize: 18.0), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.white, padding: 1, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
 
    //MARK: hide progress hud
    func hideProgress() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.stopAnimating() }
    }
    
    
    //MARK: ShowAlert...
    func ShowLogoutAlert(title: String, message: String, viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: ShowAlertView...
     func ShowAlertView(title: String, message: String, viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the actions (buttons)
        //alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Push Segue ...
    func performPushSeguefromController(identifier:String){
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
    
    //MARK: to clear all stored data on logout time ..
    func clearData(){
        LogoutFunction()
    }
    func LogoutFunction(){
        
    }
}
//MARK: Gradient layer for navigation bar..
extension CAGradientLayer {
    class func primaryGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let firstColor = UIColor(red: 229/255.0, green: 16/255.0, blue: 113/255.0, alpha: 1.0)
        let secondColor = UIColor(red: 160.0/255.0, green: 50.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1.5, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    // usage
    //        guard
    //            let navigationController = navigationController,
    //            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
    //            else {
    //                print("Error creating gradient color!")
    //                return
    //        }
    //
    //        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
}

extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedText = attribute
    }
}


extension UIView{
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
}


// Animation for drop down views ...
//if isSearchActive == "no"{
//    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
//        self.searchView.isHidden = false
//        self.TableViewTopConstraints.constant = 50
//        self.isSearchActive = "yes"
//        self.view.layoutIfNeeded()
//
//    }, completion: nil)
//
//}else{
//    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//        self.searchView.isHidden = true
//        self.TableViewTopConstraints.constant = 0
//        self.isSearchActive = "no"
//        self.view.layoutIfNeeded()
//
//    }, completion: nil)
//
//}

//MARK:- ===========Localization==========
extension String {
    func localized(loc:String) ->String {
        
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
}
    
    func initGradientView(view:UIView,colour1:UIColor,colour2:UIColor){
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.frame.size
        gradientLayer.frame.size = view.frame.size
        gradientLayer.colors =
            [colour1.cgColor,colour2.cgColor]
        //Use diffrent colors
        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
