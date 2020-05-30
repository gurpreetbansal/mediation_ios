//
//  MyAffirmationsViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class AffirmationTableCell : UITableViewCell{
    
    @IBOutlet weak var favStatusImageView: UIImageView!
    @IBOutlet var favStatus: UIButton!
    @IBOutlet var BackImage: UIImageView!
    @IBOutlet var RecordTap: UIButton!
    @IBOutlet var recordText: UILabel!
}

class MyAffirmationsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var AffermationTableView: UITableView!
    @IBOutlet var AffirmationTF: UITextField!
    @IBOutlet var affirmationNameImage: UIImageView!
    @IBOutlet var affirmationName: UILabel!
    
    var favKey = Int()
    var meterTimer = Timer()
    var cell = AffirmationTableCell()
    var musicUrl = NSURL()
    var isAudioPresent = false
    var totalAudioDuration = String()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var affirmationBased = ""
    var catg_Id = Int()
    var musicTitleArrayForRecording = [String]()
    var musicTitleForRecording = String()
    var musicIdArryForRecording = [Int]()
    var musicIdForRecording = Int()
    var myAffirmationArray = NSArray()
     fileprivate var sourceIndexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        GetRecordingsList()
        initfunc()
        setupView()
        // tapRecognizer, placed in viewDidLoad
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MyAffirmationsViewController.longPressGestureRecognized))
        AffermationTableView.addGestureRecognizer(longPress)
        
    }
    //Called, when long press occurred
    @objc func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let location = longPress.location(in: self.AffermationTableView)
        guard let indexPath = self.AffermationTableView.indexPathForRow(at: location) else {
            self.cleanup()
            return
        }
        switch state {
        case .began:
            sourceIndexPath = indexPath
            guard let cell = self.AffermationTableView.cellForRow(at: indexPath) else { return }
            if audioRecorder == nil {
                startRecording()
                let audioAsset = AVURLAsset.init(url: getFileURL(), options: nil)
                let audioDuration = audioAsset.duration
                let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                totalAudioDuration = stringFromTimeInterval(interval: audioDurationSeconds) as String
                isAudioPresent = true
                musicUrl = getFileURL() as NSURL
                
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateProgressBar(timer:)), userInfo:nil, repeats:true)
            }
            break
        case .ended:
            if audioRecorder != nil {
                finishRecording(success: true)
                let indexCategory = myAffirmationArray[indexPath.row]
                PostMySongList(Title: (indexCategory as AnyObject).value(forKey: "songs_title") as! String,cat_id: "\((indexCategory as AnyObject).value(forKey: "cat_id") as! NSNumber)",songID: "\((indexCategory as AnyObject).value(forKey: "id") as! NSNumber)")
            }
            break
        default: break
    }
    }
    
    private func cleanup() {
        self.sourceIndexPath = nil
        self.AffermationTableView.reloadData()
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
    @IBAction func SendrecordedSong(_ sender: UIButton) {
        if AffirmationTF.text != "" {
            isAudioPresent = false
            postSongTitle()
            AffirmationTF.text = ""
        }
    }
    
    @IBAction func BackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func RecordMusic(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if audioRecorder == nil {
                startRecording()
                let audioAsset = AVURLAsset.init(url: getFileURL(), options: nil)
                let audioDuration = audioAsset.duration
                let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                totalAudioDuration = stringFromTimeInterval(interval: audioDurationSeconds) as String
                isAudioPresent = true
                musicUrl = getFileURL() as NSURL
                var superview = sender.view
                while let view = superview, !(view is AffirmationTableCell){
                    superview = view.superview
                }
                guard let selectedCell = superview as? AffirmationTableCell else {
                    print("button is not contained in a table view cell")
                    return
                }
                guard let indexPath = AffermationTableView.indexPath(for: selectedCell) else {
                    print("failed to get index path for cell containing button")
                    return
                }
                print(indexPath.row)
                musicTitleForRecording = musicTitleArrayForRecording[indexPath.row]
                musicIdForRecording = musicIdArryForRecording[indexPath.row]
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateProgressBar(timer:)), userInfo:nil, repeats:true)
            }
            
        }else if sender.state == .changed{
            
            
        }
        else if sender.state == .ended  {
            if audioRecorder != nil {
                finishRecording(success: true)
                
                //PostMySongList()
            }
        }
    }
    @objc func updateProgressBar(timer: Timer){
        let totalTimeString:String?
        //if audioRecorder!.isRecording && Int(audioRecorder.currentTime) <= 59
        if audioRecorder!.isRecording && Int(audioRecorder.currentTime) <= 59
        {
            audioRecorder!.updateMeters()
        }else{
            finishRecording(success: true)
           // PostMySongList()
        }
    }
}


extension MyAffirmationsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAffirmationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "AffirmationTableCell", for: indexPath) as! AffirmationTableCell
        let indexCategory = myAffirmationArray[indexPath.row]
        if let txt = (indexCategory as AnyObject).value(forKey: "songs_title") as? String {
            cell.recordText.text = txt
        }
        if let imageString = (indexCategory as AnyObject).value(forKey: "image") as? String {
            if URL(string: (imageString) ) != nil {
                cell.BackImage.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
            }
        }
        if let title = (indexCategory as AnyObject).value(forKey: "songs_title") as? String {
            musicTitleArrayForRecording.append(title)
        }
        if let id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
            musicIdArryForRecording.append(id)
        }
        if let favouriteStatus = (indexCategory as AnyObject).value(forKey: "favrite_status") as? Int {
            if favouriteStatus == 0 {
                cell.favStatusImageView.image = UIImage(named: "unfavGrey")
            }else {
                cell.favStatusImageView.image = UIImage(named: "Myfav")
            }
        }
        cell.favStatus.tag = indexPath.row
        cell.favStatus.addTarget(self, action: #selector(AddToFavourite(_:)), for: .touchUpInside)
        
        if let status = (indexCategory as AnyObject).value(forKey: "upload_status") as? Int {
            if status == 1 {
                print("music already present")
            }else {
                //cell.RecordTap.addGestureRecognizer(self.longPressGesture())
            }
        }
        
        //        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5{
        //            cell.favStatus.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        //        }
        //        else{
        //            cell.favStatus.setImage(#imageLiteral(resourceName: "unfavGrey"), for: .normal)
        //        }
        //        if indexPath.row == 5{
        //           cell.RecordTap.setImage(#imageLiteral(resourceName: "PinkTap"), for: .normal)
        //        }
        //        else{
        //           cell.RecordTap.setImage(#imageLiteral(resourceName: "GreenTap"), for: .normal)
        //        }
        //        if affirmationBased == "0"{
        //            cell.BackImage.image = #imageLiteral(resourceName: "WMainImage")
        //          }
        //        else if affirmationBased == "1"{
        //            cell.BackImage.image = #imageLiteral(resourceName: "PNameImage")
        //
        //        }
        //        else if affirmationBased == "2"{
        //            cell.BackImage.image = UIImage(named: "SMainImage")
        //
        //        }
        //        else if affirmationBased == "3"{
        //            cell.BackImage.image = UIImage(named: "RMainImage")
        //
        //        }
        //        else if affirmationBased == "4"{
        //            cell.BackImage.image = #imageLiteral(resourceName: "RRecording")
        //
        //        }
        //        else if affirmationBased == "5"{
        //            cell.BackImage.image = UIImage(named: "HMainImage")
        //         }
        //        else if affirmationBased == "6"{
        //           cell.BackImage.image = #imageLiteral(resourceName: "SMainImage")
        //
        //        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc func AddToFavourite(_ sender:UIButton){
        let indexCategory = myAffirmationArray[sender.tag]
                    
        if let status = (indexCategory as AnyObject).value(forKey: "upload_status") as? Int {
            if status == 1 {
                musicTitleForRecording = musicTitleArrayForRecording[sender.tag]
                musicIdForRecording = musicIdArryForRecording[sender.tag]
            }else {
                if let title = (indexCategory as AnyObject).value(forKey: "songs_title") as? String {
                    musicTitleForRecording = title
                }
                if let id = (indexCategory as AnyObject).value(forKey: "id") as? Int {
                    musicIdForRecording = id
                }
            }
        }
        
        if let favouriteStatus = (indexCategory as AnyObject).value(forKey: "favrite_status") as? Int {
        if favouriteStatus == 0 {
            favKey = 1
            AddToFavouriteApi(favStatus: "\(favKey)", Title: (indexCategory as AnyObject).value(forKey: "songs_title") as! String,cat_id: "\((indexCategory as AnyObject).value(forKey: "cat_id") as! NSNumber)",songID: "\((indexCategory as AnyObject).value(forKey: "id") as! NSNumber)")
        }else {
            favKey = 0
            AddToFavouriteApi(favStatus: "\(favKey)", Title: (indexCategory as AnyObject).value(forKey: "songs_title") as! String,cat_id: "\((indexCategory as AnyObject).value(forKey: "cat_id") as! NSNumber)",songID: "\((indexCategory as AnyObject).value(forKey: "id") as! NSNumber)")
            
            }
        }
        
        
    }
}
extension MyAffirmationsViewController{
    
    //MARK:- GetRecordingsList API
    func GetRecordingsList(){
        self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = ["user_id": userID as Any,
                                          "cat_id": "\(catg_Id)"]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.MySongsList.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as!Bool == true{
                if let data = dic.value(forKey: "data") as? NSArray {
                    self.myAffirmationArray = data.reversed() as NSArray
                }
                self.AffermationTableView.dataSource = self
                self.AffermationTableView.delegate = self
                self.AffermationTableView.reloadData()
            }
            else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
        
    }
    //MARK:- AddToFavourite
    func AddToFavouriteApi(favStatus:String,Title:String,cat_id:String,songID:String){
        self.showProgress()
                   let userID = UserDefaults.standard.value(forKey: "UserID")
        let parameter : [String : Any] = ["user_id": userID! as Any,
                                          "songs_title": Title,
                                          "cat_id": cat_id,
                                          "songs_id":songID,
                                          "favrite" :favStatus]
                   print(parameter)
                   networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.PostMySongList.caseValue, parameter: parameter) {(response) in
                       print(response)
                       self.hideProgress()
                       let dic = response as! NSDictionary
                       if dic.value(forKey: "success") as? Bool == true {
                           self.GetRecordingsList()
                       }
                       else {
                           self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                       }
                   }
    }
    
    func postSongTitle(){
            self.showProgress()
            let userID = UserDefaults.standard.value(forKey: "UserID")
            let parameter : [String : Any] = ["user_id": userID! as Any,
                                              "songs_title": "\(AffirmationTF.text!)",
                "songs":"",
                "songs_images":"",
                "songs_description":"",
                "cat_id":"\(catg_Id)"
            ]
            print(parameter)
            networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.PostMySongList.caseValue, parameter: parameter) { (response) in
                print(response)
                self.hideProgress()
                let dic = response as! NSDictionary
                if dic.value(forKey: "success") as!Bool == true{
                    if let data = dic.value(forKey: "data") as? NSArray {
                        self.myAffirmationArray = data
                    }
                    self.GetRecordingsList()
                }
                else{
                    self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                }
            }
            
        }
    
    //MARK:- PostSong Api
    func PostMySongList(Title:String,cat_id:String,songID:String){
        if isAudioPresent {
            self.showProgress()
            let userID = UserDefaults.standard.value(forKey: "UserID") as! String
            let parameter : [String : String] = ["user_id": userID,
                                              "songs_title": Title,
                                              "cat_id":"\(cat_id)",
                                              "songs_id":"",
                                              "songs_images" : "",
                                              "songs_description" : ""
            ]
            print(parameter)
            uploadDocuments(urlString: "https://meditation.customer-devreview.com/api/collections/postMySongs", params: parameter, documentUrl: musicUrl as URL, success: { (response) in
                print(response)
            }) { (Error) in
                print(Error)
            }
            
//            guard let audioFile: Data = try? Data (contentsOf: musicUrl as URL) else {return}
//            networkServices.shared.uploadAudio(methodName: methodName.UserCase.PostMySongList.caseValue, audioData: audioFile, name: "songs", appendParam: parameter ) { (response) in
//                print(response)
//                self.hideProgress()
//                let dic = response as! NSDictionary
//                if dic.value(forKey: "success") as? Bool == true {
//                    if let data = dic.value(forKey: "data") as? NSArray {
//                        self.myAffirmationArray = data
//                    }
//                    self.GetRecordingsList()
//                }
//                else {
//                    self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
//                }
//            }
        }else{
            self.showProgress()
            let userID = UserDefaults.standard.value(forKey: "UserID")
            let parameter : [String : Any] = ["user_id": userID! as Any,
                                              "songs_title": "\(AffirmationTF.text!)",
                "songs":"",
                "songs_images":"",
                "songs_description":"",
                "cat_id":"\(catg_Id)"
            ]
            print(parameter)
            networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.PostMySongList.caseValue, parameter: parameter) { (response) in
                print(response)
                self.hideProgress()
                let dic = response as! NSDictionary
                if dic.value(forKey: "success") as!Bool == true{
                    if let data = dic.value(forKey: "data") as? NSArray {
                        self.myAffirmationArray = data
                    }
                    self.GetRecordingsList()
                }
                else{
                    self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
                }
            }
            
        }
    }
}

extension MyAffirmationsViewController {
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    func startRecording() {
        let audioFilename = getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("MusicList.m4a")
        return path as URL
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let min = Int(interval / 60)
        let sec = Int(interval.truncatingRemainder(dividingBy: 60))
        
        
        return String(format: "%02d:%02d", min, sec) as NSString
        
    }
}
