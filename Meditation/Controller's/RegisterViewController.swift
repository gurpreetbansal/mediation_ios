//
//  RegisterViewController.swift
//  Meditation
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AuthenticationServices
import Security
@available(iOS 13.0, *)
class RegisterViewController: UIViewController {
    @IBOutlet weak var appleView: DesignableView!
    @IBOutlet var emailView: DesignableView!
    @IBOutlet var firstNameView: DesignableView!
    @IBOutlet var View1: DesignableView!
    @IBOutlet var passwordView: DesignableView!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //checkNotification()
         initFunction()
       // setUpSignInAppleButton()
     }
    
    func initFunction(){
        let colorLeft = UIColor(red: 219.0 / 255.0, green: 145.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
        let colorRight = UIColor(red: 163.0 / 255.0, green: 181.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
        
        self.View1.initGradientView(view: self.View1, colour1: colorLeft, colour2: colorRight)
        firstNameView.NewdropShadow()
        emailView.NewdropShadow()
        passwordView.NewdropShadow()
    }
    //MARK:- Setup apple id button
    func setUpSignInAppleButton() {
       let authorizationButton = ASAuthorizationAppleIDButton()
       authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
       self.appleView.addSubview(authorizationButton)
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
//        let screenSize = UIScreen.main.bounds
//        let screenHeight = screenSize.height
           NSLayoutConstraint.activate([
           authorizationButton.centerXAnchor.constraint(equalTo: self.appleView.centerXAnchor),
           authorizationButton.centerYAnchor.constraint(equalTo: self.appleView.centerYAnchor),
           authorizationButton.widthAnchor.constraint(equalTo: self.appleView.widthAnchor),
           authorizationButton.heightAnchor.constraint(equalTo: self.appleView.heightAnchor)
           ])
        
        
        
    }
    @objc func handleLogInWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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

@available(iOS 13.0, *)
extension RegisterViewController{
    
    func RegisterData(){
         self.showProgress()
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
                             "device_token": "\(UserDefaults.standard.string(forKey: "DeviceToken") ?? "123131313121313131")"
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


//MARK:-Apple Id login
@available(iOS 13.0, *)
extension RegisterViewController:ASAuthorizationControllerDelegate{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName
            let email = appleIDCredential.email
            UserDefaults.standard.set("\(userIdentifier)", forKey: "userIdentifier")
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
          
            
            // Check User is either Logged in with Apple Id or not ...
            if email == nil{
                let Alert = UIAlertController(title: "Alert", message: "It looks you didn't reset your existing account to Sign In again. Please follow these steps, open the Settings - tap your Account - Password & security - Apple ID logins. Find your application under Sign In with Apple and swipe to delete it.", preferredStyle: UIAlertController.Style.alert)
                
                Alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                   guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                       return
                   }

                   if UIApplication.shared.canOpenURL(settingsUrl) {
                       UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                           print("Settings opened: \(success)") // Prints true
                       })
                   }
                }))
                Alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                    Alert .dismiss(animated: true, completion: nil)
                }))
                self.present(Alert, animated: true, completion: nil)
                
            }else{
                self.signInApple(userEmail: email!, userToken: userIdentifier, full_name: fullName!)
            }
            
            
            
            // For the purpose of this demo app, show the Apple ID credential information
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
               // self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    func signInApple(userEmail:String, userToken:String, full_name:String) {
      //  let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")!
         let parameter = ["email":  userEmail,
                          "first_name" : full_name,
                          "profile" : "",
                          "social_type" : "apple",
                          "social_id" : userToken,
                          "device_type" : "ios",
                          "device_token" : "\(UserDefaults.standard.string(forKey: "DeviceToken") ?? "123131313121313131")"]
       print(parameter)
       //self.RegisterApi(APIparameter:parameter )

    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
}
@available(iOS 13.0, *)
extension RegisterViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
