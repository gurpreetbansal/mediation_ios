//
//  SignInViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import AuthenticationServices
import Security
import UserNotifications
@available(iOS 13.0, *)
class SignInViewController: UIViewController,GIDSignInDelegate {
 
   
    @IBOutlet weak var appleView: DesignableView!
    @IBOutlet var View1: DesignableView!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
      private lazy var blackButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check user id for login or already login
        if  UserDefaults.standard.value(forKey: "UserID") as? String  != nil{
            performPushSeguefromController(identifier: "TabBarController")
        } else {
            let userId = UserDefaults.standard.string(forKey: "id") ?? "could not find any id"
            print(userId)
        }
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setUpSignInAppleButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // checkNotification()
    }
    
    
    //MARK:- Setup apple id button
    func setUpSignInAppleButton() {
       let authorizationButton = ASAuthorizationAppleIDButton()
       authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
       self.appleView.addSubview(authorizationButton)
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
       
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
    //MARK:- Login Button Tap
    
    
    
    @IBAction func loginTap(_ sender: DesignableButton) {
        if emailTF.text == ""{
            self.ShowAlertView(title: AppName, message: "Please enter valid email first", viewController: self)
        }
            else if (isValidEmail(testStr: emailTF.text!) == false){
                               ShowAlertView(title: AppName, message: "email must be in valid form", viewController: self)
                                   }
        else if passwordTF.text == ""{
            self.ShowAlertView(title: AppName, message: "Please enter password first", viewController: self)
        }
          else if ((passwordTF.text?.count)! <= 5){
                          ShowAlertView(title: AppName, message: "Password must be greater than five digits", viewController: self)
                      }
       else{
            SignInData() //API Call
        }
    }
    
    // Check valid Email
        func isValidEmail(testStr:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: testStr)
        }
       
    
    //MARK:- Google Button Tap
    @IBAction func GooglrBtnTap(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.delegate = self as GIDSignInDelegate
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //MARK:- Google SignIN Delegate Method ===========================
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                 withError error: Error!) {
           if let error = error {
               print("\(error.localizedDescription)")
           } else {
               // Perform any operations on signed in user here.
               let userId = user.userID                  // For client-side use only!
               _ = user.authentication.idToken // Safe to send to the server
               let fullName = user.profile.name
               _ = user.profile.givenName
               _ = user.profile.familyName
               let email = user.profile.email
               let dimension = round(100 * UIScreen.main.scale);
               let pic = user.profile.imageURL(withDimension: UInt(dimension))
               print(pic!)
               let urlString : String = (pic!.absoluteString)
            //let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")!
               let parameter = ["email": email!,
                                "first_name" : fullName!,
                               "profile" : urlString,
                                "social_id" :  userId!,
                                 "social_type" : "Gmail",
                                "device_type" : "ios",
                                "device_token" : "\(UserDefaults.standard.string(forKey: "DeviceToken") ?? "123131313121313131")"]
            print(parameter)
            self.RegisterApi(APIparameter:parameter )
           }
       }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                withError error: Error!) {
          // Perform any operations when the user disconnects from app here.
          print("user are disconnect with the App")
      }
      
      // MARK:- Register Data on Server With Alarmofire without profile pic
    func RegisterApi(APIparameter:[String:String]){
                self.showProgress()
                networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.SocialLogIn.caseValue, parameter:APIparameter) { (response) in
                    print(response)
                    self.hideProgress()
                    let dic = response as! NSDictionary
                    print (dic)
                    if dic.value(forKey: "success") as!Bool == true{
                        if let data = dic.value(forKey: "data") as? NSDictionary{
                            let userID = data.value(forKey: "user_id") as! NSString
                            UserDefaults.standard.set(userID, forKey: "UserID")
                            UserDefaults.standard.set("", forKey: "oldpassword")
                        }
                        self.performPushSeguefromController(identifier: "TabBarController")
                    }
                    else{
                        self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                    }
                }
           
        
    }
    //MARK:- faceBook Button Tap
    @IBAction func facebookBtnTap(_ sender: UIButton) {
       // let fbLoginManager : LoginManager = LoginManager()
            let loginManager = LoginManager()
             loginManager.logIn(permissions: ["email"] , viewController: self) { (Loginresult) in
                switch Loginresult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success( _, _, _):
                    
                    self.getFBUserData()
                }
            }
    }
    
    //MARK:-function is fetching the user data from Facebook
      func getFBUserData(){
          if((AccessToken.current) != nil){
              GraphRequest(graphPath: "me", parameters: ["fields": "id, name,first_name,last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                  if (error == nil){
                      print(result!)
                      let dict = result as! NSDictionary
                      print(dict)
                      let user_id = dict.value(forKey: "id") as! String
                      let user_name = dict.value(forKey: "name") as! String
                      let user_email = dict.value(forKey: "email") as!String
                      let picture = dict.value(forKey: "picture") as!NSDictionary
                      let pictureData = picture.value(forKey: "data") as! NSDictionary
                      let mypictureUrl = (pictureData.value(forKey: "url")) as!String
                      //let urlString : String = (mypictureUrl.absoluteString)
                  //  let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")!
                      let parameter = ["email":  user_email,
                                       "first_name" :   user_name,
                                      "profile" : mypictureUrl,
                                       "social_type" : "facebook",
                                       "social_id" :    user_id,
                                       "device_type" : "ios",
                                       "device_token" : "\(UserDefaults.standard.string(forKey: "DeviceToken") ?? "123131313121313131")"
                          
                      ]
                    print(parameter)
                    self.RegisterApi(APIparameter:parameter )
                      
                  }
              })
          }
      }
    
}
//MARK:- API integration
@available(iOS 13.0, *)
extension SignInViewController{
    func SignInData(){
                // Already authorized
                self.showProgress()
               // let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")!
                let parameter :[String: String] = [
                    "email":self.emailTF.text!,
                    "password":self.passwordTF.text!,
                    "device_type":"ios",
                    "device_token":"\(UserDefaults.standard.string(forKey: "DeviceToken") ?? "123131313121313131")"
                ]
                print(parameter)
                networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.UserSignIn.caseValue, parameter: parameter) { (response) in
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
extension SignInViewController:ASAuthorizationControllerDelegate{
    
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
       // let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")!
         let parameter = ["email":  userEmail,
                          "first_name" : full_name,
                          "profile" : "",
                          "social_type" : "apple",
                          "social_id" : userToken,
                          "device_type" : "ios",
                          "device_token" : "\(UserDefaults.standard.string(forKey: "DeviceToken") ?? "123131313121313131")"]
       print(parameter)
       self.RegisterApi(APIparameter:parameter )

    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
}
@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
