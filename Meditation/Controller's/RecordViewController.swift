//
//  RecordViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyRecordingTableCell : UITableViewCell{
    
    @IBOutlet var RecordSoundImage: UIImageView!
    @IBOutlet var RecordSoundName: UILabel!
}

class RecordViewController: UIViewController {
    
    @IBOutlet var upperview: UIView!
    @IBOutlet var backBtn: UIButton!
    
    var iscomeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
           self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        if iscomeFrom == "MyRecord"{
            self.backBtn.isHidden = false
            
        }
        else{
            self.backBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    @IBAction func backTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecordViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecordingTableCell", for: indexPath) as! MyRecordingTableCell
        cell.RecordSoundImage.image = HomeCategoryArray[indexPath.row]
        cell.RecordSoundName.text = HomeCategoryName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gotoRecord = self.storyboard?.instantiateViewController(withIdentifier: "MyAffirmationsViewController") as! MyAffirmationsViewController
       
        self.navigationController?.pushViewController(gotoRecord, animated: true)
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
    }
    
}
