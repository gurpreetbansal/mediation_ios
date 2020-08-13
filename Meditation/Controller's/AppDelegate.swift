//
//  AppDelegate.swift
//  Meditation
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import AVFoundation
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import Braintree
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
       
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BTAppSwitch.setReturnURLScheme("com.dev.meditation.payments")
        // Get the singleton instance.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
        
        //For iqkeyboard
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        // for device token
        registerForPushNotifications()
        
        // ==============Initialize Google sign-in==================
               GIDSignIn.sharedInstance().clientID = "1044371968440-ccnht2ushq5kml2o5rgi3i28egro1iop.apps.googleusercontent.com"
               
       // ==============Initialize facebook sign-in==================
               ApplicationDelegate.shared.application(application,
                                                      didFinishLaunchingWithOptions: launchOptions)
        
        // ==============Firebase configure==================
        
    
        
        return true
    }
    
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Meditation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Google signIN delegate method
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme!.isEqual("fb233959547770702")){
            return
                (ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:]))
        }else if (url.scheme!.isEqual("com.googleusercontent.apps.1044371968440-ccnht2ushq5kml2o5rgi3i28egro1iop")){
            return
                GIDSignIn.sharedInstance().handle(url)
        }else if url.scheme?.localizedCaseInsensitiveCompare("com.dev.meditation.payments") == .orderedSame {
                return BTAppSwitch.handleOpen(url, options: options)
            }
        return false
        }
    
    
    //MARK: - UIApplicationDelegate Methods
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert,.sound,.badge])
    }
    
    // Handle notification messages after display notification is tapped by the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
        print("User Info = ",response.notification.request.content.userInfo)
        //        window?.rootViewController?.childViewControllers.last?.navigationController?.viewControllers.last?.dismiss(animated: false, completion: nil)
        
        //        let story = UIStoryboard.init(name: "Main" , bundle: nil)
        //        let noti_dict = response.notification.request.content.userInfo as NSDictionary
        //        print(noti_dict)
        //        if noti_dict.value(forKeyPath: "payload.noti_type") as! String == "apply_job"{
        //            let centerViewController = story.instantiateViewController(withIdentifier: "JobBoardViewController") as! JobBoardViewController
        //            let centnav = UINavigationController(rootViewController:centerViewController)
        //            centerContainer.centerViewController = centnav
        //
        //            let vc = story.instantiateViewController(withIdentifier: "JobBoardViewController") as! JobBoardViewController
        //            centerViewController.navigationController?.pushViewController(vc, animated: false)
        //        }
        
        
    }
    // The callback to handle data message received via FCM for devices running iOS 10 or above
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0...deviceToken.count-1 {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("DEVICE TOKEN = \(deviceToken)")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        UserDefaults.standard.set(token, forKey: "DEVICETOKEN");
        UserDefaults.standard.synchronize();
        // UpdateLocation.upadteDeviceToke(token: token)
        // Define identifier
        let notificationName = Notification.Name("DEVICETOKEN_NOTI")
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        // Get FCM Token
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                SingletonClass.sharedInstance.FCMToken = "\(result.token)"
                UserDefaults.standard.set("\(result.token)", forKey: "DeviceToken");
                UserDefaults.standard.synchronize();
                
            }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Define identifier
        let notificationName = Notification.Name("DEVICETOKEN_NOTI")
        // Post notification
        UserDefaults.standard.set("123456789032424424242444242", forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
        SingletonClass.sharedInstance.FCMToken = "1231231231231231231231"
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        SingletonClass.sharedInstance.FCMToken = "\(fcmToken)"
        UserDefaults.standard.set("\(fcmToken)", forKey: "DeviceToken");
        UserDefaults.standard.synchronize();
    }
}

