//
//  SelectCategoriesViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import UIKit
import Alamofire
import SDWebImage

class SelectCategoriesCell : UITableViewCell{
    
    @IBOutlet var CategoryImage: UIImageView!
    @IBOutlet var CategoryName: UILabel!
    @IBOutlet var BackView: DesignableView!
    
}

class SelectCategoriesViewController: UIViewController {
    
    @IBOutlet var upperview: UIView!
    
    var isSelectedcell  = false
    var selectCell = -1
    var categoryData = [categoryList]()
    var appendZeroArray = [Int]()
    var chooseCategoryId = NSMutableArray()
    @IBOutlet var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoryList()
        self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextTap(_ sender: DesignableButton) {
        if chooseCategoryId.count == 0{
            self.ShowAlertView(title: AppName, message: "Please Select category first", viewController: self)
        }
        else{
            postSetContent()
            
        }
        
    }
    
}

extension SelectCategoriesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoriesCell", for: indexPath) as! SelectCategoriesCell
        if appendZeroArray[indexPath.row] == 1{
            cell.BackView.layer.borderWidth = 3
            cell.BackView.layer.borderColor = #colorLiteral(red: 0.3268497586, green: 0.7067340612, blue: 0.8769108653, alpha: 1)
        }
        else{
            cell.BackView.layer.borderWidth = 0
        }
        cell.CategoryName.text = categoryData[indexPath.row].Category_name
        if let imageString = categoryData[indexPath.row].category_Image as? String{
            if imageString != ""{
                if URL(string: (imageString) ) != nil {
                    cell.CategoryImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectCell = indexPath.row
        if appendZeroArray[indexPath.row] == 0{
            appendZeroArray[indexPath.row] = 1
            
            self.chooseCategoryId.add(self.categoryData[indexPath.row].category_id as Any)
            print("my choose Category array is \(self.chooseCategoryId)")
        }
        else{
            self.appendZeroArray[indexPath.row] = 0
            
            self.chooseCategoryId.remove(self.categoryData[indexPath.row].category_id as Any)
            print("my choose Category array is \(self.chooseCategoryId)")
        }
        isSelectedcell = true
        // tableView.reloadData()
        UIView.performWithoutAnimation {
               tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
}
//MARK:- API Integration
extension SelectCategoriesViewController{
    
    //MARK:- Get Category list
    func getCategoryList(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = ["user_id": userID as Any,
                                          "type_id": "2"]
        print(parameter)
        let methodname = methodName.UserCase.getCategoryList.caseValue
        let baseURL = BaseURL + methodname
        Alamofire.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            self.hideProgress()
            if response.result.isSuccess{
                print("success")
                if let dict = response.result.value as? NSDictionary{
                    print(dict)
                    if dict.value(forKey: "success") as! Bool == true{
                        let data = dict.value(forKey: "data") as! NSArray
                        for i in 0..<data.count{
                            self.categoryData.append(categoryList(category_id: (data[i] as AnyObject).value(forKey: "id")as! Int , Category_name: (data[i] as AnyObject).value(forKey: "name")as! String, category_Image: (data[i] as AnyObject).value(forKey: "image") as! String))
                            self.appendZeroArray.append(0)
                        }
                        print("My category data is :- \(self.categoryData)")
                        self.categoryTableView.reloadData()
                    }
                    
                }
                
            }
            else{
                print("failure")
            }
        }
    }
    
    
    
    //MARK:- Post Set Content API
    
    func postSetContent(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = ["category_id":chooseCategoryId,
                                          "user_id": userID as Any]
        print(parameter)
        
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.SetContent.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                self.performPushSeguefromController(identifier: "TabBarController")
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
    }
}
