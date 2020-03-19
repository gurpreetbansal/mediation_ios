//
//  MyFavouriteViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyFavouriteCategoryCell : UITableViewCell{
    @IBOutlet var CategoryImage: UIImageView!
    @IBOutlet var CategoryName: UILabel!
}




class MyFavouriteViewController: UIViewController {
    
    
    @IBOutlet var favoriteTable: UITableView!
    
    var isCellSelected : Bool = false
    var selectedCell : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyFavouriteViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 7
       
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = favoriteTable.dequeueReusableCell(withIdentifier: "MyFavouriteCategoryCell", for: indexPath) as! MyFavouriteCategoryCell
            cell.CategoryImage.image = HomeCategoryArray[indexPath.row]
            cell.CategoryName.text = HomeCategoryName[indexPath.row]
        
            return cell
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCell == indexPath.row{
            if isCellSelected == true{
                return 173
            }
            else{
                return 90
            }
        }
        else{
            return 90
        }
      
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        if isCellSelected == true{
            isCellSelected = false
            favoriteTable.reloadData()
        }
        else{
            isCellSelected = true
            favoriteTable.reloadData()
        }
    }
    
    
    
}
