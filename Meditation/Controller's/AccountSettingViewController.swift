//
//  AccountSettingViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AccountSettingViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var lastnameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var nameEdit: UIButton!
    @IBOutlet var lastnameEdit: UIButton!
    @IBOutlet var emailEdit: UIButton!
    @IBOutlet var passwordEdit: UIButton!
    @IBOutlet var imageView: DesignableImage!
    
    var MyImage : UIImage!
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
       initFunction()
        Getprofile() //API Call
        // Do any additional setup after loading the view.
    }
    
    func initFunction(){
        
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
                passwordTF.isUserInteractionEnabled = true
                passwordEdit.setTitle("CHANGE", for: .normal)
            }
            else{
                passwordTF.isUserInteractionEnabled = false
                passwordEdit.setTitle("EDIT", for: .normal)
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
        uploadimage()  // Upload image Api call
    }
    
    //MARK:-  ================================= Action Sheet to open camera and gallery=========================
    func CameraActionSheet(){
          let optionMenu = UIAlertController(title: nil, message: "ChooseOption", preferredStyle: .actionSheet)
          let TakeAction = UIAlertAction(title: "TakePhoto", style: .default, handler: {
              (alert: UIAlertAction!) -> Void in
              self.opencamera()
          })
          let ChooseAction = UIAlertAction(title: "ChoosePhoto", style: .default, handler: {
              (alert: UIAlertAction!) -> Void in
              self.openGallery()
          })
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
              (alert: UIAlertAction!) -> Void in
          })
          // Add the actions
          imagePicker?.delegate = self
          optionMenu.addAction(TakeAction)
          optionMenu.addAction(ChooseAction)
          optionMenu.addAction(cancelAction)
          self.present(optionMenu, animated: true, completion: nil)
      }
    //MARK: ==============================Function to open Camera====================
     func opencamera()
     {
         if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
             imagePicker!.delegate = self
             imagePicker!.sourceType = UIImagePickerController.SourceType.camera
             imagePicker!.allowsEditing = true
             imagePicker!.cameraCaptureMode = UIImagePickerController.CameraCaptureMode.photo;
             self.present(imagePicker!, animated: true, completion: nil)
         }else{
             ShowAlertView(title: AppName, message: "problemCamera", viewController: self)
         }
     }
    //MARK:================= Function to open Gallery================================
     
     func openGallery()
     {
         if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
             imagePicker!.delegate = self
             imagePicker!.sourceType = UIImagePickerController.SourceType.photoLibrary;
             imagePicker!.allowsEditing = true
             self.present(imagePicker!, animated: true, completion: nil)
         }
     }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          guard let image = info[.editedImage] as? UIImage else { return }
          print(image.size)
          imageView.image = image
          MyImage = image
        dismiss(animated: true)
      }
    
}
//MARK:- API integration
extension AccountSettingViewController{
    
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
                     self.lastnameTF.text = fname
                 }
                  if let email = data.value(forKey: "email") as? String{
                     self.EmailTF.text = email
                 }
                
                if let password = data.value(forKey: "password") as? String{
                                    self.passwordTF.text = password
                                }
                
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
         self.showProgress()
         var image = MyImage
         let userID = UserDefaults.standard.value(forKey: "UserID")
         let parameter : [String:Any] = [
             "user_id" : String(describing:(userID)!),
         "first_name":lastnameTF.text!,
         "last_name":lastnameTF.text!,
         "gender":"",
         "dob":"",
         "password": passwordTF.text!
         ]
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
                 let alertController = UIAlertController(title: "Sleeplearning", message: "Profile updated successfully", preferredStyle: .alert)
                 let acceptAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                     self.Getprofile()
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
