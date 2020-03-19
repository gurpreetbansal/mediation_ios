//
//  MusicPlayerViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {

    @IBOutlet var upperView: UIView!
    @IBOutlet var soundView: UIView!
  
    @IBOutlet var VolumeSlider: UIImageView!
    @IBOutlet var favBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.soundView.isHidden = true
        self.VolumeSlider.isHidden = true
       self.upperView.initGradientView(view: self.upperView, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func MusicTap(_ sender: UIButton) {
      if soundView.isHidden == true{
           self.soundView.isHidden = false
        }
      else{
        self.soundView.isHidden = true
        }
         }
    
    @IBAction func musicTap(_ sender: Any) {
        if VolumeSlider.isHidden == false{
            VolumeSlider.isHidden = true
        }
        else{
            VolumeSlider.isHidden = false
        }
    }
    
 @IBAction func BackTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func favButtonTap(_ sender: UIButton) {
        if self.favBtn.imageView?.image == #imageLiteral(resourceName: "unfav"){
            self.favBtn.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        }
        else{
           self.favBtn.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
        }
        
    }
    
    
    
}
