//
//  AppDelegate.swift
//  Notifire
//
//  Created by Roydon Jeffrey on 2/4/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Check which iOS version to run on
        if #available(iOS 9.0, *) {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            //Register to listen for push notifications
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        }else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            
            application.registerForRemoteNotifications(matching: types)
        }
        
        //Connect to Firebase server 
        FIRApp.configure()
        
        //Make this appDelegate an observer to listen for notifications by token refresh and then call the tokenRefresh method.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefresh(notification:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //To close an active connection to the server to save bandwidth
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Function Call
        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Get the refresh token
    func tokenRefresh(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        print("InstanceID Token: \(refreshedToken)")
        
        //Function Call
        connectToFCM()
    }
    
    //To connecto to Firebase onnection CMessaging
    func connectToFCM() {
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Cannot connect to Firebase Connection Messaging because \(error.debugDescription)")
            }else {
                print("Connection to Firebase Messaging is ready")
            }
        }
    }


}

