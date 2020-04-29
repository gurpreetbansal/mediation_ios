//
//  LibraryViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import BraintreeDropIn
import Braintree

class MyInterestTableCell : UITableViewCell{
    @IBOutlet var CategoryImage: UIImageView!
    @IBOutlet var categoryName: UILabel!
}
class MyStuffTableCell : UITableViewCell{
    @IBOutlet weak var leftStuffLabel: UILabel!
    @IBOutlet weak var rightStuffLabel: UILabel!
}
class NatureTableCell : UITableViewCell{
    @IBOutlet var NatureCollectionView: UICollectionView!
}
class NatureImageCollectionCell : UICollectionViewCell{
    @IBOutlet var natureImage: UIImageView!
    @IBOutlet var natureLockStatus: UIImageView!
}
class AllCategoryTableCell : UITableViewCell{
    
    @IBOutlet var CategoryImage: UIImageView!
    @IBOutlet var categoryName: UILabel!
}

class LibraryViewController: UIViewController {

    @IBOutlet var upperview: UIView!
    @IBOutlet var HomeTableView: UITableView!
    @IBOutlet var promoCodeView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var mainBannerImageView: UIImageView!
    @IBOutlet weak var mainBannerLabel: UILabel!
    
    var toKinizationKey = ""
    var homeCategoryData = NSArray()
    var randomDict = NSDictionary()
    var stuffArr = NSArray()
    var natureArr = NSArray()
    var interestArr = NSArray()
    var sessionType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initfunc()
        GetHomeData()  //API Call
        
           // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initfunc()
    }
    
    func initfunc(){
       
        
        self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        
        //Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        promoCodeView.isUserInteractionEnabled = true
        //affirmatiocodeView.isUserInteractionEnabled = true
        promoCodeView.addGestureRecognizer(tap)
       // affirmatiocodeView.addGestureRecognizer(tap)
        self.promoCodeView.isHidden = true
    }
    
    //Action of tap gesture
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.promoCodeView.isHidden = true
    }
    
    @IBAction func TopWeekTap(_ sender: UIButton) {
        let gotoSesssion = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController
        CheckSession()
        gotoSesssion!.SessionMainName = sessionType
          self.navigationController?.pushViewController(gotoSesssion!, animated: true)
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
        SetDropInPayment(amt:"7.99")
    }
    @IBAction func PayYearly(_ sender: Any) {
        SetDropInPayment(amt:"150")
    }
    func SetDropInPayment(amt:String){
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: toKinizationKey, request: request)
        { [unowned self] (controller, result, error) in
            
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
           self.showProgress()
           
                 let userID = UserDefaults.standard.value(forKey: "UserID")
                     let parameter : [String : Any] = ["nonce": nonce,
                        "amount": amount]
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
   
    func CheckSession(){
        if let SessionMainName = randomDict.value(forKey: "description") as? String{
        if SessionMainName == "Weight Loss"{
              sessionType = "0"
          }
        else if SessionMainName == "Professional"{
              sessionType = "1"
          }
          else if SessionMainName == "Stress"{
              sessionType = "2"
          }
          else if SessionMainName == "Relationships"{
              sessionType = "3"
          }
          else if SessionMainName == "Athletic"{
              sessionType = "4"
          }
          else if SessionMainName == "Health"{
              sessionType = "5"
          }
          else if SessionMainName == "Financial"{
              sessionType = "6"
          }
          else if SessionMainName == "Abundance"{
              sessionType = "7"
          }
          else if SessionMainName == "Health"{
              sessionType = "Health"
          }
          else if SessionMainName == "Abundance"{
              sessionType = "Abundance"
          }
        }
    }
    
    @IBAction func myFavoritesTap(_ sender: UIButton) {
        self.performPushSeguefromController(identifier: "MyFavouriteViewController")
    }
    
    @IBAction func MyRecordingTap(_ sender: UIButton) {
        let gotoRecord = self.storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
        gotoRecord.iscomeFrom = "MyRecord"
        self.navigationController?.pushViewController(gotoRecord, animated: true)
        
         
    }
    
    
    }

extension LibraryViewController : UITableViewDelegate,UITableViewDataSource{
    
    //for header in section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: HomeTableView.frame.width, height: 40))
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textColor = .darkGray
        label.font = UIFont(name: "Comfortaa", size: 22)
        headerView.addSubview(label)
        if section == 0{
            label.text = "My Interests"
        }
        else if section == 1{
            label.text = "My Stuff"
        }
        else if section == 2{
            label.text = "Nature"
        }
        else if section == 3{
            label.text = "All Categories"
        }
        return headerView
    }
    
    //Height for hearder
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
    // Number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return interestArr.count
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else {
            return homeCategoryData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = HomeTableView.dequeueReusableCell(withIdentifier: "MyInterestTableCell", for: indexPath) as! MyInterestTableCell
            let indexCategory = interestArr[indexPath.row]
            if let name = (indexCategory as AnyObject).value(forKey: "name") as? String {
                cell.categoryName.text = name
            }
            if let imageString = (indexCategory as AnyObject).value(forKey: "image") as? String {
                if URL(string: (imageString) ) != nil {
                    cell.CategoryImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                }
            }
            return cell
        }
        else if indexPath.section == 1{
            let cell = HomeTableView.dequeueReusableCell(withIdentifier: "MyStuffTableCell", for: indexPath) as! MyStuffTableCell
            let stuff1 = stuffArr[0] as! NSDictionary
                       let stuff2 = stuffArr[1] as! NSDictionary
            if let nameleft = stuff1.value(forKey: "type") as? String {
                cell.leftStuffLabel.text = nameleft
                cell.leftStuffLabel.font = UIFont(name: "Comfortaa-Bold", size: 12)
            }
            if let nameRight = stuff2.value(forKey: "type") as? String {
                cell.rightStuffLabel.text = nameRight
                cell.rightStuffLabel.font = UIFont(name: "Comfortaa-Bold", size: 12)
            }
            return cell
            
        }
        else if indexPath.section == 2{
            let cell = HomeTableView.dequeueReusableCell(withIdentifier: "NatureTableCell", for: indexPath) as! NatureTableCell
            cell.NatureCollectionView.delegate = self
            cell.NatureCollectionView.dataSource = self
            cell.NatureCollectionView.reloadData()
            return cell
        }
        else {
            let cell = HomeTableView.dequeueReusableCell(withIdentifier: "AllCategoryTableCell", for: indexPath) as! AllCategoryTableCell
            let indexCategory = homeCategoryData[indexPath.row]
            if let name = (indexCategory as AnyObject).value(forKey: "name") as? String {
                cell.categoryName.text = name
            }
            if let imageString = (indexCategory as AnyObject).value(forKey: "image") as? String {
                if URL(string: (imageString) ) != nil {
                    cell.CategoryImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return 205
        }
        else if indexPath.section == 1{
            return 85
        }
        else{
          return 90
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.section == 0{
            let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
            self.navigationController?.pushViewController(gotoSession, animated: true)
            if indexPath.row == 0{
                gotoSession.SessionMainName = "0"
            }
            else if indexPath.row == 1{
                gotoSession.SessionMainName = "1"
            }
            else if indexPath.row == 2{
                gotoSession.SessionMainName = "2"
            }
            
        }
       else if indexPath.section == 3{
            let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
            let indexCategory = homeCategoryData[indexPath.row]
                if let cat_Id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
                    gotoSession.categoryId = cat_Id
                    print(cat_Id)
                }
            self.navigationController?.pushViewController(gotoSession, animated: true)
            if indexPath.row == 0{
                gotoSession.SessionMainName = "0"
            }
            else if indexPath.row == 1{
                gotoSession.SessionMainName = "1"
            }
            else if indexPath.row == 2{
                gotoSession.SessionMainName = "2"
            }
            else if indexPath.row == 3{
                gotoSession.SessionMainName = "3"
            }
            else if indexPath.row == 4{
                gotoSession.SessionMainName = "4"
            }
            else if indexPath.row == 5{
                gotoSession.SessionMainName = "5"
            }
            else if indexPath.row == 6{
                gotoSession.SessionMainName = "6"
            }
            else if indexPath.row == 7{
                gotoSession.SessionMainName = "7"
            }
            
        }
        
    }
    
}

extension LibraryViewController : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return natureArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NatureImageCollectionCell", for: indexPath) as! NatureImageCollectionCell
        let indexNature = natureArr[indexPath.item]
        if let imageString = (indexNature as AnyObject).value(forKey: "images") as? String {
            if URL(string: (imageString) ) != nil {
                cell.natureImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                cell.natureImage.contentMode = .scaleToFill
            }
        }
//        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
            cell.natureLockStatus.isHidden = true
//        }
//        else{
//            cell.natureLockStatus.isHidden = false
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexNature = natureArr[indexPath.item]
        if let audio = (indexNature as AnyObject).value(forKey: "songs") as? String {
            _ = UIStoryboard(name: "Main", bundle: nil)
            let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            let url = NSURL(string: audio)
            viewController.audioUrl = url!
            self.navigationController?.pushViewController(viewController, animated: true)
        }
//        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
//            self.performPushSeguefromController(identifier: "MusicPlayerViewController")
//        }
//        else{
            //self.promoCodeView.isHidden = false
//        }
    }
    
}

 

extension LibraryViewController {
    
    func GetHomeData(){
        self.showProgress()
      let userID = UserDefaults.standard.value(forKey: "UserID")
             let parameter : [String : Any] = ["user_id": userID as Any,
                "type_id": "2"]
             print(parameter)
   networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.GetHomeData.caseValue, parameter: parameter) { (response) in
       print(response)
       self.hideProgress()
       let dic = response as! NSDictionary
       if dic.value(forKey: "success") as!Bool == true{
        if let data = dic.value(forKey: "data") as? NSDictionary {
            if let homeData = data.value(forKey: "categories") as? NSArray {
                self.homeCategoryData = homeData
                print(self.homeCategoryData)
            }
          if let randomDictionary = data.value(forKey: "random") as? NSDictionary {
               self.randomDict = randomDictionary
          //      if let name = randomDictionary.value(forKey: "name") as? String{
          //          self.mainBannerLabel.text = name
           //     }
            self.mainBannerLabel.isHidden = true
                if let imageString = randomDictionary.value(forKey: "image") as? String{
                    if URL(string: (imageString) ) != nil {
                        self.mainBannerImageView.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                        self.mainBannerImageView.contentMode = .scaleAspectFill
                        self.mainBannerImageView.layer.cornerRadius = 5
                    }
                }
            }
            if let stuffArray = data.value(forKey: "mystuff") as? NSArray {
                self.stuffArr = stuffArray
            }
            if let natureArray = data.value(forKey: "nature") as? NSArray {
                self.natureArr = natureArray
            }
            if let interest = data.value(forKey: "interested") as? NSArray {
                self.interestArr = interest
            }
        }
        self.HomeTableView.dataSource = self
        self.HomeTableView.delegate = self
        self.HomeTableView.reloadData()
                   }
                   else{
                       self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                   }
   }
     
    }
}
