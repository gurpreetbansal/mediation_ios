//
//  AccountViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
class AccountViewController: UIViewController,BTDropInViewControllerDelegate {
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        
    }
    

    @IBOutlet weak var upgradeToPremiumLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet var promoCodeView: UIView!
    @IBOutlet var upperView: UIView!
    @IBOutlet var promoImageView: UIImageView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var userProfile: UIImageView!
    @IBOutlet var userName: UILabel!
    var clientToken = ""
    var iscomeFrom = ""
    var package_type = ""
    var payment_plan_id = ""
    var payment_plan_name = ""
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchClientToken()
        
           // Do any additional setup after loading the view.
    }
    func initfunc(){
        //Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        promoCodeView.isUserInteractionEnabled = true
       // promoImageView.isUserInteractionEnabled = true
        promoCodeView.addGestureRecognizer(tap)
       // promoImageView.addGestureRecognizer(tap)
        self.promoCodeView.isHidden = true
        self.upperView.initGradientView(view: self.upperView, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
    }
    
    //Action of tap gesture
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.promoCodeView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         initfunc()
        Getprofile()
        if iscomeFrom == "Account"{
            self.backBtn.isHidden = false
        }
        else{
            self.backBtn.isHidden = true
        }
    }
    @IBAction func invite(_ sender: UIButton) {
        let shareText = "Hi," + "\n\n" +
                        "Download Selfpause App Now! This is my Email:" + "\(self.email)." + "\n\n" +
                        "its available on,"  + "\n\n" +
                        "For Android users: https://play.google.com/store/apps/details?id=com.app.selfpause"  + "\n\n" +
                        "For i-phone users: https://apps.apple.com/us/app/selfpause/id1518538414" + "\n\n"

        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true)
    }
    @IBAction func UpgradePremiumTap(_ sender: UIButton) {
        if self.upgradeToPremiumLbl.text == "You have Premium"{
            self.promoCodeView.isHidden = true
        }else{
             self.promoCodeView.isHidden = false
        }
    }
    
    @IBAction func settingBtnTap(_ sender: UIButton) {
        self.performPushSeguefromController(identifier: "SettingsViewController")
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchClientToken() {
       // self.showProgress()
         let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.TokenGenerate.caseValue, parameter: ["id":userID]) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSDictionary {
                    if let token = data.value(forKey: "client_token") as? String {
                        self.clientToken = token
                        
                    }
                }
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
    }
    
    @IBAction func PayMonthly(_ sender: Any) {
         self.package_type = "1"
         SetDropInPayment(amt:"9.95")
     }
     @IBAction func PayYearly(_ sender: Any) {
         self.package_type = "2"
         SetDropInPayment(amt:"6.24")
     }
     func SetDropInPayment(amt:String){
         let request =  BTDropInRequest()
         let dropIn = BTDropInController(authorization: self.clientToken, request: request)
         {
          [unowned self] (controller, result, error) in
             
             if let error = error {
                 self.show(message: error.localizedDescription)
                 
             } else if (result?.isCancelled == true) {
                 self.show(message: "Transaction Cancelled")
                 
             } else if let nonce = result?.paymentMethod?.nonce{
                 self.sendRequestPaymentToServer(nonce: nonce,amount:amt)
             }
             controller.dismiss(animated: true, completion: nil)
         }
         
         self.present(dropIn!, animated: true, completion: nil)
     }
     func show(message: String) {
         DispatchQueue.main.async {
             let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
             self.present(alertController, animated: true, completion: nil)
         }
     }
     func sendRequestPaymentToServer(nonce: String,amount: String) {
         print(nonce)
         self.showProgress()
         print(Date.getCurrentDate())
         let userID = UserDefaults.standard.value(forKey: "UserID") as! String
         let parameter : [String : String] = ["users_id":userID,
                                              "amount":amount,
                                              "payment_date":Date.getCurrentDate(),
                                              "payment_plan_id":"",
                                              "payment_plan_name":"",
                                              "package_type":self.package_type,
                                              "nonce":nonce,
                                              "screenName": ""
                                             ]
             
         print(parameter)
         networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.Payment.caseValue, parameter: parameter) { (response) in
             print(response)
             self.hideProgress()
             let dic = response as! NSDictionary
             if dic.value(forKey: "success") as!Bool == true{
                  self.promoCodeView.isHidden = true
                 self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                 
             }
             else{
                 self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
             }
         }
     }
    
}

extension AccountViewController {
    
    //MARK:- GetProfile API
        func Getprofile(){
           // self.showProgress()
            let userID = UserDefaults.standard.value(forKey: "UserID")
            let parameter : [String:Any] = ["user_id":userID as Any]
            networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.getProfile.caseValue, parameter: parameter) { (response) in
                print(response)
                self.hideProgress()
                let dic = response as! NSDictionary
                if dic.value(forKey: "success") as! Bool == true{
                    let data = dic.value(forKey: "data")as! NSDictionary
                    if let fname = data.value(forKey: "first_name")as? String{
                        self.userName.text = fname
                    }
                    if let em = data.value(forKey: "email")as? String{
                        self.email = em
                        self.emailLbl.text = em
                    }
                    if (data.value(forKey: "profile") as? String) == ""{
                        self.userProfile.image = #imageLiteral(resourceName: "Asset 28")
                    }
                    else{
                        let Myimage = (data.value(forKey: "profile") as? String)
                        let profileImageUrl = URL(string: Myimage!)
                        if let profile = try? Data(contentsOf: profileImageUrl!)
                        {
                            let image: UIImage = UIImage(data: profile)!
                            self.userProfile.image = image
                        }
                    }
                    if (data.value(forKey: "subscripion") as? String) == "0"{
                        self.upgradeToPremiumLbl.text = "Upgrade to Premium"
                    }else{
                        self.upgradeToPremiumLbl.text = "You have Premium"
                    }
                }
            }
            }
}
