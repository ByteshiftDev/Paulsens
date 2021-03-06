//
//  AppDelegate.swift
//  CoreApplicationPrototype
//
//  InboundRX iOS RFID Beacon Detecting Application
//  https://gitlab.com/InboundRX-Capstone/Paulsens-iOS-App
//
//  (c) 2017 Brett Chafin, Jason Brophy, Luke Kwak, Paul Huynh, Jason Custodio, Cher Moua, Thaddeus Sundin
//
//  You are free to use, copy, modify, and distribute this file, with attribution,
//  under the terms of the MIT license. See "license.txt" for more info.

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    //Set a global user for the application, initially the user email is noUser, any email should have an @, so this email should be a stock
    // value for non logged in status which cannot be generated by any valid user manipulation.
    
    
    var user = User(userEmail: "noUser")
    var isDisplayingPopup = false
    
    // What if this is inside the function below?****
    // Create Instance of Beacon Manager
    //let beaconNotificationsManager = BeaconNotificationsManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // For checking if user is still logged in

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        var userID: Int?
        var points: Int?
        var phoneNumber: String?
        var address: String?
        var webToken: String?
        //check if email has anything, if it does auto login that user else do nothing
        if let email = KeychainWrapper.standard.string(forKey: "email") {
            
            if let temp = KeychainWrapper.standard.integer(forKey: "userID"){
                userID = temp
            }
            if let temp = KeychainWrapper.standard.integer(forKey: "points"){
                points = temp
            }
            if let temp = KeychainWrapper.standard.string(forKey: "phoneNumber"){
                phoneNumber = temp
            }
            
            if let temp = KeychainWrapper.standard.string(forKey: "address"){
                address = temp
            }
            if let temp = KeychainWrapper.standard.string(forKey: "token"){
                webToken = temp
            }
            user.autoLoginUser(email: email, userID: userID, points: points, phoneNumber: phoneNumber, address: address, webToken: webToken)
        }
        
        
        // Override point for customization after application launch.
        //[[UINavigationBar appearance] setTitleTextAttributes]
        
        // Test Notification while App is open
        UserNotificationManager.shared.registerNotification()
        let navBarApperance = UINavigationBar.appearance()
        
        navBarApperance.tintColor = UIColor.white
        navBarApperance.barTintColor = UIColor(red: 0.24, green: 0.34, blue: 0.45, alpha: 1.0)
        
        navBarApperance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Change top status bar to light theme
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let beaconNotificationsManager = BeaconNotificationsManager()
        
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
    }
    
    
}

