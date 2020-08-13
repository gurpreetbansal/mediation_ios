//
//  PrivacyPolicyViewController.swift
//  Meditation
//
//  Created by Apple on 24/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    @IBOutlet var privacylbl: UIButton!
    @IBOutlet var webView: WKWebView!
    
    var privacyStatus = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if privacyStatus == "Privacy"{
            privacylbl.setTitle("Privacy Policy", for: .normal)
            let url = URL(string: "https://selfpause.com/privacy-policy/")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }else{
            privacylbl.setTitle("Terms & Conditions", for: .normal)
            let url = URL(string: "https://selfpause.com/terms-conditions/")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func BackBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
