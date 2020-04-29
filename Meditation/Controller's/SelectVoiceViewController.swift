//
//  SelectVoiceViewController.swift
//  Meditation
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class SelectVoiceCell : UITableViewCell{
    
    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userFlag: UIImageView!
    @IBOutlet var BackView: UIView!
    @IBOutlet var playPauseBtn: UIButton!
}

class SelectVoiceViewController: UIViewController {

    @IBOutlet var upperview: UIView!
    @IBOutlet var voiceTableView: UITableView!
    @IBOutlet var textTimePicker: UITextField!
    @IBOutlet var switchBtn: UISwitch!
    
    var isSelectedcell  = false
    var selectCell = -1
    var VoiceData = NSArray()
    var selectedVoiceId = [String]()
    var mySongString = ""
    var songmode = ""
    //Uidate picker
    let TimePicker = UIDatePicker()
    var voiceId  = ""
    var switchStatus = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        getvoiceList() // API Call
    self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        
        //show date picker
        showDatePicker()
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
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker(){
            self.view.endEditing(true)
        }
    @IBAction func backBtnTap(_ sender: UIButton) {
      //  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchTap(_ sender: UISwitch) {
        if switchBtn.isOn {
            self.switchStatus = 1
        }
        else{
            self.switchStatus = 0
        }
    }
    
    @IBAction func nextTap(_ sender: DesignableButton) {
        if voiceId == ""{
            self.ShowAlertView(title: AppName, message: "Please select voice first", viewController: self)
        }
        else if textTimePicker.text == ""{
            self.ShowAlertView(title: AppName, message: "Please choose your best time for meditate", viewController: self)
        }
        else{
            SingletonClass.sharedInstance.myAudioPlayer?.replaceCurrentItem(with: nil)
            postSelectVoice()
        }
    }
    
}

extension SelectVoiceViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VoiceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let voiceDict = self.VoiceData[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVoiceCell", for: indexPath) as! SelectVoiceCell
        // Get data from voice data
        cell.userName.text = voiceDict.value(forKey: "name") as! String
        if (voiceDict.value(forKey: "image") as! String == "") {
            cell.UserImage.image = #imageLiteral(resourceName: "name")
                   }
                   else{
                       // change image URL in to UIImage Type
                       let profileimage = URL(string: "\(voiceDict.value(forKey: "image") as! String)")
                        cell.UserImage.sd_setImage(with: profileimage, placeholderImage: #imageLiteral(resourceName: "name"))
                   }
        if let flagimage = voiceDict.value(forKey: "flag") as? String{
            let profileimage = URL(string: flagimage)
            cell.UserImage.sd_setImage(with: profileimage, placeholderImage: #imageLiteral(resourceName: "name"))
        }
        self.mySongString = voiceDict.value(forKey: "voices") as! String
        assignSong(urlString: mySongString)
        if selectCell == indexPath.row{
            if isSelectedcell == true{
                       cell.playPauseBtn.setImage(#imageLiteral(resourceName: "PrimoCodePauseSign"), for: .normal)
                
                self.voiceId = "\(voiceDict.value(forKey: "id") as! NSNumber)" as! String
                print("your voice id is :- \(self.voiceId)")
                self.selectedVoiceId.removeAll()
                self.selectedVoiceId.append(self.voiceId)
                       isPlay()
                   }
                   else{
                      cell.playPauseBtn.setImage(#imageLiteral(resourceName: "PlayWhite"), for: .normal)
                       isPause()
                   }
        }
        else{
            cell.playPauseBtn.setImage(#imageLiteral(resourceName: "PlayWhite"), for: .normal)
            isPause()
        }
        if indexPath.row == 0{
           cell.BackView.initGradientView(view: cell.BackView, colour1: LightSkyBlue_Colour, colour2: Green_Colour)
        }
        else if indexPath.row == 1{
            cell.BackView.initGradientView(view: cell.BackView, colour1: Pink_Colour, colour2: Orange_Colour)
        }
        else{
            cell.BackView.initGradientView(view: cell.BackView, colour1: darkSkyBlue_Colour, colour2: Blue_Colour)
        }
        cell.BackView.layer.borderWidth = 0
        if selectCell == indexPath.row{
            if isSelectedcell == true{
                cell.BackView.layer.borderWidth = 3
                cell.BackView.layer.borderColor = #colorLiteral(red: 0.3268497586, green: 0.7067340612, blue: 0.8769108653, alpha: 1)
            }
            else{
                cell.BackView.layer.borderWidth = 0
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell = indexPath.row
           isSelectedcell = true
        
         tableView.reloadData()
    }
    
}
//MARK:- API integration
extension SelectVoiceViewController{
    
    //MARK:- Get Voice list
    func getvoiceList(){
        self.showProgress()
        networkServices.shared.postDatawithoutHeaderWithoutParameter(methodName: methodName.UserCase.getVoiceList.caseValue) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            print(dic)
            if let data = dic.value(forKey: "data")as? NSArray{
                self.VoiceData = data as! NSArray
                self.voiceTableView.reloadData()
            }
        }
    }
   
    //MARK:-  post Voice and user Details
    func postSelectVoice(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = ["voice_id":  self.selectedVoiceId,
                                          "user_time": textTimePicker.text!,
                                          "status": 1,
                                          "user_id": userID as Any]
        print(parameter)
        
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.setVoice.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                            self.performPushSeguefromController(identifier: "SelectCategoriesViewController")
                        }
                        else{
                            self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                        }
        }
        
    }
}
