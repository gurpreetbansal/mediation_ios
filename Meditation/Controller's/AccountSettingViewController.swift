//
//  AccountSettingViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class AccountSettingViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var lastnameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var nameEdit: UIButton!
    @IBOutlet var lastnameEdit: UIButton!
    @IBOutlet var emailEdit: UIButton!
    @IBOutlet var passwordEdit: UIButton!
    @IBOutlet var imageView: DesignableImage!
    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordViewHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordViewHeight: NSLayoutConstraint!
    
    var myOldPassword = String()
    var MyImage : UIImage!
    //var imagePicker:UIImagePickerController?=UIImagePickerController()
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
       initFunction()
        Getprofile() //API Call
        // Do any additional setup after loading the view.
    }
    
    func initFunction(){
        newPasswordTf.delegate = self
        confirmPasswordTF.delegate = self
        confirmPasswordViewHeight.constant = 0
        confirmPasswordView.isHidden = true
        newPasswordView.isHidden = true
        newPasswordViewHeight.constant = 0
        //nameTF.isUserInteractionEnabled = false
        lastnameTF.isUserInteractionEnabled = false
        passwordTF.isUserInteractionEnabled = false
        EmailTF.isUserInteractionEnabled = false
    }

    @IBAction func EditTap(_ sender: UIButton) {
        
//        if sender.tag == 0{
//            if nameEdit.titleLabel?.text == "EDIT"
//            {
//                //nameTF.isUserInteractionEnabled = true
//                nameEdit.setTitle("CHANGE", for: .normal)
//            }
//            else{
//                //nameTF.isUserInteractionEnabled = false
//                nameEdit.setTitle("EDIT", for: .normal)
//            }
//        }
         if sender.tag == 1{
            if lastnameEdit.titleLabel?.text == "EDIT"
            {
                lastnameTF.isUserInteractionEnabled = true
                lastnameEdit.setTitle("CHANGE", for: .normal)
            }
            else{
                lastnameTF.isUserInteractionEnabled = false
                lastnameEdit.setTitle("EDIT", for: .normal)
            }
        }
        else  if sender.tag == 2{
            if emailEdit.titleLabel?.text == "EDIT"
            {
                EmailTF.isUserInteractionEnabled = false
                emailEdit.setTitle("CHANGE", for: .normal)
            }
            else{
                EmailTF.isUserInteractionEnabled = false
                emailEdit.setTitle("EDIT", for: .normal)
            }
        }
        else  if sender.tag == 3{
            if passwordEdit.titleLabel?.text == "EDIT"
            {
                confirmPasswordViewHeight.constant = 70
                newPasswordViewHeight.constant = 70
                confirmPasswordView.isHidden = false
                newPasswordView.isHidden = false
                passwordTF.isUserInteractionEnabled = true
                passwordEdit.setTitle("CHANGE", for: .normal)
                oldPasswordLabel.font = UIFont(name:"Comfortaa-Regular",size:15)
                oldPasswordLabel.text = "Old Password"
            }
            else{
                if (passwordTF.text == "") && (newPasswordTf.text == "") && (confirmPasswordTF.text == ""){
                    passwordTF.isUserInteractionEnabled = false
                    passwordEdit.setTitle("EDIT", for: .normal)
                    confirmPasswordViewHeight.constant = 0
                    confirmPasswordView.isHidden = true
                    newPasswordView.isHidden = true
                    newPasswordViewHeight.constant = 0
                }
            }
        }
    }
    
    @IBAction func BackBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraBtnTap(_ sender: UIButton) {
         CameraActionSheet()
    }
    
    @IBAction func saveBtnTap(_ sender: UIButton) {
//        if ((passwordTF.text?.count)! <= 6){
//            ShowAlertView(title: AppName, message: "Password must be greater than six digits", viewController: self)
//        }
//        else{
            uploadimage()  // Upload image Api call
//        }
        
    }
    
    //MARK:-  ================================= Action Sheet to open camera and gallery=========================
       func CameraActionSheet(){
              let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
                    
                    let showCamera = UIAlertAction(title: "Camera", style: .default, handler: { _ in
                        self.openCamera()
                    })
                    
                    let openGallery = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                        self.openGallary()
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    optionMenu.addAction(showCamera)
                    optionMenu.addAction(openGallery)
                    optionMenu.addAction(cancelAction)
                    
                    
                    self.present(optionMenu, animated: true, completion: nil)
         }
       //MARK: ==============================Function to open Camera====================
       func presentCameraSettings() {
               let alertController = UIAlertController(title: "Error",
                                                       message: "Camera access is denied",
                                                       preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
               alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
                   if let url = URL(string: UIApplication.openSettingsURLString) {
                       UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                           // Handle
                       })
                   }
               })
               
               present(alertController, animated: true)
           }
           func openCamera()
           {
               if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
               {
                   checkCameraAccess()
                   imagePicker.sourceType = UIImagePickerController.SourceType.camera
                   imagePicker.allowsEditing = true
                   imagePicker.delegate = self
                   self.present(imagePicker, animated: true, completion: nil)
               }
               else
               {
                   let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
           }
       func checkCameraAccess() {
           switch AVCaptureDevice.authorizationStatus(for: .video) {
           case .denied:
               print("Denied, request permission from settings")
               presentCameraSettings()
           case .restricted:
               print("Restricted, device owner must approve")
           case .authorized:
               print("Authorized, proceed")
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: .video) { success in
                   if success {
                       print("Permission granted, proceed")
                   } else {
                       print("Permission denied")
                   }
               }
           }
       }
       //MARK:================= Function to open Gallery================================
        
        func openGallary()
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           print(info)
           if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
               //imageParam = pickedImage
               imageView.image = pickedImage
               MyImage = pickedImage
               //profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
               //profileImageView.clipsToBounds = true
               
           }
           picker.dismiss(animated: true, completion: nil)
       }
}
//MARK:- API integration
extension AccountSettingViewController{
    
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
                    self.lastnameTF.text = fname
                }
                if let email = data.value(forKey: "email") as? String{
                    self.EmailTF.text = email
                }
                //self.passwordTF.text = (UserDefaults.standard.value(forKey: "oldpassword") as! String)
                
                
                if (data.value(forKey: "profile") as? String) == ""{
                    self.imageView.image = #imageLiteral(resourceName: "Asset 28")
                }
                else{
                    let Myimage = (data.value(forKey: "profile") as? String)
                    let profileImageUrl = URL(string: Myimage!)
                    if let profile = try? Data(contentsOf: profileImageUrl!)
                    {
                        let image: UIImage = UIImage(data: profile)!
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    //Uploadimage API
    func uploadimage(){
        
        //myOldPassword = UserDefaults.standard.value(forKey: "oldpassword") as! String
       // self.showProgress()
        var image = MyImage
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String:Any] = [
            "user_id" : String(describing:(userID)!),
            "first_name":lastnameTF.text!,
            "last_name":lastnameTF.text!,
            "gender":"",
            "dob":"",
            "old_password": passwordTF.text!,
            "new_password": newPasswordTf.text!
        ]
        UserDefaults.standard.set(passwordTF.text!, forKey: "oldpassword")
        print(parameter)
        let methodname = methodName.UserCase.editProfile.caseValue
        let url1 = BaseURL
        let url = ("\(url1)" + "\(methodname)")
        if image == nil{
            
        }
        else{
            image = MyImage
        }
        uploadImage(urlString: url, params: parameter, imageKeyValue: "file", image: image, success: { (response) in
            print(response)
            self.hideProgress()
            if response.value(forKey: "success") as! Bool == true{
                // Show alert View
                let alertController = UIAlertController(title: "Selfpause", message: (response.value(forKey: "messages") as! String), preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                    self.Getprofile()
                    self.initFunction()
                    self.passwordEdit.setTitle("EDIT", for: .normal)
                }
                alertController.addAction(acceptAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.ShowAlertView(title: AppName, message: response.value(forKey: "messages") as! String, viewController: self)
            }
            
        }) { (error) in
            print(error)
        }
    }
}
extension AccountSettingViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case newPasswordTf:
            if newPasswordTf.text!.count >= 6 {
                //newPasswordTf.resignFirstResponder()
                confirmPasswordTF.isUserInteractionEnabled = true
                //confirmPasswordTF.becomeFirstResponder()
            }else {
                confirmPasswordTF.isUserInteractionEnabled = false
                let alertController = UIAlertController(title: "Error", message: "Password should be greater than 6 characters", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                //newPasswordTf.becomeFirstResponder()
                //confirmPasswordtxtField.resignFirstResponder()
            }
        case confirmPasswordTF:
            if confirmPasswordTF.text == ""{
                confirmPasswordTF.becomeFirstResponder()
            }
            else if confirmPasswordTF.text != newPasswordTf.text{
                //confirmPasswordtxtField.becomeFirstResponder()
                let alertController = UIAlertController(title: "Error", message: "Passwords don't Match", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        default:
            print("no error")
        }
    }
    
}
