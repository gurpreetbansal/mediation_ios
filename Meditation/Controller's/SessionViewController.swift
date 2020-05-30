//
//  SessionViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class SessioncollectionCell : UICollectionViewCell{
    
    @IBOutlet var BackImage: UIImageView!
    @IBOutlet var SessionName: UILabel!
    @IBOutlet var LockStatus: UIImageView!
}


class SessionViewController: UIViewController {
    
    @IBOutlet var sessionNameImage: UIImageView!
    @IBOutlet var RecordingBackImage: UIImageView!
    @IBOutlet var affirmationCodeView: UIView!
    @IBOutlet var affirmationImageview: UIImageView!
    @IBOutlet var sessionName: UILabel!
    @IBOutlet var AboutSessionLbl: UILabel!
    @IBOutlet weak var affirmationCollectionView: UICollectionView!
    @IBOutlet weak var leftRecommendImageView: UIImageView!
    @IBOutlet weak var rightRecommendImageView: UIImageView!
    
    var affirmationArray = NSArray()
    var recommendedArray = NSArray()
    var SessionMainName = ""
    var ButtonTap = ""
    var categoryId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.affirmationCollectionView.dataSource = self
        self.affirmationCollectionView.delegate = self
        GetAffirmationData()
    }
    
    override func viewWillAppear(_ animated: Bool){
        initfunc()
    }
    func initfunc(){
        //Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        affirmationCodeView.isUserInteractionEnabled = true
       // affirmationImageview.isUserInteractionEnabled = true
        affirmationCodeView.addGestureRecognizer(tap)
       // affirmationImageview.addGestureRecognizer(tap)
        self.affirmationCodeView.isHidden = true
        
        leftRecommendImageView.image = UIImage(named: "Recommended1")
        rightRecommendImageView.image = UIImage(named: "Recommended2")
        if SessionMainName == "0"{
            sessionName.text = "Weight Loss"
            sessionNameImage.image = #imageLiteral(resourceName: "WMainImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "WMainImage")
            AboutSessionLbl.text = "Affirmations to inspire and kickstart your weight Loss"
        }
      else if SessionMainName == "1"{
            sessionName.text = "Professional"
            sessionNameImage.image = #imageLiteral(resourceName: "PRecordingImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "PRecordingImage")
            AboutSessionLbl.text = "Affirmations for a happier day,life and work balance"
        }
        else if SessionMainName == "2"{
            sessionName.text = "Stress"
            sessionNameImage.image = #imageLiteral(resourceName: "SMainImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "SRecordingImage")
            AboutSessionLbl.text = "Affirmations for a strong and powerful mindset"
        }
        else if SessionMainName == "3"{
            sessionName.text = "Relationships"
            sessionNameImage.image = #imageLiteral(resourceName: "RMainImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "ARecordingImage")
            AboutSessionLbl.text = "Affirmations to strengthen and spark your relationships"
        }
        else if SessionMainName == "4"{
            sessionName.text = "Athletic"
            sessionNameImage.initGradientView(view: sessionNameImage, colour1: leftAthletic_Colour, colour2: RightAthletic_Colour)
            RecordingBackImage.image = #imageLiteral(resourceName: "RRecording")
            AboutSessionLbl.text = "Affirmations for a happier day,life and work balance"
        }
        else if SessionMainName == "5"{
            sessionName.text = "Health"
            sessionNameImage.image = #imageLiteral(resourceName: "HMainImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "HMainImage")
            AboutSessionLbl.text = "Affirmations to rejuuvinate and refresh your body and mind"
        }
        else if SessionMainName == "6"{
            sessionName.text = "Financial"
            sessionNameImage.initGradientView(view: sessionNameImage, colour1: leftFinancial_Colour, colour2: RightFinancial_Colour)
            RecordingBackImage.image = #imageLiteral(resourceName: "SRecordingImage")
            AboutSessionLbl.text = "Affirmations for a happier day,life and work balance"
        }
        else if SessionMainName == "7"{
            sessionName.text = "Abundance"
            sessionNameImage.image = #imageLiteral(resourceName: "SRecordingImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "SRecordingImage")
            AboutSessionLbl.text = "Affirmations to strengthen your gratitude and abundance"
        }
        else if SessionMainName == "Health"{
            sessionName.text = "Health"
            sessionNameImage.image = #imageLiteral(resourceName: "HMainImage")
            RecordingBackImage.image = #imageLiteral(resourceName: "HMainImage")
            AboutSessionLbl.text = "Affirmations to rejuuvinate and refresh your body and mind"
        }
        else if SessionMainName == "Abundance"{
            sessionName.text = "Abundance"
            sessionNameImage.image = UIImage (named: "ARecordingImage")
            RecordingBackImage.image = UIImage (named: "AMainImage")
            AboutSessionLbl.text = "Affirmations to rejuuvinate and refresh your body and mind"
        }
      }
    
    //Action of tap gesture
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.affirmationCodeView.isHidden = true
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Recommend1Tap(_ sender: UIButton) {
        let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        gotoSession.SessionMainName = "Abundance"
        self.navigationController?.pushViewController(gotoSession, animated: true)
    }
    
    
    @IBAction func Recomend2Tap(_ sender: UIButton) {
        let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        gotoSession.SessionMainName = "Health"
        self.navigationController?.pushViewController(gotoSession, animated: true)
        
    }
    
    @IBAction func myRecordingBtnTap(_ sender: UIButton) {
        let GotoAffirmation = self.storyboard?.instantiateViewController(withIdentifier: "MyAffirmationsViewController") as! MyAffirmationsViewController
        GotoAffirmation.catg_Id = categoryId
        self.navigationController?.pushViewController(GotoAffirmation, animated: true)
        if SessionMainName == "0"{
            GotoAffirmation.affirmationBased = "0"
        }
        else if SessionMainName == "1"{
            GotoAffirmation.affirmationBased = "1"
        }
        else if SessionMainName == "2"{
            GotoAffirmation.affirmationBased = "2"
        }
        else if SessionMainName == "3"{
            GotoAffirmation.affirmationBased = "3"
        }
        else if SessionMainName == "4"{
            GotoAffirmation.affirmationBased = "4"
        }
        else if SessionMainName == "5"{
            GotoAffirmation.affirmationBased = "5"
        }
        else if SessionMainName == "6"{
            GotoAffirmation.affirmationBased = "6"
        }
        
    }
    
}

extension SessionViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessioncollectionCell", for: indexPath) as! SessioncollectionCell
        
                let indexAffirmation = affirmationArray[indexPath.item]
                if let imageString = (indexAffirmation as AnyObject).value(forKey: "image") as? String {
                    if URL(string: (imageString) ) != nil {
                        cell.BackImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                        //cell.BackImage.contentMode = .scaleToFill
                    }
                }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return affirmationArray.count
    }
    
  
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessioncollectionCell", for: indexPath) as! SessioncollectionCell
//
//        let indexAffirmation = affirmationArray[indexPath.item]
//        if let imageString = (indexAffirmation as AnyObject).value(forKey: "image") as? String {
//            if URL(string: (imageString) ) != nil {
//                cell.BackImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
//                cell.BackImage.contentMode = .scaleToFill
//            }
//        }
//
////        cell.SessionName.text = sessionArray[indexPath.row]
//         if SessionMainName == "0"{
//             cell.BackImage.image = #imageLiteral(resourceName: "weightSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Weight Loss"
//            }
//            }
//            else if SessionMainName == "1"{
//                cell.BackImage.image = UIImage(named: "ProfessionalSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Professional"
//            }
//            }
//         else if SessionMainName == "2"{
//            cell.BackImage.image = #imageLiteral(resourceName: "StressSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Stress"
//            }
//        }
//         else if SessionMainName == "3"{
//            cell.BackImage.image = #imageLiteral(resourceName: "relationShipSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Healthy Relationships"
//            }
//         }
//         else if SessionMainName == "4"{
//            cell.BackImage.image = #imageLiteral(resourceName: "relationShipSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Athletic"
//            }
//        }
//         else if SessionMainName == "5"{
//            cell.BackImage.image = #imageLiteral(resourceName: "HealthSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Health"
//            }
//        }
//         else if SessionMainName == "6"{
//            cell.BackImage.image = #imageLiteral(resourceName: "StressSession")
//            if indexPath.row == 0{
//               cell.SessionName.text = "Financial"
//            }
//         }
//         else if SessionMainName == "7"{
//            cell.BackImage.image = #imageLiteral(resourceName: "AbudanceSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Abundance"
//            }
//         }
//         else if SessionMainName == "Health"{
//            cell.BackImage.image = #imageLiteral(resourceName: "HealthSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Health"
//            }
//        }
//         else if SessionMainName == "Abundance"{
//            cell.BackImage.image = #imageLiteral(resourceName: "AbudanceSession")
//            if indexPath.row == 0{
//                cell.SessionName.text = "Abundance"
//            }
//        }
//
//
//        if indexPath.row == 0{
//            cell.LockStatus.isHidden = true
//        }
//        else{
//             cell.LockStatus.isHidden = false
//        }
        
//        return cell
//
//}
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 105, height: 105)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
           self.performPushSeguefromController(identifier: "MusicPlayerViewController")
        }
        else{
           self.affirmationCodeView.isHidden = false
        }
    }
}

extension SessionViewController {
    func GetAffirmationData(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String : String] = ["user_id": userID,
                                          "cat_id": "\(categoryId)"]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.MyAffirmation.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSDictionary {
                    if let affirmationData = data.value(forKey: "affirmation") as? NSArray {
                        self.affirmationArray = affirmationData
                    }
                    if let recommendData = data.value(forKey: "recomended") as? NSArray {
                        self.recommendedArray = recommendData
                       let recommend1 = recommendData[0] as! NSDictionary
                        let recommend2 = recommendData[1] as! NSDictionary
                        if let imageleftString = recommend1.value(forKey: "image") as? String {
                            if URL(string: (imageleftString) ) != nil {
                                self.leftRecommendImageView.sd_setImage(with: URL(string: (imageleftString) ), placeholderImage:#imageLiteral(resourceName: "HMainImage"))
                            }
                        }
                        if let imageRightString = recommend2.value(forKey: "image") as? String {
                            if URL(string: (imageRightString) ) != nil {
                                self.rightRecommendImageView.sd_setImage(with: URL(string: (imageRightString) ), placeholderImage:#imageLiteral(resourceName: "HMainImage"))
                            }                        }
                    }
                }
                
                self.affirmationCollectionView.reloadData()
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
    }
}
