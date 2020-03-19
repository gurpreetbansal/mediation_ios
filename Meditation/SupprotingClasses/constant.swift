//
//  constant.swift
//  Sleep Learning
//
//  Created by Apple on 19/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

let googleAPiKey = "AIzaSyDZYWHdACwG4QM5BGXh5rJ5BTI3b_0FXOk"
let BaseURL = "https://clientstagingdev.com/meditation/api/"

public enum methodName{
    public enum UserCase{
        case userSignUP
        case UserSignIn
        case SocialLogIn
        case LogOut
        case getVoiceList
        case setVoice
        case getCategoryList
         case getProfile
        case editProfile
        var caseValue : String{
            switch self{
            case .userSignUP:                return "auth/register"
            case .UserSignIn:                return "auth/login"
            case .SocialLogIn:               return "auth/socailLogin"
            case .LogOut:                    return "auth/logout"
            case .getVoiceList:              return "collections/getVoice"
            case .setVoice:                  return "collections/setVoice"
            case .getCategoryList:           return "collections/getContentsInfo"
            case .getProfile:               return "auth/getProfile"
            case .editProfile:              return "auth/editProfile"
             }
        }
    }
}

