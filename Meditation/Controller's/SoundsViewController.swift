//
//  SoundsViewController.swift
//  Meditation
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SoundNatureImageTableCell : UITableViewCell{
    @IBOutlet var natureCollectionView: UICollectionView!
}

class SoundNatureCollectionCell : UICollectionViewCell{
    
    @IBOutlet var natureImage: UIImageView!
    @IBOutlet var natureImageLock: UIImageView!
}

class SoundsViewController: UIViewController {

    @IBOutlet var upperview: UIView!
    
    @IBOutlet var SoundTableView: UITableView!
    var SoundType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         self.upperview.initGradientView(view: self.upperview, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        // Do any additional setup after loading the view.
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
       
        if indexPath.section == 0{
            SoundType = "Soundscapes"
        }
        else{
            SoundType = "Music"
        }
            let cell = SoundTableView.dequeueReusableCell(withIdentifier: "SoundNatureImageTableCell", for: indexPath) as! SoundNatureImageTableCell
            cell.natureCollectionView.delegate = self
            cell.natureCollectionView.dataSource = self
            cell.natureCollectionView.reloadData()
            return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    
}

extension SoundsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if SoundType == "Soundscapes"{
        return 4
        
    }
    else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if SoundType == "Soundscapes"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundNatureCollectionCell", for: indexPath) as! SoundNatureCollectionCell
             cell.natureImageLock.isHidden = true
             cell.natureImage.image = soundScapesArray[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundNatureCollectionCell", for: indexPath) as! SoundNatureCollectionCell
            cell.natureImageLock.isHidden = true
            cell.natureImage.image = MusicArray[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performPushSeguefromController(identifier: "MusicPlayerViewController")
    }
    
}
