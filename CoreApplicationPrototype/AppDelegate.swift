//
//  AppDelegate.swift
//  CoreApplicationPrototype
//
//  Created by Thaddeus Sundin on 11/21/16.
//  Copyright © 2016 InboundRXCapstone. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    //Create Instance of Beacon Manager
    let beaconNotificationsManager = BeaconNotificationsManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // You can get them by adding your app on https://cloud.estimote.com/#/apps
        // ESTConfig.setupAppID("<#App ID#>", andAppToken: "<#App Token#>")
        
        
        
        self.beaconNotificationsManager.enableNotifications(
            
            for: BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 51207, minor: 48452),
            enterMessage: "Hello, world.",
            exitMessage: "Goodbye, world."
        )
        
        
        // NOTE: "exit" event has a built-in delay of 30 seconds, to make sure that the user has really exited the beacon's range. The delay is imposed by iOS and is non-adjustable.
        
        return true
    }
    
    /*func callNotification() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Beacon in Range"
        content.body = "test"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        
        let notification = UNNotificationRequest(identifier: "Entered", content: content, trigger: trigger)
        
        
        
        UNUserNotificationCenter.current().add(notification) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        
        }
    }*/
    

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
    }


}

