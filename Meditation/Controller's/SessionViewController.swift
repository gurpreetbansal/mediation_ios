//
//  SessionViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import Braintree
import BraintreeDropIn
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
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftRecommendImageView: UIImageView!
    @IBOutlet weak var rightRecommendImageView: UIImageView!
    var clientToken = ""
    var package_type = ""
    var payment_plan_id = ""
    var payment_plan_name = ""
    var affirmationArray = NSArray()
    var affirmationTopViewArray = NSArray()
    var recommendedArray = NSArray()
    var SessionMainName = ""
    var ButtonTap = ""
    var categoryId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.affirmationCollectionView.dataSource = self
        self.affirmationCollectionView.delegate = self
        self.sessionName.text = ""
        self.sessionNameImage.image = nil
        self.RecordingBackImage.image = nil
      
    }
    
    override func viewWillAppear(_ animated: Bool){
        initfunc()
        GetAffirmationData()
    }
    func initfunc(){
        //Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        affirmationCodeView.isUserInteractionEnabled = true
       // affirmationImageview.isUserInteractionEnabled = true
        affirmationCodeView.addGestureRecognizer(tap)
       // affirmationImageview.addGestureRecognizer(tap)
        self.affirmationCodeView.isHidden = true
        
//        leftRecommendImageView.image = UIImage(named: "Recommended1")
//        rightRecommendImageView.image = UIImage(named: "Recommended2")
      
      }
    
    //Action of tap gesture
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.affirmationCodeView.isHidden = true
    }
    func fetchClientToken() {
          // self.showProgress()
            let userID = UserDefaults.standard.value(forKey: "UserID") as! String
           networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.TokenGenerate.caseValue, parameter: ["id":userID]) { (response) in
               print(response)
               self.hideProgress()
               let dic = response as! NSDictionary
               if dic.value(forKey: "success") as!Bool == true{
                   if let data = dic.value(forKey: "data") as? NSDictionary {
                       if let token = data.value(forKey: "client_token") as? String {
                           self.clientToken = token
                           
                       }
                   }
               }
               else{
                   self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
               }
           }
       }
    @IBAction func PayMonthly(_ sender: Any) {
        self.package_type = "1"
        SetDropInPayment(amt:"7.99")
    }
    
    @IBAction func PayYearly(_ sender: Any) {
        self.package_type = "2"
        SetDropInPayment(amt:"150")
    }
    func SetDropInPayment(amt:String){
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: self.clientToken, request: request)
        {
         [unowned self] (controller, result, error) in
            
            if let error = error {
                self.show(message: error.localizedDescription)
                
            } else if (result?.isCancelled == true) {
                self.show(message: "Transaction Cancelled")
                
            } else if let nonce = result?.paymentMethod?.nonce{
                self.sendRequestPaymentToServer(nonce: nonce,amount:amt)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        
        self.present(dropIn!, animated: true, completion: nil)
    }
    func show(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func sendRequestPaymentToServer(nonce: String,amount: String) {
        print(nonce)
        //self.showProgress()
        print(Date.getCurrentDate())
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String : String] = ["users_id":userID,
                                             "amount":amount,
                                             "payment_date":Date.getCurrentDate(),
                                             "payment_plan_id":"",
                                             "payment_plan_name":"",
                                             "package_type":self.package_type,
                                             "nonce":nonce,
                                             "screenName": ""
                                            ]
            
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.Payment.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                 self.affirmationCodeView.isHidden = true
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success" , message: (dic.value(forKey: "messages") as! String), preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
                       self.GetAffirmationData()
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
                
              
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Recommend1Tap(_ sender: UIButton) {
        let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        gotoSession.categoryId = 69
        gotoSession.SessionMainName = "6"
        self.navigationController?.pushViewController(gotoSession, animated: true)
    }
    
    
    @IBAction func Recomend2Tap(_ sender: UIButton) {
        let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        gotoSession.SessionMainName = "Health"
        gotoSession.categoryId = 58
        self.navigationController?.pushViewController(gotoSession, animated: true)
        
    }
    
    @IBAction func myRecordingBtnTap(_ sender: UIButton) {
        let GotoAffirmation = self.storyboard?.instantiateViewController(withIdentifier: "MyAffirmationsViewController") as! MyAffirmationsViewController
        GotoAffirmation.catg_Id = "\(categoryId)"
        self.navigationController?.pushViewController(GotoAffirmation, animated: true)
              
        if self.SessionMainName == "Weight Loss"{
            GotoAffirmation.affirmationBased = "0"
        }
        else if self.SessionMainName == "Professional"{
            GotoAffirmation.affirmationBased = "1"
        }
        else if self.SessionMainName == "Stress"{
            GotoAffirmation.affirmationBased = "2"
        }
        else if self.SessionMainName == "Relationships"{
            GotoAffirmation.affirmationBased = "3"
        }
        else if self.SessionMainName == "Athletic"{
            GotoAffirmation.affirmationBased = "4"
        }
        else if self.SessionMainName == "Health"{
            GotoAffirmation.affirmationBased = "5"
        }
        else if self.SessionMainName == "Financial"{
           GotoAffirmation.affirmationBased = "6"
        }
        else if self.SessionMainName == "Abundance"{
            GotoAffirmation.affirmationBased = "7"
        }
        
    }
    
}

extension SessionViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessioncollectionCell", for: indexPath) as! SessioncollectionCell
        
        let indexAffirmation = affirmationArray[indexPath.item]
        if let imageString = (indexAffirmation as AnyObject).value(forKey: "images") as? String {
            if URL(string: (imageString) ) != nil {
                cell.BackImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:nil)
                //cell.BackImage.contentMode = .scaleToFill
            }
        }
        if let titleString = (indexAffirmation as AnyObject).value(forKey: "affirmation_title") as? String {
            cell.SessionName.text = titleString
        }
        self.payment_plan_id = "\((indexAffirmation as AnyObject).value(forKey: "nature_id") as! NSNumber)"
        self.payment_plan_name = "\((indexAffirmation as AnyObject).value(forKey: "nature_name") as! String)"
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let indexAffirmation = affirmationArray[indexPath.item]
        if let lockStatus = (indexAffirmation as AnyObject).value(forKey: "lockUnlockStatus") as? Int {
            if lockStatus == 0 {
                self.affirmationCodeView.isHidden = false
                fetchClientToken()
            }else {
                let GotoAffirmation = self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
                
                 GotoAffirmation.titleName = sessionName.text!
                 GotoAffirmation.subTitle = (indexAffirmation as AnyObject).value(forKey: "affirmation_title") as! String
                 GotoAffirmation.sessonId = "\((indexAffirmation as AnyObject).value(forKey: "nature_id") as! NSNumber)"
                 SingletonClass.sharedInstance.isFav = "\((indexAffirmation as AnyObject).value(forKey: "favourite") as! NSNumber)"
                GotoAffirmation.isComesFrom = "session"
                 self.navigationController?.pushViewController(GotoAffirmation, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
}

extension SessionViewController {
    func GetAffirmationData(){
      // self.showProgress()
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
                    if let affirmationData = data.value(forKey: "session") as? NSArray {
                        self.affirmationArray = affirmationData
                    }
                    if let affirmationTopData = data.value(forKey: "affirmation") as? NSArray {
                        if affirmationTopData.count != 0{
                        self.SessionMainName = (affirmationTopData[0] as AnyObject).value(forKey: "name") as! String
                        self.sessionName.text = self.SessionMainName
                        self.sessionNameImage.sd_setImage(with: URL(string: (affirmationTopData[0] as AnyObject).value(forKey: "image") as! String ), placeholderImage:nil)
                        self.RecordingBackImage.sd_setImage(with: URL(string: (affirmationTopData[0] as AnyObject).value(forKey: "image") as! String ), placeholderImage:nil)
                        
                        if self.SessionMainName == "Weight Loss"{
                            self.AboutSessionLbl.text = "Affirmations to inspire and kickstart your weight Loss"
                        }
                        else if self.SessionMainName == "Professional"{
                            self.AboutSessionLbl.text = "Affirmations to help you achieve your professional goals"
                        }
                        else if self.SessionMainName == "Stress"{
                            self.AboutSessionLbl.text = "Affirmations to help find relaxation and peace in all areas of your life"
                        }
                        else if self.SessionMainName == "Relationships"{
                            self.AboutSessionLbl.text = "Affirmations to help you build positive connections and lasting relationships"
                        }
                        else if self.SessionMainName == "Athletic"{
                            self.AboutSessionLbl.text = "Athletic affirmations to boost your performance and help you mentally"
                        }
                        else if self.SessionMainName == "Health"{
                            self.AboutSessionLbl.text = "Affirmations to allow your body to heal and become more resilient"
                        }
                        else if self.SessionMainName == "Financial"{
                            self.AboutSessionLbl.text = "Affirmations to improve your finances and build your wealth"
                        }
                        else if self.SessionMainName == "Abundance"{
                            self.AboutSessionLbl.text = "Affirmations to strengthen your gratitude and abundance"
                        }
                        
//                        else if self.SessionMainName == "Abundance"{
//                            self.AboutSessionLbl.text = "Affirmations to rejuuvinate and refresh your body and mind"
//                        }
                        }
                    }
                    if let recommendData = data.value(forKey: "recomended") as? NSArray {
                        self.recommendedArray = recommendData
                       let recommend1 = recommendData[0] as! NSDictionary
                        let recommend2 = recommendData[1] as! NSDictionary
                        if let imageleftString = recommend1.value(forKey: "image") as? String {
                            if URL(string: (imageleftString) ) != nil {
                                //self.leftRecommendImageView.sd_setImage(with: URL(string: (imageleftString) ), placeholderImage:#imageLiteral(resourceName: "HMainImage"))
                            }
                        }
                        if let imageRightString = recommend2.value(forKey: "image") as? String {
                            if URL(string: (imageRightString) ) != nil {
                                //self.rightRecommendImageView.sd_setImage(with: URL(string: (imageRightString) ), placeholderImage:#imageLiteral(resourceName: "HMainImage"))
                            }                        }
                    }
                }
                if (self.affirmationArray.count).isMultiple(of: 3) {
                    self.collectionViewHeight.constant = CGFloat((self.affirmationArray.count / 3) * 120)
                }else{
                     self.collectionViewHeight.constant = CGFloat((self.affirmationArray.count / 3) * 120 + 100)
                }
                
                self.affirmationCollectionView.reloadData()
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
    }
}
