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
let BaseURL = "https://meditation.customer-devreview.com/api/"

//new Braintree_Gateway
 // 'environment' => 'sandbox',
  var merchantId = "8dqh7byvnvbgfv3q"
  var publicKey = "43wrqvzv9rjfmrf8"
  var privateKey = "2774a014c7628642161604885b082412"


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
        case support
        case editProfile
        case SetContent
        case GetHomeData
        case TokenGenerate
        case Payment
        case MyFavouriteSongs
        case MySongsList
        case PostMySongList
        case MyAffirmation
        case Sounds
        case ContactUs
        var caseValue : String{
            switch self{
            case .userSignUP:                return "auth/register"
            case .UserSignIn:                return "auth/login"
            case .SocialLogIn:               return "auth/socailLogin"
            case .LogOut:                    return "auth/logout"
            case .getVoiceList:              return "collections/getVoice"
            case .setVoice:                  return "collections/setVoice"
//          case .getCategoryList:           return "collections/getContentsInfo"
            case .getCategoryList:           return "collections/getCategoryes"
            case .MySongsList:               return "collections/mySongsList"
            case .PostMySongList:            return "collections/postMySongs"
            case .MyAffirmation:             return "collections/affirmationCategoies"
            case .Sounds:                    return "collections/music"
            case .support:                   return "collections/support"
            case .getProfile:                return "auth/getProfile"
            case .editProfile:               return "auth/editProfile"
            case .SetContent:                return "collections/collectCategory"
            case .GetHomeData:               return "collections/randomCategory"
            case .MyFavouriteSongs:          return "collections/myfavoritesongs"
            case .ContactUs:                 return "auth/contactUs"
            case .Payment:                   return "payment/brainTreePayment"
            case .TokenGenerate:             return "payment/brainTreegenerateToken"
             }
        }
    }
}

