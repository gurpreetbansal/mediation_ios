//
//  TabBarController.swift
//  KitoPlastic
//
//  Created by apple on 06/05/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit



@available(iOS 11.0, *)
class TabBarController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func addTabBarView(tap: Int) {
        selectedIndex = tap
        buttons[selectedIndex].isSelected = true
        didTapOnBar(buttons[selectedIndex])
    }
    
  
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    var LibraryViewController = UIViewController()
    var SoundsViewController = UIViewController()
    var RecordViewController = UIViewController()
    var AccountViewController = UIViewController()
    
    var viewControllers = [UIViewController]()
    var selectedIndex: Int = 0
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        LibraryViewController = storyboard.instantiateViewController(withIdentifier: "LibraryViewController")
        SoundsViewController = storyboard.instantiateViewController(withIdentifier: "SoundsViewController")
        RecordViewController = storyboard.instantiateViewController(withIdentifier: "RecordViewController")
        AccountViewController = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
        
        viewControllers = [LibraryViewController,SoundsViewController,RecordViewController,AccountViewController]
        //Set the Initial Tab when the App Starts.
        buttons[selectedIndex].isSelected = true
        didTapOnBar(buttons[selectedIndex])
        buttons[selectedIndex].setImage(#imageLiteral(resourceName: "selectedLibrary"), for: .normal)
    }
    
    
  
    @IBAction func didTapOnBar(_ sender: UIButton) {
        //Get Access to the Previous and Current Tab Button.
        if sender.tag == 0{
             buttons[0].setImage(#imageLiteral(resourceName: "selectedLibrary"), for: .normal)
            buttons[1].setImage(#imageLiteral(resourceName: "Sounds"), for: .normal)
            buttons[2].setImage(#imageLiteral(resourceName: "Record"), for: .normal)
            buttons[3].setImage(#imageLiteral(resourceName: "Account"), for: .normal)
           
        } else if sender.tag == 1{
            buttons[0].setImage(#imageLiteral(resourceName: "Library"), for: .normal)
            buttons[1].setImage(#imageLiteral(resourceName: "selectedSounds"), for: .normal)
            buttons[2].setImage(#imageLiteral(resourceName: "Record"), for: .normal)
            buttons[3].setImage(#imageLiteral(resourceName: "Account"), for: .normal)
        } else if sender.tag == 2{
            buttons[0].setImage(#imageLiteral(resourceName: "Library"), for: .normal)
            buttons[1].setImage(#imageLiteral(resourceName: "Sounds"), for: .normal)
            buttons[2].setImage(#imageLiteral(resourceName: "selectedRecord"), for: .normal)
            buttons[3].setImage(#imageLiteral(resourceName: "Account"), for: .normal)
        } else if sender.tag == 3{
            buttons[0].setImage(#imageLiteral(resourceName: "Library"), for: .normal)
            buttons[1].setImage(#imageLiteral(resourceName: "Sounds"), for: .normal)
             buttons[2].setImage(#imageLiteral(resourceName: "Record"), for: .normal)
            buttons[3].setImage(#imageLiteral(resourceName: "SelectedAccount"), for: .normal)
        
        }
        
            selectedIndex = sender.tag
        let previousIndex = selectedIndex
        
        //Remove the Previous ViewController and Set Button State.
        buttons[previousIndex].isSelected = false
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        //Add the New ViewController and Set Button State.
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
  }

