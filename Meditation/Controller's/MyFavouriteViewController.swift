//
//  MyFavouriteViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class MyFavouriteCategoryCell : UITableViewCell{
    @IBOutlet var CategoryImage: UIImageView!
    @IBOutlet var CategoryName: UILabel!
    @IBOutlet weak var MyFavouriteCategoryInsideTableView: UITableView!
    @IBOutlet weak var myFavouriteInsideTableViewHeight: NSLayoutConstraint!
}

class MyFavouriteCategoryInsideCell : UITableViewCell{
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
}


class MyFavouriteViewController: UIViewController {
    
    
    @IBOutlet var favoriteTable: UITableView!
    
    var innerfavouriteCountArr = [Int]()
    var innerCatArr = [Int]()
    var myFavouriteData = NSArray()
    var cell = MyFavouriteCategoryCell()
    var isCellSelected : Bool = false
    var selectedCell : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        GetFavouriteData()
        self.favoriteTable.estimatedRowHeight = 60.0
        self.favoriteTable.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PlayAllBtn(_ sender: Any) {
        self.performPushSeguefromController(identifier: "MusicPlayerViewController")
    }
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyFavouriteViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favoriteTable {
            return myFavouriteData.count
        }else{
            var count = innerfavouriteCountArr[tableView.tag]
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == favoriteTable{
            cell = favoriteTable.dequeueReusableCell(withIdentifier: "MyFavouriteCategoryCell", for: indexPath) as! MyFavouriteCategoryCell
            //            cell.CategoryImage.image = HomeCategoryArray[indexPath.row]
            //            cell.CategoryName.text = HomeCategoryName[indexPath.row]
            let indexCategory = myFavouriteData[indexPath.row]
            if let imageString = (indexCategory as AnyObject).value(forKey: "image") as? String {
                if URL(string: (imageString) ) != nil {
                    cell.CategoryImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                }
            }
            if let name = (indexCategory as AnyObject).value(forKey: "name") as? String {
                cell.CategoryName.text = name
            }
            if let count = (indexCategory as AnyObject).value(forKey: "count") as? Int {
                if count != 0 {
                    cell.MyFavouriteCategoryInsideTableView.dataSource = self
                    cell.MyFavouriteCategoryInsideTableView.delegate = self
                    cell.MyFavouriteCategoryInsideTableView.tag = indexPath.row
                    cell.MyFavouriteCategoryInsideTableView.reloadData()
                    cell.MyFavouriteCategoryInsideTableView.tableFooterView = UIView()
                    if innerCatArr[indexPath.row] == 1{
                        cell.myFavouriteInsideTableViewHeight.constant = cell.MyFavouriteCategoryInsideTableView.contentSize.height+10
                        isCellSelected = false
                    }else {
                        cell.myFavouriteInsideTableViewHeight.constant = 0
                    }
                }
            }
            return cell
        }else {
            if let insideCell = cell.MyFavouriteCategoryInsideTableView.dequeueReusableCell(withIdentifier: "MyFavouriteCategoryInsideCell", for: indexPath) as? MyFavouriteCategoryInsideCell{
                let num = cell.MyFavouriteCategoryInsideTableView.tag
                let indexDictionary = (myFavouriteData[num] as AnyObject)
                let insideFavData = indexDictionary.value(forKey: "subCategory") as? NSArray
                if insideFavData != [] {
                if let status = (insideFavData![indexPath.row] as AnyObject).value(forKey: "favrite_status") as?Int {
                if status == 0 {
                    insideCell.favImageView.image = UIImage(named: "unfavGrey")
                }else {
                    insideCell.favImageView.image = UIImage(named: "Myfav")
                }
                    }
                }
                
                return insideCell
            }
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == favoriteTable {
            return UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == favoriteTable{
            selectedCell = indexPath.row
            if innerCatArr[indexPath.row] == 0{
                innerCatArr[indexPath.row] = 1
                favoriteTable.reloadData()
            }
            else{
                innerCatArr[indexPath.row] = 0
                favoriteTable.reloadData()
            }
        }else {
            self.performPushSeguefromController(identifier: "MusicPlayerViewController")
        }
    }
}

extension MyFavouriteViewController{
    func GetFavouriteData(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = [
            //"user_id": 287,
           "user_id": userID as Any,
        ]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.MyFavouriteSongs.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSArray {
                    self.myFavouriteData = data
                    self.innerCatArr = self.makeZeroArr(numCount:data as! [Any])
               if data != [] {
               for i in 0...(data.count-1){
                   if let id = (data[i] as AnyObject).value(forKey: "count") as? Int {
                    self.innerfavouriteCountArr.append(id)
                }
                }
                }
                }
                print(self.innerfavouriteCountArr)
                self.favoriteTable.dataSource = self
                self.favoriteTable.delegate = self
                self.favoriteTable.reloadData()
            }
                
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
        
    }
    //MARK:- Make Zero Arr
    func makeZeroArr(numCount:[Any]) -> [Int] {
        var uncheckedAr = [Int]()
        for zero in numCount {
            uncheckedAr.append(0)
        }
        print(uncheckedAr)
        return uncheckedAr
    }
}
