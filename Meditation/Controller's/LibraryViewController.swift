//
//  LibraryViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import Braintree
import BraintreeDropIn
import ModernSearchBar
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

class LibraryViewController: UIViewController, BTDropInViewControllerDelegate,UITextFieldDelegate, ModernSearchBarDelegate {
    
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        
    }
    

    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet var upperview: UIView!
    @IBOutlet var HomeTableView: UITableView!
    @IBOutlet var promoCodeView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var mainBannerImageView: UIImageView!
    @IBOutlet weak var mainBannerLabel: UILabel!
    
    var CategorySearchList = [SearchCategory]()
    var homeCategoryData = NSArray()
    var randomDict = NSDictionary()
    var stuffArr = NSArray()
    var natureArr = NSArray()
    var interestArr = NSArray()
    var sessionType = String()
    var clientToken = ""
    var package_type = ""
    var payment_plan_id = ""
    var payment_plan_name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         initfunc()
        checkNotification()
        Getprofile()
        GetHomeData()  //API Call
        fetchClientToken()
           // Do any additional setup after loading the view.
//       let clientTokenURL = URL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
//              var clientTokenRequest = URLRequest(url: clientTokenURL)
//              clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
//
//              URLSession.shared.dataTask(with: clientTokenRequest) {
//                  (data, response, error) -> Void in
//                  // TODO: Handle errors
//                self.clientToken = String(data: data!, encoding: String.Encoding.utf8)!
//                print(self.clientToken)
//                  // Initialize `Braintree` once per checkout session
//                //  self.braintree = Braintree(clientToken: self.clientToken)
//
//                  // As an example, you may wish to present our Drop-in UI at this point.
//                  // Continue to the next section to learn more...
//              }.resume()

        
         makingSearchBarAwesome()
        // configureSearchBar()
        
    }
    
    private func makingSearchBarAwesome(){
        self.modernSearchBar.placeholder = "Search"
        self.modernSearchBar.backgroundImage = UIImage()
        self.modernSearchBar.layer.borderWidth = 0
        self.modernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
        self.modernSearchBar.layer.cornerRadius = 20
    }
    ///Called if you use String suggestion list
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: " + "\(item)")
        for i in 0..<self.homeCategoryData.count{
            if (self.homeCategoryData[i] as AnyObject).value(forKey: "name") as! String == item  {
                print("We've got index!")
                print(self.homeCategoryData[i])
                let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
                let indexCategory = homeCategoryData[i]
                    if let cat_Id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
                        gotoSession.categoryId = cat_Id
                        print(cat_Id)
                    }
                
                if i == 0{
                    gotoSession.SessionMainName = "0"
                }
                else if i == 1{
                    gotoSession.SessionMainName = "1"
                }
                else if i == 2{
                    gotoSession.SessionMainName = "2"
                }
                else if i == 3{
                    gotoSession.SessionMainName = "3"
                }
                else if i == 4{
                    gotoSession.SessionMainName = "4"
                }
                else if i == 5{
                    gotoSession.SessionMainName = "5"
                }
                else if i == 6{
                    gotoSession.SessionMainName = "6"
                }
                else if i == 7{
                    gotoSession.SessionMainName = "7"
                }
                self.navigationController?.pushViewController(gotoSession, animated: true)
            } else {
                print("No index here – sorry!")
            }
        }
    }
    ///Called if you use Custom Item suggestion list
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title+" with this url: "+item.url.description)
        
    }
    ///Called when user touched shadowView
    func onClickShadowView(shadowView: UIView) {
        print("User touched shadowView")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change, what i'm suppose to do ?")
    }
    private func configureSearchBar(){
        ///Create array of string
        var suggestionList = Array<String>()
        suggestionList.append("Onions")
        suggestionList.append("Celery")
        suggestionList.append("Very long vegetable to show you that cell is updated and fit all the row")
        suggestionList.append("Potatoes")
        suggestionList.append("Carrots")
        suggestionList.append("Broccoli")
        suggestionList.append("Asparagus")
        suggestionList.append("Apples")
        suggestionList.append("Berries")
        suggestionList.append("Kiwis")
        suggestionList.append("Raymond")
        
        ///Adding delegate
        self.modernSearchBar.delegateModernSearchBar = self
        
        ///Set datas to search bar
        self.modernSearchBar.setDatas(datas: suggestionList)
        
        ///Custom design with all paramaters if you want to
        //self.customDesign()
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        if textField.text == ""{
            
        }else{
            self.searchCategoryApi(txt:textField.text!)
        }
        return true
    }

    func searchCategoryApi(txt:String) {
           //self.showProgress()
           let userID = UserDefaults.standard.value(forKey: "UserID") as! String
           let parameter : [String : String] = ["user_id":userID,
                                                "title":txt]
           print(parameter)
           networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.searchCategory.caseValue, parameter: parameter) { (response) in
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
    
    func userDidCancelPayment() {
        self.dismiss(animated: true, completion: nil)
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
        let gotoSesssion = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        CheckSession()
        let indexCategory = self.randomDict
        if let cat_Id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
            gotoSesssion.categoryId = cat_Id
            print(cat_Id)
        }
        gotoSesssion.SessionMainName = sessionType
        self.navigationController?.pushViewController(gotoSesssion, animated: true)
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
        SetDropInPayment(amt:"150.0")
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
       // self.showProgress()
        print(Date.getCurrentDate())
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String : String] = ["users_id":userID,
                                             "amount":amount,
                                             "payment_date":Date.getCurrentDate(),
                                             "payment_plan_id":self.payment_plan_id,
                                             "payment_plan_name":self.payment_plan_name,
                                             "package_type":self.package_type,
                                             "nonce":nonce,
                                             "screenName": "1"
                                            ]
            
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.Payment.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                 self.promoCodeView.isHidden = true
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success" , message: (dic.value(forKey: "messages") as! String), preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
                       self.GetHomeData()
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
                
              
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
       
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: HomeTableView.frame.width, height: 50))
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textColor = .darkGray
        label.font = UIFont(name: "Comfortaa", size: 22)
        headerView.addSubview(label)
        
        let EditButton = UIButton()
        EditButton.frame = CGRect.init(x: 150, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        EditButton.setTitle("Edit", for: .normal)
        EditButton.setTitleColor(.darkGray, for: .normal)
        headerView.addSubview(EditButton)
        
        if section == 0{
            label.text = "My Interests"
            EditButton.isHidden = false
            EditButton.addTarget(self, action: #selector(pressed),
                                 for: .touchUpInside)
        }
        else if section == 1{
            EditButton.isHidden = true
            label.text = "My Stuff"
        }
        else if section == 2{
            EditButton.isHidden = true
            label.text = "Soundscapes"
        }
        else if section == 3{
            EditButton.isHidden = true
            label.text = "All Categories"
        }
        return headerView
    }
    @objc func pressed(sender: UIButton) {
        self.performPushSeguefromController(identifier: "SelectCategoriesViewController")
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
                    cell.CategoryImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "relationShipSession"))
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
            let indexCategory = self.interestArr[indexPath.row]
            if let cat_Id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
                gotoSession.categoryId = cat_Id
                print(cat_Id)
            }
          
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
            
              self.navigationController?.pushViewController(gotoSession, animated: true)
        }
       else if indexPath.section == 3{
            let gotoSession = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
            let indexCategory = homeCategoryData[indexPath.row]
                if let cat_Id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
                    gotoSession.categoryId = cat_Id
                    print(cat_Id)
                }
            
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
            self.navigationController?.pushViewController(gotoSession, animated: true)
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
        
//        if let lockUnlockStatus = (indexNature as AnyObject).value(forKey: "lockUnlockStatus") as? NSNumber {
//            if lockUnlockStatus == 0{
//                cell.natureLockStatus.isHidden = false
//            }else{
                cell.natureLockStatus.isHidden = true
//            }
//        }
        if let imageString = (indexNature as AnyObject).value(forKey: "images") as? String {
            if URL(string: (imageString) ) != nil {
                cell.natureImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                cell.natureImage.contentMode = .scaleToFill
            }
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexNature = natureArr[indexPath.item]
        self.payment_plan_id = "\((indexNature as AnyObject).value(forKey: "nature_id") as! NSNumber)"
        self.payment_plan_name = "\((indexNature as AnyObject).value(forKey: "nature_name") as! String)"
        if let lockUnlockStatus = (indexNature as AnyObject).value(forKey: "lockUnlockStatus") as? NSNumber {
            if lockUnlockStatus == 0{
                self.promoCodeView.isHidden = false
            }else{
               let GotoAffirmation = self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
                
                GotoAffirmation.titleName = "Soundscapes"
                GotoAffirmation.subTitle = (indexNature as AnyObject).value(forKey: "nature_name") as! String
                GotoAffirmation.uploadRecordingUrl = (indexNature as AnyObject).value(forKey: "songs") as! String
                GotoAffirmation.soundImage = (indexNature as AnyObject).value(forKey: "images") as! String
                GotoAffirmation.isComesFrom = "sounds"
                self.navigationController?.pushViewController(GotoAffirmation, animated: true)
            }
        }
    }
    
}
extension LibraryViewController {
    //MARK:- GetProfile API
           func Getprofile(){
              // self.showProgress()
               let userID = UserDefaults.standard.value(forKey: "UserID")
               let parameter : [String:Any] = ["user_id":userID as Any]
               networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.getProfile.caseValue, parameter: parameter) { (response) in
                   print(response)
                   self.hideProgress()
                   let dic = response as! NSDictionary
                  if dic.value(forKey: "success") as! Bool == true{
                      let data = dic.value(forKey: "data")as! NSDictionary
                       
                       if (data.value(forKey: "profile") as? String) == ""{
                       }else{
                        let Myimage = (data.value(forKey: "profile") as? String)
                        UserDefaults.standard.set(Myimage, forKey: "UserProfileImage")
                        UserDefaults.standard.set((data.value(forKey: "first_name") as? String), forKey: "UserProfileName")
                       }
                   }
               }
               }
    func GetHomeData(){
       // self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String : Any] = ["user_id": userID, "type_id": "2"]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.GetHomeData.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            self.homeCategoryData = NSArray()
            self.randomDict = NSDictionary()
            self.stuffArr = NSArray()
            self.natureArr = NSArray()
            self.interestArr = NSArray()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSDictionary {
                    if let homeData = data.value(forKey: "categories") as? NSArray {
                        self.homeCategoryData = homeData
                        
                        var cat_name = [String]()
                        
                        for i in 0 ..< homeData.count{
                            cat_name.append((homeData[i] as AnyObject).value(forKey: "name") as! String)
//                            self.CategorySearchList.append(SearchCategory(Category_name: (homeData[i] as AnyObject).value(forKey: "name") as! String,
//
//                                category_id: "\((homeData[i] as AnyObject).value(forKey: "id") as! NSNumber)"))
                        }
                        ///Adding delegate
                        self.modernSearchBar.delegateModernSearchBar = self
                        self.modernSearchBar.setDatas(datas:cat_name)
                        
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
            }else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
        
    }
}
extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        return dateFormatter.string(from: Date())

    }
}
