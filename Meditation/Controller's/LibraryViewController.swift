//
//  LibraryViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyInterestTableCell : UITableViewCell{
    @IBOutlet var CategoryImage: UIImageView!
    @IBOutlet var categoryName: UILabel!
    
}
class MyStuffTableCell : UITableViewCell{
    
   
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initfunc()
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
        gotoSesssion!.SessionMainName = "0"
          self.navigationController?.pushViewController(gotoSesssion!, animated: true)
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
            return 3
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = HomeTableView.dequeueReusableCell(withIdentifier: "MyInterestTableCell", for: indexPath) as! MyInterestTableCell
            cell.CategoryImage.image = InterestCategoryArray[indexPath.row]
            cell.categoryName.text = InterestCategoryName[indexPath.row]
            return cell
        }
        else if indexPath.section == 1{
            let cell = HomeTableView.dequeueReusableCell(withIdentifier: "MyStuffTableCell", for: indexPath) as! MyStuffTableCell
            
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
            cell.CategoryImage.image = HomeCategoryArray[indexPath.row]
            cell.categoryName.text = HomeCategoryName[indexPath.row]
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NatureImageCollectionCell", for: indexPath) as! NatureImageCollectionCell
        cell.natureImage.image = natureImage[indexPath.row]
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
            cell.natureLockStatus.isHidden = true
        }
        else{
            cell.natureLockStatus.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
            self.performPushSeguefromController(identifier: "MusicPlayerViewController")
        }
        else{
            self.promoCodeView.isHidden = false
        }
    }
    
}
