//
//  AccountViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet var promoCodeView: UIView!
    @IBOutlet var upperView: UIView!
    @IBOutlet var promoImageView: UIImageView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var userProfile: UIImageView!
    @IBOutlet var userName: UILabel!
    
    var iscomeFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
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
    @IBAction func UpgradePremiumTap(_ sender: UIButton) {
        self.promoCodeView.isHidden = false
    }
    
    @IBAction func settingBtnTap(_ sender: UIButton) {
        self.performPushSeguefromController(identifier: "SettingsViewController")
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AccountViewController {
    
    //MARK:- GetProfile API
        func Getprofile(){
            self.showProgress()
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
                }
            }
            }
}
