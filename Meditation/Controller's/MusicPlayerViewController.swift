//
//  MusicPlayerViewController.swift
//  Meditation
//
//  Created by Apple on 22/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftySound
import HGCircularSlider
import SDWebImage

class MusicPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var activityIndicatro: UIActivityIndicatorView!
    @IBOutlet weak var natureColectionView: UICollectionView!
    var myQueuePlayer: AVQueuePlayer?
    var avItems: [AVPlayerItem] = []
    var isPlaying = false
    var backgroundMusicPlaying = false
    private var playerViewControllerKVOContext = 0
    private var dogSound: Sound?
    @IBOutlet weak var AffirmationTile: UILabel!
    @IBOutlet weak var AffirmationName: UILabel!
    var audioUrl = NSURL()
    var isPause = false
    var audioPlayer = AVPlayer()
    var backgroundAudioPlayer = AVPlayer()
    var duration = String()
    var getVoiceArray = NSArray()
    var titleName = ""
    var subTitle = ""
    var sessonId = ""
    var uploadRecordingUrl = ""
    var isComesFrom = ""
    var soundImage = ""
    var playAllSongs = NSArray()
    var natureArray = NSArray()
    var cell = natureCell()
    // date formatter user for timer label
    let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    
    
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var dropdownBtn: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var playPausebtn: UIButton!
    @IBOutlet var upperView: UIView!
    @IBOutlet var soundView: UIView!
    
    @IBOutlet weak var audioTimeLabel: UILabel!
    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet var favBtn: UIButton!
    @IBOutlet weak var VolumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        self.AffirmationName.text = subTitle
        self.AffirmationTile.text = titleName
        SetCircularProgressBar()
        SetAudioPlayerForBackgroundAudio()
        SetUpVC()
        self.favBtn.isHidden = true
        print("music\(audioUrl)")
        self.activityIndicatro.isHidden = true
        self.activityIndicatro.layer.cornerRadius = 10
        self.activityIndicatro.clipsToBounds = true
        GetMusicData()
        
        if playAllSongs.count != 0{
            let img = UserDefaults.standard.value(forKey: "UserProfileImage") as! String
            Name.text = (UserDefaults.standard.value(forKey: "UserProfileName") as! String)
            self.profileImage.sd_setImage(with:URL(string: img), placeholderImage: #imageLiteral(resourceName: "name"))
            self.Name.isHidden = false
            self.dropBtn.isHidden = true
            self.dropdownBtn.isHidden = true
            addSongs_inQueue()
            
        }
        
        
    }
    func addSongs_inQueue(){
        for i in 0..<playAllSongs.count {
            let url = URL(string: playAllSongs[i] as! String)
            avItems.append(AVPlayerItem(url: url!))
        }
        print(avItems)
        playSongs_inQueue()
    }
    
    func playSongs_inQueue(){
        // if first time
        if myQueuePlayer == nil {
            // instantiate the AVQueuePlayer with all avItems
            myQueuePlayer = AVQueuePlayer(items: avItems)
        } else {
            // stop the player and remove all avItems
            myQueuePlayer?.removeAllItems()
            // add all avItems back to the player
            avItems.forEach {
                myQueuePlayer?.insert($0, after: nil)
            }
        }
        // seek to .zero (in case we added items back in)
        //myQueuePlayer?.seek(to: .zero)
        // start playing
        myQueuePlayer?.play()
        
//
//        let playerItem: AVPlayerItem = (myQueuePlayer?.currentItem)!
//        audioPlayer.replaceCurrentItem(with: playerItem)
        //myQueuePlayer!.actionAtItemEnd = .pause
        
        let durationInSeconds = CMTimeGetSeconds((myQueuePlayer?.currentItem!.asset.duration)!)
        circularSlider.maximumValue = CGFloat(durationInSeconds)
        let interval = CMTimeMake(value: 1, timescale: 4)
        myQueuePlayer!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
            [weak self] time in
            let seconds = CMTimeGetSeconds(time)
            self?.updatePlayerUI(withCurrentTime: CGFloat(seconds))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isPlaying = true
        playPauseImageView.image = UIImage(named: "pause-1")
        self.audioPlayer.automaticallyWaitsToMinimizeStalling = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        audioPlayer.pause()
        backgroundMusicPlaying = false
        backgroundAudioPlayer.pause()
        myQueuePlayer?.pause()
        myQueuePlayer?.removeAllItems()
        stopBackPlayer()
    }
    
    @IBAction func dropdown(_ sender: Any) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    
             let closure = { (action: UIAlertAction!) -> Void in
                 let index = controller.actions.firstIndex(of: action)
                 if index != nil {
                     NSLog("Index: \(index!)")
                    self.audioPlayer.pause()
                    self.stopBackPlayer()
                    self.audioPlayer = AVPlayer()
                    //self.SetCircularProgressBar()
                    self.circularSlider.endPointValue = 0
                    self.playPauseImageView.image = UIImage(named: "pause-1")
                    var components = DateComponents()
                    components.second = Int(self.circularSlider.endPointValue)
                    self.audioTimeLabel.text = self.dateComponentsFormatter.string(from: components)
                    self.soundView.isHidden = true
                    self.VolumeSlider.isHidden = true
                    print(self.getVoiceArray[index!])
                    self.profileImage.sd_setImage(with:URL(string:  (self.getVoiceArray[index!] as AnyObject).value(forKey: "image") as! String), placeholderImage: #imageLiteral(resourceName: "name"))
                    
                    self.Name.text = ((self.getVoiceArray[index!] as AnyObject).value(forKey: "name") as! String)
                    
                    self.setupAudioPlayer(song: (self.getVoiceArray[index!] as AnyObject).value(forKey: "songs") as! String)
                    
                    self.audioPlayer.play()
                 }
             }
             for i in 0 ..< self.getVoiceArray.count { controller.addAction(UIAlertAction(title: ((self.getVoiceArray[i] as AnyObject).value(forKey: "name") as! String), style: .default, handler: closure))
                 // selected_Year = self.yearsArr[i] as? String
                 
             }
             controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
             present(controller, animated: true, completion: nil)
    }
    func GetMusicData(){
        //self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String : Any] = ["user_id": userID, "session_id":sessonId]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.musicPlayer.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
           
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as! Bool == true{
                self.getVoiceArray = dic.value(forKeyPath: "data.getVoice") as! NSArray
                self.natureArray = dic.value(forKeyPath: "data.nature") as! NSArray
                if self.playAllSongs.count == 0{
                    if self.isComesFrom == "MyAffirmation"{
                        self.setupAudioPlayer(song: self.uploadRecordingUrl)
                        self.audioPlayer.play()
                        let img = UserDefaults.standard.value(forKey: "UserProfileImage") as! String
                        self.profileImage.sd_setImage(with:URL(string: img), placeholderImage: #imageLiteral(resourceName: "name"))
                        self.Name.isHidden = true
                        self.dropBtn.isHidden = true
                        self.dropdownBtn.isHidden = true
                        self.favBtn.isHidden = true
                        
                    } else if self.isComesFrom == "sounds"{
                        self.setupAudioPlayer(song: self.uploadRecordingUrl)
                        self.audioPlayer.play()
                        // let img = UserDefaults.standard.value(forKey: "UserProfileImage") as! String
                        self.profileImage.sd_setImage(with:URL(string: self.soundImage), placeholderImage: #imageLiteral(resourceName: "name"))
                        self.Name.isHidden = true
                        self.dropBtn.isHidden = true
                        self.dropdownBtn.isHidden = true
                        self.favBtn.isHidden = true
                    }
                    else{
                        if SingletonClass.sharedInstance.isFav == "1"{
                            self.favBtn.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
                        }else{
                            self.favBtn.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
                        }
                        self.Name.isHidden = false
                        self.dropBtn.isHidden = false
                        self.dropdownBtn.isHidden = false
                        self.favBtn.isHidden = false
                        self.profileImage.sd_setImage(with:URL(string:  (self.getVoiceArray[0] as AnyObject).value(forKey: "image") as! String), placeholderImage: #imageLiteral(resourceName: "name"))
                        
                        self.Name.text = ((self.getVoiceArray[0] as AnyObject).value(forKey: "name") as! String)
                        
                        self.setupAudioPlayer(song: (self.getVoiceArray[0] as AnyObject).value(forKey: "songs") as! String)
                        
                        self.audioPlayer.play()
                        
                    }
                }
                self.natureColectionView.reloadData()
            }else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
        
    }
    func favApiData(){
        //self.showProgress()
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameter : [String : Any] = ["user_id": userID, "session_id":sessonId]
        print(parameter)
        networkServices.shared.postDatawithoutHeader(methodName: methodName.UserCase.fav.caseValue, parameter: parameter) { (response) in
            print(response)
            self.hideProgress()
            let dic = response as! NSDictionary
            if dic.value(forKey: "success") as! Bool == true{
                let fav = dic.value(forKeyPath: "data.favourite") as! NSArray
                if "\((fav[0] as AnyObject).value(forKey: "favourite_status") as! NSNumber)" == "1"{
                    self.favBtn.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
                    SingletonClass.sharedInstance.isFav = "1"
                }else{
                     self.favBtn.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
                    SingletonClass.sharedInstance.isFav = "0"
                }
                
                
            }else{
                self.ShowAlertView(title: AppName, message: dic.value(forKey: "messages")as! String, viewController: self)
            }
        }
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        <#code#>
//    }
    
    func SetUpVC(){
        self.soundView.isHidden = true
        self.VolumeSlider.isHidden = true
        self.upperView.initGradientView(view: self.upperView, colour1: darkSkyBlue_Colour, colour2: Green_Colour)
    }
    
    
    @IBAction func PlayMusic(_ sender: Any) {
        if playPauseImageView.image == UIImage(named: "pause-1"){
            playPauseImageView.image = UIImage(named: "PlayWhite")
            audioPlayer.pause()
            backgroundAudioPlayer.pause()
            myQueuePlayer?.pause()
            isPause = true
        }else {
            if isPause {
                let currentTime = Float64(circularSlider.endPointValue)
                let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
                audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                audioPlayer.play()
                backgroundAudioPlayer.play()
                myQueuePlayer?.play()
                playPauseImageView.image = UIImage(named: "pause-1")
            }else {
                playPauseImageView.image = UIImage(named: "pause-1")
                self.audioPlayer.automaticallyWaitsToMinimizeStalling = false
                isPlaying = true
                self.audioPlayer.play()
                myQueuePlayer?.play()
                backgroundAudioPlayer.play()
            }
        }
    }
    
    @IBAction func SliderAction(_ sender: UISlider) {
        backgroundAudioPlayer.volume = sender.value
    }
    
    @IBAction func MusicTap(_ sender: UIButton) {
        if soundView.isHidden == true{
            self.soundView.isHidden = false
            VolumeSlider.isHidden = false
        }
        else{
            self.soundView.isHidden = true
            VolumeSlider.isHidden = true
        }
    }
    
    @IBAction func musicTap(_ sender: Any) {
        if VolumeSlider.isHidden == false{
            VolumeSlider.isHidden = false
            if !(backgroundMusicPlaying) {
                backgroundMusicPlaying = true
                 guard let audioFileURL = Bundle.main.url(forResource: "guitar-songs", withExtension: "mp3") else { return }
                let asset = AVURLAsset(url: audioFileURL, options: nil)
                let playerItem = AVPlayerItem(asset: asset)
                backgroundAudioPlayer.replaceCurrentItem(with: playerItem)
                backgroundAudioPlayer.play()
            }
        }
        else{
            VolumeSlider.isHidden = true
        }
    }
    
    @IBAction func BackTap(_ sender: UIButton) {
        stopBackPlayer()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favButtonTap(_ sender: UIButton) {
        favApiData()
    }
    
    @IBAction func SkipBack5Seconds(_ sender: UIButton) {
        playPauseImageView.image = UIImage(named: "pause-1")
        let currentTime = Float64(circularSlider.endPointValue - 5)
        let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
        audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        audioPlayer.play()
        myQueuePlayer?.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        myQueuePlayer?.play()
    }
    
    @IBAction func SkipForward5Seconds(_ sender: Any) {
        playPauseImageView.image = UIImage(named: "pause-1")
        let currentTime = Float64(circularSlider.endPointValue + 5)
        let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
        audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        audioPlayer.play()
        myQueuePlayer?.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        myQueuePlayer?.play()
    }
    // MARK: - Notification
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero,completionHandler:nil)
            playPauseImageView.image = UIImage(named: "PlayWhite")
            isPlaying = false
            stopBackPlayer()
            isPause = false
        }
    }
    @objc func playerItemDidReadyToPlay(notification: Notification) {
            if let _ = notification.object as? AVPlayerItem {
                // player is ready to play now!!
                self.activityIndicatro.isHidden = true
            }else{
                self.activityIndicatro.isHidden = false
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if backgroundAudioPlayer.rate > 0 {
                print("video started")
                self.activityIndicatro.isHidden = true
            }else{
                self.activityIndicatro.isHidden = false
            }
        }
    }
}

extension MusicPlayerViewController {
    func setupAudioPlayer(song:String) {
        // TODO: load the audio file asynchronously and observe player status
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            //let audioFileURL = audioUrl
           // guard let audioFileURL = Bundle.main.url(forResource: "1586515523", withExtension: "mp3") else { return }
            let asset = AVURLAsset(url: URL(string: song)!, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            audioPlayer.replaceCurrentItem(with: playerItem)
            audioPlayer.actionAtItemEnd = .pause
            let durationInSeconds = CMTimeGetSeconds(asset.duration)
            circularSlider.maximumValue = CGFloat(durationInSeconds)
            let interval = CMTimeMake(value: 1, timescale: 4)
            audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
                [weak self] time in
                let seconds = CMTimeGetSeconds(time)
                self?.updatePlayerUI(withCurrentTime: CGFloat(seconds))
            }
            }
        catch {
                  print("can't default to speaker ")
              }
        
    }
    func updatePlayerUI(withCurrentTime currentTime: CGFloat) {
        circularSlider.endPointValue = currentTime
        var components = DateComponents()
        components.second = Int(currentTime)
        audioTimeLabel.text = dateComponentsFormatter.string(from: components)
    }
    
    func SetCircularProgressBar(){
        circularSlider.endPointValue = 0
        circularSlider.addTarget(self, action: #selector(pause), for: .editingDidBegin)
        circularSlider.addTarget(self, action: #selector(play), for: .editingDidEnd)
        circularSlider.addTarget(self, action: #selector(updateTimer), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: audioPlayer.currentItem)
        
    }
    @objc func play() {
        let currentTime = Float64(circularSlider.endPointValue)
        let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
        audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        audioPlayer.play()
        myQueuePlayer?.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        myQueuePlayer?.play()
    }
    @objc func pause() {
        audioPlayer.pause()
        myQueuePlayer?.pause()
    }
    @objc func updateTimer() {
        playPauseImageView.image = UIImage(named: "pause-1")
        var components = DateComponents()
        components.second = Int(circularSlider.endPointValue)
        audioTimeLabel.text = dateComponentsFormatter.string(from: components)
        
    }
    
    func SetAudioPlayerForBackgroundAudio(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: backgroundAudioPlayer.currentItem, queue: nil) { (_) in
            self.backgroundAudioPlayer.seek(to: CMTime.zero)
            self.backgroundAudioPlayer.play()
        }
    }
    func stopBackPlayer() {
        if backgroundMusicPlaying {
            print("stopped")
            backgroundAudioPlayer.replaceCurrentItem(with: nil)
            print("player deallocated")
            backgroundMusicPlaying = false
        } else {
            print("player was already deallocated")
        }
    }
}
extension MusicPlayerViewController : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return natureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! natureCell
        let indexNature = natureArray[indexPath.item]
        if let imageString = (indexNature as AnyObject).value(forKey: "icon") as? String {
            if URL(string: (imageString) ) != nil {
                cell.natureImg.sd_setImage(with: URL(string: (imageString) ), placeholderImage:#imageLiteral(resourceName: "Professional"))
            }
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 47, height: 47)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexNature = natureArray[indexPath.item]
        if let songsString = (indexNature as AnyObject).value(forKey: "songs") as? String {
            if VolumeSlider.isHidden == false{
                VolumeSlider.isHidden = false
                if !(backgroundMusicPlaying) {
                    backgroundMusicPlaying = true
                    let audioFileURL = songsString
                    let asset = AVURLAsset(url: URL(string: audioFileURL)!, options: nil)
                    let playerItem = AVPlayerItem(asset: asset)
                    backgroundAudioPlayer.replaceCurrentItem(with: playerItem)
                    backgroundAudioPlayer.play()
                    self.activityIndicatro.isHidden = false
                    NotificationCenter.default.addObserver(self,
                                  selector: #selector(playerItemDidReadyToPlay(notification:)),
                                  name: .AVPlayerItemNewAccessLogEntry,
                                  object: backgroundAudioPlayer.currentItem)
                  //  backgroundAudioPlayer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
                    
                }else{
                    backgroundMusicPlaying = false
                    backgroundAudioPlayer.pause()
                }
            }
            else{
                VolumeSlider.isHidden = true
            }
        }
    }
    
}
class natureCell:UICollectionViewCell{
    @IBOutlet weak var natureImg: DesignableImage!
   
    
}
