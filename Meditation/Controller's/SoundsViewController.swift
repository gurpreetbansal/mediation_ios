//
//  SoundsViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Braintree

class SoundNatureImageTableCell : UITableViewCell{
    @IBOutlet var natureCollectionView: UICollectionView!
}

class SoundNatureCollectionCell : UICollectionViewCell{
    
    @IBOutlet var natureImage: UIImageView!
    @IBOutlet var natureImageLock: UIImageView!
}

class SoundsViewController: UIViewController {

    var songId = Int()
    var songName = String()
    var isMusic = Bool()
    var toKinizationKey = ""
    var soundScapesArr = NSArray()
    var musicArr = NSArray()
    
    @IBOutlet var upperview: UIView!
    @IBOutlet weak var PromoCodeView: UIView!
    
    @IBOutlet var SoundTableView: UITableView!
    var SoundType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initfunc()
        PromoCodeView.isHidden = true
         self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        GetSoundData()
        // Do any additional setup after loading the view.
    }
    func initfunc(){
           //Tap Gesture
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
           PromoCodeView.isUserInteractionEnabled = true
           //affirmatiocodeView.isUserInteractionEnabled = true
           PromoCodeView.addGestureRecognizer(tap)
          // affirmatiocodeView.addGestureRecognizer(tap)
           self.PromoCodeView.isHidden = true
       }
       
       //Action of tap gesture
       @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
           // handling code
           self.PromoCodeView.isHidden = true
       }
       
    func fetchClientToken() {
        self.showProgress()
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.TokenGenerate.caseValue, parameter: [:]) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
             if let data = dic.value(forKey: "data") as? NSDictionary {
             if let token = data.value(forKey: "clientToken") as? String {
                 self.toKinizationKey = token
                
             }
                }
                        }
                        else{
                            self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                        }
        }
    }
    @IBAction func PayMonthly(_ sender: Any) {
       // SetDropInPayment(amt:"7.99",planType:"1")
    }
    
    @IBAction func PayYearly(_ sender: Any) {
       // SetDropInPayment(amt:"150",planType:"2")
    }
//    func SetDropInPayment(amt:String,planType:String){
//         let request =  BTDropInRequest()
//         let dropIn = BTDropInController(authorization: toKinizationKey, request: request)
//         { [unowned self] (controller, result, error) in
//
//             if let error = error {
//                 self.show(message: error.localizedDescription)
//
//             } else if (result?.isCancelled == true) {
//                 self.show(message: "Transaction Cancelled")
//
//             } else if let nonce = result?.paymentMethod?.nonce{
//                self.sendRequestPaymentToServer(nonce: nonce,amount:amt,type:planType)
//             }
//             controller.dismiss(animated: true, completion: nil)
//         }
//
//         self.present(dropIn!, animated: true, completion: nil)
//     }
     func show(message: String) {
         DispatchQueue.main.async {
             let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
             self.present(alertController, animated: true, completion: nil)
         }
     }
    func getCurrentShortDate() -> String {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    func sendRequestPaymentToServer(nonce: String,amount: String,type: String) {
         print(nonce)
        let datee = getCurrentShortDate()
            self.showProgress()
            
                  let userID = UserDefaults.standard.value(forKey: "UserID")
                      let parameter : [String : Any] = [
        "users_id":"\(userID!)",
        "amount":amount,
        "paymentMethodNonce":nonce,
        "payment_date":"\(datee)",
        "payment_plan_id":"\(songId)",
        "payment_plan_name":"\(songName)",
        "package_type":type
        ]
                      print(parameter)
            networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.Payment.caseValue, parameter: parameter) { (response) in
                print(response)
                self.hideProgress()
                let dic = response as! NSDictionary
                if dic.value(forKey: "success") as!Bool == true{
                 
                            }
                            else{
                                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                            }
            }
        }
    
}

extension SoundsViewController : UITableViewDelegate , UITableViewDataSource{
    
    //for header in section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SoundTableView.frame.width, height: 40))
        let label = UILabel()
        headerView.backgroundColor = .clear
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textColor = .darkGray
        label.font = UIFont(name: "Comfortaa", size: 22)
        headerView.addSubview(label)
        if section == 0{
            label.text = "Soundscapes"
        }
        else if section == 1{
            label.text = "Music"
        }
    return headerView
    }
    
    //Height for hearder
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    // Number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SoundTableView.dequeueReusableCell(withIdentifier: "SoundNatureImageTableCell", for: indexPath) as! SoundNatureImageTableCell
        if indexPath.section == 0{
            SoundType = "Soundscapes"
            cell.natureCollectionView.tag = indexPath.section
            cell.natureCollectionView.delegate = self
            cell.natureCollectionView.dataSource = self
            cell.natureCollectionView.reloadData()
        }
        else{
            SoundType = "Music"
            cell.natureCollectionView.tag = indexPath.section
            cell.natureCollectionView.delegate = self
            cell.natureCollectionView.dataSource = self
            cell.natureCollectionView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    
}

extension SoundsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if SoundType == "Soundscapes"{
        return soundScapesArr.count
        
    }
    else{
        return musicArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundNatureCollectionCell", for: indexPath) as! SoundNatureCollectionCell
            cell.natureImageLock.isHidden = true
            let indexNature = soundScapesArr[indexPath.item]
            if let imageString = (indexNature as AnyObject).value(forKey: "images") as? String {
                if URL(string: (imageString) ) != nil {
                    cell.natureImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                    cell.natureImage.contentMode = .scaleToFill
                }
            }
            //cell.natureImage.image = soundScapesArray[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundNatureCollectionCell", for: indexPath) as! SoundNatureCollectionCell
            cell.natureImageLock.isHidden = true
            let indexNature = musicArr[indexPath.item]
            if let imageString = (indexNature as AnyObject).value(forKey: "images") as? String {
                if URL(string: (imageString) ) != nil {
                    cell.natureImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                    cell.natureImage.contentMode = .scaleToFill
                }
            }
            //cell.natureImage.image = MusicArray[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            let indexNature = soundScapesArr[indexPath.item]
            if let lockStatus = (indexNature as AnyObject).value(forKey: "lockUnlockStatus") as? Int {
                if lockStatus == 0 {
                    PromoCodeView.tag = indexPath.item
                    isMusic = false
                    PromoCodeView.isHidden = false
                    if let id = (indexNature as AnyObject).value(forKey: "nature_id") as? Int {
                        songId = id
                    }
                    if let name = (indexNature as AnyObject).value(forKey: "nature_name") as? String {
                        songName = name
                    }
                    fetchClientToken()
                }else {
                    if let audio = (indexNature as AnyObject).value(forKey: "songs") as? String {
                        _ = UIStoryboard(name: "Main", bundle: nil)
                        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
                        let url = NSURL(string: audio)
                        viewController.audioUrl = url!
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
        else{
            let indexNature = musicArr[indexPath.item]
            if let lockStatus = (indexNature as AnyObject).value(forKey: "lockUnlockStatus") as? Int {
                           if lockStatus == 0 {
                               PromoCodeView.tag = indexPath.item
                               isMusic = true
                               PromoCodeView.isHidden = false
                            if let id = (indexNature as AnyObject).value(forKey: "nature_id") as? Int {
                                songId = id
                            }
                            if let name = (indexNature as AnyObject).value(forKey: "nature_name") as? String {
                                songName = name
                            }
                               fetchClientToken()
                           }else {
                            if let audio = (indexNature as AnyObject).value(forKey: "songs") as? String {
                                           _ = UIStoryboard(name: "Main", bundle: nil)
                                           let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
                                           let url = NSURL(string: audio)
                                           viewController.audioUrl = url!
                                           self.navigationController?.pushViewController(viewController, animated: true)
                                       }
                }
                       }
        }
    }
    
}
extension SoundsViewController {
    
    func GetSoundData(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = ["user_id": userID as Any]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.Sounds.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSDictionary {
                    if let musicArray = data.value(forKey: "Music") as? NSArray {
                        self.musicArr = musicArray
                    }
                    if let soundScapesArray = data.value(forKey: "SoundScopes") as? NSArray {
                        self.soundScapesArr = soundScapesArray
                    }
                }
                self.SoundTableView.dataSource = self
                self.SoundTableView.delegate = self
                self.SoundTableView.reloadData()
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
            
            
        }
    }
}
