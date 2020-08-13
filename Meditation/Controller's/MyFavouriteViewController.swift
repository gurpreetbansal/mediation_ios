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
    var innerCatArr = NSArray()
    var myFavouriteData = NSArray()
    var cell = MyFavouriteCategoryCell()
    var isCellSelected : Bool = false
    var selectedCell : Int = -1
    private var dateCellExpanded: Bool = false
    var selectedRowIndex: Int = -1
    var playAllSongsArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetFavouriteData()
        self.favoriteTable.estimatedRowHeight = 60.0
        self.favoriteTable.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PlayAllBtn(_ sender: Any) {
        if self.playAllSongsArr.count != 0{
            let Goto = self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            Goto.playAllSongs = self.playAllSongsArr
            Goto.isComesFrom = "PlayAll"
            self.navigationController?.pushViewController(Goto, animated: true)
        }
    }
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyFavouriteViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return myFavouriteData.count
        }else{
            return self.innerCatArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
            cell = favoriteTable.dequeueReusableCell(withIdentifier: "MyFavouriteCategoryCell", for: indexPath) as! MyFavouriteCategoryCell
            let indexCategory = myFavouriteData[indexPath.row]
            if let imageString = (indexCategory as AnyObject).value(forKey: "image") as? String {
                if URL(string: (imageString) ) != nil {
                    cell.CategoryImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
                }
            }
            if let name = (indexCategory as AnyObject).value(forKey: "name") as? String {
                cell.CategoryName.text = name
            }
             cell.setCategoryTableViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        }else {
            if let insideCell = cell.MyFavouriteCategoryInsideTableView.dequeueReusableCell(withIdentifier: "MyFavouriteCategoryInsideCell", for: indexPath) as? MyFavouriteCategoryInsideCell{
                if innerCatArr != [] {
                    insideCell.categoryName.text = ((innerCatArr[indexPath.row] as AnyObject).value(forKey: "affirmation_title") as! String)
                    
                    if let status = (innerCatArr[indexPath.row] as AnyObject).value(forKey: "favourite_status") as? NSNumber {
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
        if tableView.tag == 100 {
            if indexPath.row == selectedRowIndex {
                return CGFloat(self.innerCatArr.count * 90 + 50)
            }else{
                return 80
            }
        }else{
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100{
            selectedRowIndex = indexPath.row
            self.innerCatArr = (self.myFavouriteData[indexPath.row] as AnyObject).value(forKey: "session") as! NSArray
            favoriteTable.beginUpdates()
            favoriteTable.endUpdates()
            favoriteTable.reloadRows(at: [indexPath], with: .automatic)
            
        }else {
             let indexAffirmation = self.innerCatArr[indexPath.row]
            let GotoAffirmation = self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            
            GotoAffirmation.titleName = (indexAffirmation as AnyObject).value(forKey: "affirmation_title") as! String
             GotoAffirmation.subTitle = (indexAffirmation as AnyObject).value(forKey: "affirmation_subtitle") as! String
             GotoAffirmation.sessonId = "\((indexAffirmation as AnyObject).value(forKey: "id") as! NSNumber)"
             SingletonClass.sharedInstance.isFav = "\((indexAffirmation as AnyObject).value(forKey: "favourite_status") as! NSNumber)"
            GotoAffirmation.isComesFrom = "session"
             self.navigationController?.pushViewController(GotoAffirmation, animated: true)
        }
  }
    
}

extension MyFavouriteViewController{
    func GetFavouriteData(){
        // self.showProgress()
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
            if dic.value(forKey: "success") as! Bool == true{
                if let data = dic.value(forKeyPath: "data.categories") as? NSArray {
                    self.myFavouriteData = data
                    self.playAllSongsArr = dic.value(forKeyPath: "data.playall") as! NSArray
                self.favoriteTable.dataSource = self
                self.favoriteTable.delegate = self
                self.favoriteTable.reloadData()
            }
                
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
        
    }
    
}
}
extension MyFavouriteCategoryCell{
    func setCategoryTableViewDataSourceDelegate<D:UITableViewDelegate & UITableViewDataSource>(_ dataSourceDelegate:D, forRow row: Int){
        MyFavouriteCategoryInsideTableView.delegate = dataSourceDelegate
        MyFavouriteCategoryInsideTableView.dataSource = dataSourceDelegate
        MyFavouriteCategoryInsideTableView.reloadData()
    }
}
