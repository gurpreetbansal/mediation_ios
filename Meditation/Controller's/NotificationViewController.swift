//
//  NotificationViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class notificationTableCell : UITableViewCell{
    @IBOutlet weak var desc: UILabel!
    @IBOutlet var BackView: DesignableView!
    @IBOutlet weak var title: UILabel!
}

class NotificationViewController: UIViewController {
    @IBOutlet weak var notificationTable: UITableView!
    @IBOutlet var textTimePicker: UITextField!
    @IBOutlet var switchBtn: UISwitch!
    let TimePicker = UIDatePicker()
    var NotificationList = NSArray()
    var switchStatus = "1"
    var voiceID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationTable.estimatedRowHeight = 88.0
        self.notificationTable.rowHeight = UITableView.automaticDimension
       // NotificationListApi()
        //show date picker
        showDatePicker()
        getuserVoiceAPI()
        // Do any additional setup after loading the view.
    }
    func showDatePicker(){
           //Formate Date
           TimePicker.datePickerMode = .time
           
           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
           
           textTimePicker.inputAccessoryView = toolbar
           textTimePicker.inputView = TimePicker
       }

    @objc func donedatePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: TimePicker.date)
        textTimePicker.text = strDate
        self.edituserVoiceAPI()
        self.view.endEditing(true)
    }
           
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
   
    @IBAction func switchTap(_ sender: UISwitch) {
        if switchBtn.isOn {
            self.switchStatus = "1"
            UIApplication.shared.registerForRemoteNotifications()
             self.NotificationHandling(status: "1")
        }
        else{
             UIApplication.shared.unregisterForRemoteNotifications()
            self.switchStatus = "0"
             self.NotificationHandling(status: "0")
        }
    }
    func NotificationHandling(status:String){
       // self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String:String] = ["user_id":userID, "status":status]
        
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.notificationONOFF.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as! Bool == true{
                
            }
        }
    }
    func getuserVoiceAPI(){
       // self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String:String] = ["user_id":userID]
        
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.getUserVoice.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as! Bool == true{
                let a = dic.value(forKeyPath: "data.voice_id") as! NSArray
                let b = a[0] as! NSArray
                self.voiceID = b[0] as! String
            }
        }
    }
    func edituserVoiceAPI(){
       // self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String:String] = ["user_id":userID,
                                           "voice_id": self.voiceID,
                                           "time":self.textTimePicker.text!,
                                           "status":self.switchStatus]
        
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.getUserVoice.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as! Bool == true{
                
            }
        }
    }
    @IBAction func BackBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func NotificationListApi(){
      //  self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String:String] = ["user_id":userID]
        
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.notificationList.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as! Bool == true{
                self.NotificationList = dic.value(forKey: "data") as! NSArray
            }
            self.notificationTable.reloadData()
            
        }
    }
}


extension NotificationViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.NotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationTableCell", for: indexPath) as! notificationTableCell
        cell.BackView.NewdropShadow()
        cell.title.text = ((self.NotificationList[indexPath.row] as AnyObject).value(forKey: "title") as! String)
        cell.desc.text = ((self.NotificationList[indexPath.row] as AnyObject).value(forKey: "body") as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UIView{
    // OUTPUT 1
    func NewdropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
