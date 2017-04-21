//
//  HomeViewController.swift
//  CoreApplicationPrototype
//
//  InboundRX iOS RFID Beacon Detecting Application
//  https://gitlab.com/InboundRX-Capstone/Paulsens-iOS-App
//
//  (c) 2017 Brett Chafin, Jason Brophy, Luke Kwak, Paul Huynh, Jason Custodio, Cher Moua, Thaddeus Sundin
//
//  You are free to use, copy, modify, and distribute this file, with attribution,
//  under the terms of the MIT license. See "license.txt" for more info.


/*
 View controller for the home screen that shows the daily deals, order prescription, and settings button
*/

import UIKit

var rewardPoints = 0

class HomeViewController: UIViewController {

    let webCallController = WebCallController()
    
    var userTotalRewardPoints: Int {
        get{return rewardPoints}
//        set{ rewardPointsLabel.text = String(newValue)}
        
    }
    
    // Order prescriptions online using a button
    @IBAction func OrderPrescription() {
        
    // Safari Transfer confirmation
       
    let inputTitle   = "WEBSITE TRANSFER"
    let inputMessage = "Do you want to open this website in Safari?"
        
    let link = "https://www.paulsenspharmacy.com/services/concierge"
    // Action Handler to open URL
    let yesButton = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in UIApplication.shared.open(NSURL(string: link)! as URL)
        })
            
    createAlert(title: inputTitle, message: inputMessage, action: yesButton)
    
    }
    
    @IBAction func unwindtoHome(segue:UIStoryboardSegue) { }

   
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var rewardPointsLabel: UILabel!
    
    internal func updateHomeUI() {
        //fetch users total points
//        userTotalRewardPoints = 20 //dummy data
        //update points label
//        rewardPointsLabel.text = String(rewardPoints)
        //FUTURE - retrieve and update deals table
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        updateHomeUI()
        
//        let response = webCallController.createNewUser(userDict: ["email": "neveruse@test.com", "password": "123456"])
//        print("Response: ")
//        print(response)
        //webCallController.userLogIn(userDict: ["email": "user@test.com", "password": "nopenope"])
        //webCallController.editUser(userDict: ["email": "user@test.com", "password": "qwerty"])
        //webCallController.userLogOut()
        
        /*
        webCallController.getBeaconList { (tuple: (Bool, String, Array<Dictionary<String, AnyObject>>?)) in
            let (isError, error, beaconList) = tuple
            if isError == false {
                var i = 0
                for dict in beaconList! {
                    print("Dictionary \(i):")
                    print(dict)
                    print("\n---\n")
                    i = i+1
                }
            } else {
                print("There was an error: "+error)
            }
        }
        
        webCallController.getHistoricalEventList { (historicalEventsList) in
            if historicalEventsList != nil {
                var i = 0
                for dict in historicalEventsList! {
                    print("Event \(i):")
                    print(dict)
                    print("\n---\n")
                    i = i+1
                }
            }
        }
        webCallController.userLogOut()
        webCallController.getUserPoints { (points) in
            if((points) != nil) {
                print("\n\nUser points after logging out: "+points!+"\n\n")
            }
        }
        
        webCallController.getDailyDealList { (dailyDealList) in
            if dailyDealList != nil {
                var i = 0
                for dict in dailyDealList! {
                    print("Daily deal \(i):")
                    print(dict)
                    print("\n---\n")
                    i = i+1
                }
            }
        }
 
        */


        //let delegate = UIApplication.shared.delegate as? AppDelegate
        //delegate?.callNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateHomeUI()
        
        
        //let delegate = UIApplication.shared.delegate as? AppDelegate
        //delegate?.callNotification()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Create confirmation alert function
    func createAlert(title: String, message: String, action: UIAlertAction){
        
        // Alert style confirmation
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Handler used to transition to other code, cancel confirmation
        let noButton  = UIAlertAction(title: "NO",  style: UIAlertActionStyle.destructive, handler: nil)
        
        alert.addAction(action)     // Add YES button to Alert controller
        alert.addAction(noButton)   // Add NO  button to Alert controller
        
        // Completion: do something after alert is displayed
        present(alert, animated: true, completion: nil)  // Display Alert
    }
    
}

