//
//  SettingsViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SettingtableCell : UITableViewCell{
    
    @IBOutlet var settingLbl: UILabel!
    }

class SettingsViewController: UIViewController {

    @IBOutlet var LogoutView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LogoutView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogoutNoTap(_ sender: UIButton) {
        self.LogoutView.isHidden = true
    }
    
    
    @IBAction func LogoutYesTap(_ sender: DesignableButton) {
       logout() // logout API Call
    }
    
    
    @IBAction func BackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return SettingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingtableCell", for: indexPath) as! SettingtableCell
        cell.settingLbl.text = SettingData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
          performPushSeguefromController(identifier: "NotificationViewController")
        }
        else if indexPath.row == 1{
            let Help = self.storyboard?.instantiateViewController(withIdentifier: "HelpSupportViewController")as! HelpSupportViewController
            Help.iscomeFrom = "Support"
            self.navigationController?.pushViewController(Help, animated: true)
            
           
        }
        else if indexPath.row == 2{
            let Help = self.storyboard?.instantiateViewController(withIdentifier: "HelpSupportViewController")as! HelpSupportViewController
            Help.iscomeFrom = "Help"
            self.navigationController?.pushViewController(Help, animated: true)
            
           
        }
        else if indexPath.row == 3{
            performPushSeguefromController(identifier: "AccountSettingViewController")
        }
        else if indexPath.row == 4{
            let gotoPrivacy = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            gotoPrivacy.privacyStatus = "Terms"
            self.navigationController?.pushViewController(gotoPrivacy, animated: true)
        }
        else if indexPath.row == 5{
            let gotoPrivacy = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            gotoPrivacy.privacyStatus = "Privacy"
            self.navigationController?.pushViewController(gotoPrivacy, animated: true)
        }
        else if indexPath.row == 6{
            let gotoAccount = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
            gotoAccount.iscomeFrom = "Account"
            self.navigationController?.pushViewController(gotoAccount, animated: true)
            
        }
        if indexPath.row == 7{
            self.LogoutView.isHidden = false
        }
    }
}

//MARK:- API Integration
extension SettingsViewController{
    
     //MARK:- Logout API
      func logout(){
          self.showProgress()
          let userID = UserDefaults.standard.value(forKey: "UserID")
          let parameter : [String:Any] = ["user_id":userID as Any]
          networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.LogOut.caseValue, parameter: parameter) { (response) in
              print(response)
              self.hideProgress()
              let dic = response as! NSDictionary
              if dic.value(forKey: "success") as! Bool == true{
                  UserDefaults.standard.removeObject(forKey: "UserID")
                  self.performPushSeguefromController(identifier: "SignInViewController")
              }
          }
      }
}
