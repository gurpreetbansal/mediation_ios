//
//  HelpSupportViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class HelpSupportViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var DescriptionView: DesignableTextView!
    @IBOutlet weak var HelpTF: UITextField!
    @IBOutlet weak var Tittlelbl: UIButton!
    
    var iscomeFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if iscomeFrom == "Support"{
            Tittlelbl.setTitle("Support", for: .normal)
        }
        else{
            Tittlelbl.setTitle("Help Center", for: .normal)
        }
        
      DescriptionView.text = "Add Description"
      DescriptionView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func SubmitTap(_ sender: UIButton) {
        if HelpTF.text == ""{
                  ShowAlertView(title: AppName, message: "Please enter Tittle", viewController: self)
              }
              else if DescriptionView.text == "Description"{
                  ShowAlertView(title: AppName, message: "Please enter Description", viewController: self)
              }
              else{
                  SubmitDetail()
              }
    }
    //MARK:- Submit Detail
       func SubmitDetail(){
           self.showProgress()
           let userId = (UserDefaults.standard.value(forKey: "UserID"))
           
           let parameter : [String:Any] = [ "user_id": (userId as? String)! ,
                                            "suppert_subject":HelpTF.text!,
                                            "support_message":DescriptionView.text]
           networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.support.caseValue, parameter: parameter) { (response) in
               print(response)
               self.hideProgress()
               let dic = response as! NSDictionary
               if dic.value(forKey: "success")as! Bool == true{
                self.DescriptionView.text = "Add Description"
                self.HelpTF.text = ""
                   self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages") as! String, viewController: self)
                   
               }
               else{
                   self.ShowAlertView(title: AppName, message: dic.value(forKey: "message") as! String, viewController: self)
                   
               }
           }
       }
    
    
    //TextView Delegate method
    func textViewDidBeginEditing(_ textView: UITextView) {
        if DescriptionView.textColor == UIColor.lightGray {
            DescriptionView.text = nil
            DescriptionView.textColor = UIColor.lightGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if DescriptionView.text.isEmpty {
            DescriptionView.text = "Add Description"
            DescriptionView.textColor = UIColor.lightGray
        }
    }
}
