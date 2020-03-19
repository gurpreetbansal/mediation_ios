//
//  MyAffirmationsViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AffirmationTableCell : UITableViewCell{
    
    @IBOutlet var favStatus: UIButton!
    @IBOutlet var BackImage: UIImageView!
    @IBOutlet var RecordTap: UIButton!
    @IBOutlet var recordText: UILabel!
}

class MyAffirmationsViewController: UIViewController {

    @IBOutlet var AffirmationTF: UITextField!
    @IBOutlet var affirmationNameImage: UIImageView!
    @IBOutlet var affirmationName: UILabel!
    
    var affirmationBased = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initfunc()
//        AffirmationTF.attributedPlaceholder = NSAttributedString(string: "Type your affirmation here...",
//                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Do any additional setup after loading the view.
    }
    
    func initfunc(){
        if affirmationBased == "0"{
            self.affirmationNameImage.image = #imageLiteral(resourceName: "WMainImage")
            self.affirmationName.text = "Weight Loss"
        }
        else if affirmationBased == "1"{
            self.affirmationNameImage.image = #imageLiteral(resourceName: "PNameImage")
            self.affirmationName.text = "Professional"
        }
        else if affirmationBased == "2"{
            self.affirmationNameImage.image = UIImage(named: "SMainImage")
            self.affirmationName.text = "Stress"
        }
        else if affirmationBased == "3"{
            self.affirmationNameImage.image = UIImage(named: "RMainImage")
            self.affirmationName.text = "Relationship"
        }
        else if affirmationBased == "4"{
            self.affirmationNameImage.initGradientView(view: affirmationNameImage, colour1: leftAthletic_Colour, colour2: RightAthletic_Colour)
            self.affirmationName.text = "Athletic"
        }
        else if affirmationBased == "5"{
            self.affirmationNameImage.image = UIImage(named: "HMainImage")
            self.affirmationName.text = "Health"
        }
        else if affirmationBased == "6"{
            self.affirmationNameImage.image = #imageLiteral(resourceName: "SMainImage")
            self.affirmationName.text = "Financial"
        }
    }
    
    @IBAction func BackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyAffirmationsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffirmationTableCell", for: indexPath) as! AffirmationTableCell
        cell.recordText.text = affirmationArray[indexPath.row]
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5{
            cell.favStatus.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        }
        else{
            cell.favStatus.setImage(#imageLiteral(resourceName: "unfavGrey"), for: .normal)
        }
        if indexPath.row == 5{
           cell.RecordTap.setImage(#imageLiteral(resourceName: "PinkTap"), for: .normal)
        }
        else{
           cell.RecordTap.setImage(#imageLiteral(resourceName: "GreenTap"), for: .normal)
        }
        if affirmationBased == "0"{
            cell.BackImage.image = #imageLiteral(resourceName: "WMainImage")
          }
        else if affirmationBased == "1"{
            cell.BackImage.image = #imageLiteral(resourceName: "PNameImage")
           
        }
        else if affirmationBased == "2"{
            cell.BackImage.image = UIImage(named: "SMainImage")
           
        }
        else if affirmationBased == "3"{
            cell.BackImage.image = UIImage(named: "RMainImage")
           
        }
        else if affirmationBased == "4"{
            cell.BackImage.image = #imageLiteral(resourceName: "RRecording")
            
        }
        else if affirmationBased == "5"{
            cell.BackImage.image = UIImage(named: "HMainImage")
         }
        else if affirmationBased == "6"{
           cell.BackImage.image = #imageLiteral(resourceName: "SMainImage")
           
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
