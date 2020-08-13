//
//  RecordViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class MyRecordingTableCell : UITableViewCell{
    @IBOutlet var RecordSoundImage: UIImageView!
    @IBOutlet var RecordSoundName: UILabel!
}
class RecordViewController: UIViewController {
    @IBOutlet weak var recordingTable: UITableView!
    @IBOutlet var upperview: UIView!
    @IBOutlet var backBtn: UIButton!
    var playAllSongsArr = NSArray()
    var iscomeFrom = ""
    var CategoryData = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        if iscomeFrom == "MyRecord"{
            self.backBtn.isHidden = false
        }else{
            self.backBtn.isHidden = true
        }
        GetRecordingData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func PlayAllBtn(_ sender: Any) {
        if self.playAllSongsArr.count != 0 {
            let Goto = self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            Goto.playAllSongs = self.playAllSongsArr
            Goto.isComesFrom = "PlayAll"
            self.navigationController?.pushViewController(Goto, animated: true)
        }
    }
    @IBAction func backTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetRecordingData(){
          // self.showProgress()
           let userID = UserDefaults.standard.value(forKey: "UserID") as! String
           let parameter : [String : Any] = ["user_id": userID]
           print(parameter)
           networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.myRecordings.caseValue, parameter: parameter) { (response) in
               print(response)
               self.hideProgress()
               let dic = response as! NSDictionary
               if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSDictionary{
                   if let category = data.value(forKey: "category") as? NSArray{
                        self.CategoryData = category
                    self.playAllSongsArr = dic.value(forKeyPath: "data.playall") as! NSArray

                    self.recordingTable.reloadData()
                    }
                   
               }else{
                   self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
               }
           }
        }
           
       }
}
extension RecordViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.CategoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecordingTableCell", for: indexPath) as! MyRecordingTableCell
        
        if let imageString = (CategoryData[indexPath.row] as AnyObject).value(forKey: "image") as? String{
            if URL(string: (imageString) ) != nil {
                cell.RecordSoundImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                //cell.RecordSoundImage.contentMode = .scaleAspectFill
                
            }
        }
       
        cell.RecordSoundName.text = ((self.CategoryData[indexPath.row] as AnyObject).value(forKey: "name") as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gotoRecord = self.storyboard?.instantiateViewController(withIdentifier: "MyAffirmationsViewController") as! MyAffirmationsViewController
       
        gotoRecord.catg_Id = "\((self.CategoryData[indexPath.row] as AnyObject).value(forKey: "id") as! NSNumber)"
        if indexPath.row == 0{
             gotoRecord.affirmationBased = "0"
        }
        else if indexPath.row == 1{
            gotoRecord.affirmationBased = "1"
        }
        else if indexPath.row == 2{
            gotoRecord.affirmationBased = "2"
        }
        else if indexPath.row == 3{
            gotoRecord.affirmationBased = "3"
        }
        else if indexPath.row == 4{
            gotoRecord.affirmationBased = "4"
        }
        else if indexPath.row == 5{
            gotoRecord.affirmationBased = "5"
        }
        else if indexPath.row == 6{
            gotoRecord.affirmationBased = "6"
        }
         self.navigationController?.pushViewController(gotoRecord, animated: true)
    }
    
}
