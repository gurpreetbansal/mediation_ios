//
//  Singleton.swift
//  Sleep Learning
//
//  Created by Apple on 27/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class SingletonClass: NSObject {
    // MARK: Singleton Object Creation
    static let sharedInstance: SingletonClass = {
        let singletonObject = SingletonClass()
        return singletonObject
    }()
     var myAudioPlayer:AVPlayer?
}

