//
//  RegisterViewController.swift
//  Meditation
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var emailView: DesignableView!
    @IBOutlet var firstNameView: DesignableView!
    @IBOutlet var View1: DesignableView!
    @IBOutlet var passwordView: DesignableView!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         initFunction()
     }
    
    func initFunction(){
        let colorLeft = UIColor(red: 219.0 / 255.0, green: 145.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
        let colorRight = UIColor(red: 163.0 / 255.0, green: 181.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
        
        self.View1.initGradientView(view: self.View1, colour1: colorLeft, colour2: colorRight)
        firstNameView.NewdropShadow()
        emailView.NewdropShadow()
        passwordView.NewdropShadow()
    }

    @IBAction func loginTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpTap(_ sender: DesignableButton) {
        
        if (firstNameTF.text == ""){
                        ShowAlertView(title: AppName, message: "Please enter first name", viewController: self)
                    }
       else if (EmailTF.text == ""){
                    ShowAlertView(title: AppName, message: "Please enter valid email address", viewController: self)
                }
       else if (isValidEmail(testStr: EmailTF.text!) == false){
                    ShowAlertView(title: AppName, message: "email must be in valid form", viewController: self)
                        }
                else if (PasswordTF.text == ""){
                    ShowAlertView(title: AppName, message: "Please enter password", viewController: self)
                }
                else if ((PasswordTF.text?.count)! <= 6){
                    ShowAlertView(title: AppName, message: "Password must be greater than six digits", viewController: self)
                }
     
                else{
                    RegisterData() //API Call
                }
        
    }
    
    // Check valid Email
     func isValidEmail(testStr:String) -> Bool {
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         
         let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailPred.evaluate(with: testStr)
     }
    
    
}

//MARK:- API Extension

extension RegisterViewController{
    
    func RegisterData(){
         self.showProgress()
            let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")
        UserDefaults.standard.set(PasswordTF.text!, forKey: "oldpassword")
        let parameter : [String : Any] = ["first_name":firstNameTF.text!,
                             "last_name":"",
                             "email":EmailTF.text!,
                            "password":PasswordTF.text!,
                             "gender":"",
                             "dob": "",
                             "profile":"",
                             "social_id":"",
                             "social_type":"",
                             "device_type":"ios",
                             "device_token":DeviceToken as Any
        ]
            print(parameter)
            networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.userSignUP.caseValue, parameter: parameter ) { (response) in
                print(response)
                self.hideProgress()
                let dic = response as! NSDictionary
                if dic.value(forKey: "success") as!Bool == true{
                   if let data = dic.value(forKey: "data") as? NSDictionary{
                    let userID = data.value(forKey: "user_id") as! NSString
                    UserDefaults.standard.set(userID, forKey: "UserID")
                    }
                 self.performPushSeguefromController(identifier: "SelectVoiceViewController")
                 }
                else{
                    self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
}
}
}
}


