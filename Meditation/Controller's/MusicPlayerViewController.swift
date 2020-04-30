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


class MusicPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    
    var isPlaying = false
    var backgroundMusicPlaying = false
    private var playerViewControllerKVOContext = 0
    private var dogSound: Sound?
    var audioUrl = NSURL()
    var isPause = false
    let audioPlayer = AVPlayer()
    var backgroundAudioPlayer = AVPlayer()
    var duration = String()
    // date formatter user for timer label
    let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    
    
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
        SetCircularProgressBar()
        SetAudioPlayerForBackgroundAudio()
        SetUpVC()
        print("music\(audioUrl)")
    }
    override func viewDidAppear(_ animated: Bool) {
        setupAudioPlayer()
        isPlaying = true
        playPauseImageView.image = UIImage(named: "pause")
        self.audioPlayer.automaticallyWaitsToMinimizeStalling = false
        self.audioPlayer.play()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if isPlaying {
            audioPlayer.pause()
            if backgroundMusicPlaying == true {
                backgroundAudioPlayer.pause()
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
        if playPauseImageView.image == UIImage(named: "pause"){
            playPauseImageView.image = UIImage(named: "PlayWhite")
            audioPlayer.pause()
            backgroundAudioPlayer.pause()
            isPause = true
        }else {
            if isPause {
                let currentTime = Float64(circularSlider.endPointValue)
                let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
                audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                audioPlayer.play()
                backgroundAudioPlayer.play()
                playPauseImageView.image = UIImage(named: "pause")
            }else {
                playPauseImageView.image = UIImage(named: "pause")
                self.audioPlayer.automaticallyWaitsToMinimizeStalling = false
                isPlaying = true
                self.audioPlayer.play()
            }
        }
    }
    
    @IBAction func SliderAction(_ sender: UISlider) {
        backgroundAudioPlayer.volume = sender.value
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
            VolumeSlider.isHidden = false
        }
    }
    
    @IBAction func BackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favButtonTap(_ sender: UIButton) {
//        if self.favBtn.imageView?.image == #imageLiteral(resourceName: "unfav"){
//            self.favBtn.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
//        }
//        else{
//            self.favBtn.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
//        }
        self.performPushSeguefromController(identifier: "MyFavouriteViewController")
    }
    
    @IBAction func SkipBack5Seconds(_ sender: UIButton) {
        playPauseImageView.image = UIImage(named: "pause")
        let currentTime = Float64(circularSlider.endPointValue - 5)
        let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
        audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        audioPlayer.play()
    }
    
    @IBAction func SkipForward5Seconds(_ sender: Any) {
        playPauseImageView.image = UIImage(named: "pause")
        let currentTime = Float64(circularSlider.endPointValue + 5)
        let newTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 600)
        audioPlayer.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        audioPlayer.play()
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
}

extension MusicPlayerViewController {
    func setupAudioPlayer() {
        // TODO: load the audio file asynchronously and observe player status
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            //let audioFileURL = audioUrl
            guard let audioFileURL = Bundle.main.url(forResource: "1586515523", withExtension: "mp3") else { return }
            let asset = AVURLAsset(url: audioFileURL as URL, options: nil)
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
    }
    @objc func pause() {
        audioPlayer.pause()
    }
    @objc func updateTimer() {
        playPauseImageView.image = UIImage(named: "pause")
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
