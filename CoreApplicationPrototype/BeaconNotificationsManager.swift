//
//  BeaconNotificationsManager.swift
//  CoreApplicationPrototype
//
//  Created by Jason Custodio on 2/1/17.
//  Copyright © 2017 InboundRXCapstone. All rights reserved.
//

import UIKit
import UserNotifications

class BeaconNotificationsManager: NSObject, ESTBeaconManagerDelegate {
    
    private let beaconManager = ESTBeaconManager()
    
    //lists to hold all notification and beacons
    private var notificationsList = [Notification]()
    private var BeaconsList = [BeaconID]()
    
    //Dictionary to connect up Beacons with thier corresponding Notifications
    private var beaconNotificationDictionary = [BeaconID:Notification]()
    
    private var enterMessages = [String: String]()      // Message when user enters beacon range
    private var exitMessages  = [String: String]()      // Message when user exits beacon range
    
    override init() {
        super.init()
        
        //Grabs all Notifications and Beacons from web server
        retrieveNotifications()
        retrieveBeacons()
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization() // Launch Beacon in background
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
    }
    
    //Make network call to web server for notifications and fills local notificationList
    private func retrieveNotifications() {
        //Dummy Hard code data for now
        let notification1 = Notification(Title: "EntryNotification", Description: "Welcomes the User", entryMessage: "Welcome to Paulson's! You earned a Reward Point!", exitMessage: "Thanks for Stopping by!", BeaconID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D:54381:53700")
        
        let notification2 = Notification(Title: "CoffeeNotification", Description: "Asks the User if they want Coffee", entryMessage: "Want some Coffee?", exitMessage: nil, BeaconID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D:51207:48452")
        
        
        
        notificationsList.append(notification1)
        notificationsList.append(notification2)
    }
    
    ////Make network call to web server for Beacons and fills local beaconList
    private func retrieveBeacons() {
        //Dummy hard coded data for now
        
        
    }
    
    
    // Set enter and exit messages for beacons
    func enableNotifications(for beaconID: BeaconID, enterMessage: String?, exitMessage: String?) {
        let beaconRegion = beaconID.asBeaconRegion
        self.enterMessages[beaconRegion.identifier] = enterMessage
        self.exitMessages[beaconRegion.identifier]  = exitMessage
        self.beaconManager.startMonitoring(for: beaconRegion)
    }
    
    // Display beacon enter notification
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print ("\(region.identifier)")
        if let message = self.enterMessages[region.identifier] {
            self.showNotificationWithMessage(message)
            
            //if entry beacon
            if(region.identifier == "B9407F30-F5F8-466E-AFF9-25556B57FE6D:54381:53700") {
                rewardPoints += 1
                print (rewardPoints)
            }
            
            
        }
    }
    
    // Display beacon enter notification
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        if let message = self.exitMessages[region.identifier] {
            self.showNotificationWithMessage(message)
        }
    }
    
    // Setup notification message
    fileprivate func showNotificationWithMessage(_ message: String) {
        
        let content = UNMutableNotificationContent()  // Create notification content
        content.title = "Beacon in Range"             // Set notification title
        content.body = message                        // Set notification message
        content.sound = UNNotificationSound.default() // Set notification sound
        
        // Condition to meet to send notification (timeInterval displays after x seconds)
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        
        // Create notification with trigger condition and fill with message content
        let notification = UNNotificationRequest(identifier: "Entered", content: content, trigger: trigger)
        
        
        //Removes pending Notifications to prevent duplicates
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().add(notification) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    // Location Service Pemission Denied
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            NSLog("Location Services are disabled for this app, which means it won't be able to detect beacons.")
        }
    }
    
    // Bluetooth Beacon Connection Failure
    func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print("Monitoring failed for region: \(region?.identifier ?? "(unknown)"). Make sure that Bluetooth and Location Services are on, and that Location Services are allowed for this app. Beacons require a Bluetooth Low Energy compatible device: <http://www.bluetooth.com/Pages/Bluetooth-Smart-Devices-List.aspx>. Note that the iOS simulator doesn't support Bluetooth at all. The error was: \(error)")
    }
    
}

extension BeaconNotificationsManager: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print ("Using correct extention!")
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
