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

class SignInViewController: UIViewController,GIDSignInDelegate {
 
    @IBOutlet var View1: DesignableView!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check user id for login or already login
               if  UserDefaults.standard.value(forKey: "UserID") as? String  != nil{
                   performPushSeguefromController(identifier: "TabBarController")
               }
               else {
                   let userId = UserDefaults.standard.string(forKey: "id") ?? "could not find any id"
                   print(userId)
               }
        GIDSignIn.sharedInstance()?.delegate = self
       GIDSignIn.sharedInstance()?.presentingViewController = self
       
        // Do any additional setup after loading the view.
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
          else if ((passwordTF.text?.count)! <= 6){
                          ShowAlertView(title: AppName, message: "Password must be greater than six digits", viewController: self)
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
               let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")
               let parameter = ["email": email!,
                                "first_name" : fullName!,
                               "profile" : urlString,
                                "social_id" :  userId!,
                                 "social_type" : "Gmail",
                                "device_type" : "ios",
                                "device_token" : DeviceToken]
            print(parameter)
               self.RegisterApi(APIparameter:parameter as! [String : String])
           }
       }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                withError error: Error!) {
          // Perform any operations when the user disconnects from app here.
          print("user are disconnect with the App")
      }
      
      // MARK:- Register Data on Server With Alarmofire without profile pic
      func RegisterApi(APIparameter:[String:String]){
          showProgress()
          networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.SocialLogIn.caseValue, parameter:APIparameter) { (response) in
              print(response)
              self.hideProgress()
              let dic = response as! NSDictionary
              print (dic)
              if dic.value(forKey: "success") as!Bool == true{
                  if let data = dic.value(forKey: "data") as? NSDictionary{
                      let userID = data.value(forKey: "user_id") as! NSString
                      UserDefaults.standard.set(userID, forKey: "UserID")
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
                      let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")
                      let parameter = ["email":  user_email,
                                       "first_name" :   user_name,
                                      "profile" : mypictureUrl,
                                       "social_type" : "facebook",
                                       "social_id" :    user_id,
                                       "device_type" : "ios",
                                       "device_token" : DeviceToken
                          
                      ]
                    print(parameter)
                      self.RegisterApi(APIparameter:parameter as! [String : String] )
                      
                  }
              })
          }
      }
    
}
//MARK:- API integration
extension SignInViewController{
    func  SignInData(){
           self.showProgress()
          let DeviceToken = UserDefaults.standard.string(forKey: "DeviceToken")
          let parameter :[String: String] = [
              "email":emailTF.text!,
              "password":passwordTF.text!,
              "device_type":"ios",
              "device_token":DeviceToken!
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
                  self.performPushSeguefromController(identifier: "TabBarController")
              }
              else{
                  self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
              }
          }
     }
    
}
