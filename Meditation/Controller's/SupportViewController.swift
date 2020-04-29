//
//  SupportViewController.swift
//  Meditation
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   

}
