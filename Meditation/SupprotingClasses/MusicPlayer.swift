//
//  MusicPlayer.swift
//  Sleep Learning
//
//  Created by Apple on 30/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


extension UIViewController{


//MARK:- Setup of music player with avfoundation Classes
func assignSong(urlString:String){
    let playerItem = AVPlayerItem( url:NSURL( string:urlString )! as URL)
    SingletonClass.sharedInstance.myAudioPlayer = AVPlayer(playerItem:playerItem)
    SingletonClass.sharedInstance.myAudioPlayer!.rate = 1.0
     }
    func isPlay(){
        SingletonClass.sharedInstance.myAudioPlayer!.play()
        }
    func isPause(){
        SingletonClass.sharedInstance.myAudioPlayer!.pause()
    }
   
}
