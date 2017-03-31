//
//  SettingsViewController.swift
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
 Allows user to login, logout, turn off notifications, create/edit an account.
*/

import UIKit

class SettingsViewController: UIViewController {

    
    /************ Class Varibles ********/
   
    var notificationsOn = true
    
    /************ View Outlets **********/
    
    @IBOutlet weak var NotificationLabel: UILabel!
    
    @IBOutlet weak var logButton: UIButton!
    
    @IBOutlet weak var acctMod: UIButton!

    /************ View Actions **********/

    @IBAction func toggleNotifications(_ sender: UISwitch) {
        if (sender.isOn)    {
            NotificationLabel.text = "Notifications: On"
            notificationsOn = true
        }
        else {
            NotificationLabel.text = "Notifications: Off"
            notificationsOn = false
        }
    }
    
    
    // This function operates differently depending on the user login status.
    // If the user is logged in, it needs to perform the work in logOutPush, as the
    // user is requesting a logout.  The button title is then set to login.
    // Login actually requires the user login to guarantee the button title flip, so
    // it is not done here.
    @IBAction func handleLogTouch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        if(user.loggedIn()){
            // No error return required, if this function fails, its
            // because there was no user to logout, so the text should be flipped
            // regardless.
            self.logOutPush()
            self.logButton.setTitle("Log In", for: UIControlState.normal)
        }
    }
    
    
    // If the user hits the acctMod button, it has to do different behavior
    // based on whether a user is logged in or not.  It segues to the correct
    // view depending on that status.  If logged in, edit account, if logged out
    // to the create account.
    @IBAction func handleAcctTouch(_ sender: Any) {
        
        // Get the application user object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        //If logged in, perform the editAccount segue, otherwise, perform the createAccount segue.
        if(user.loggedIn()){
            performSegue(withIdentifier: "editAccount", sender: self)
        }
        else{
            performSegue(withIdentifier: "createAccount", sender: self)
        }
    }
    
    /************ Additional Controller Functions ******/
    
    // If the user has pushed the logout button, log the user out, if there is a failure, display it.
    // This error is more app related than user related, so it is possible it should have different behavior.
    func logOutPush(){
        //Fetch the user from app delegate, then call the user logOut function.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        let result = user.logOut()
        //Present the error if the logOut function returned false, using the string portion of the tuple as the message.
        if(!result.0){
            let alertController = UIAlertController(title: "Error", message: result.1, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated:true, completion:nil)
        }
    }
    
    /************ Default Controller Functions *********/
    
    // This function is overridden to update the view on pending appearance
    // This forces the login/logout and edit/create account buttons to take
    // the correct title depending on user login status.
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        if user.loggedIn(){
            logButton.setTitle("Log Out", for: UIControlState.normal)
            acctMod.setTitle("Edit Account", for: UIControlState.normal)
        }
        else{
            logButton.setTitle("Log In", for: UIControlState.normal)
            acctMod.setTitle("Create Account", for: UIControlState.normal)
        }
    }
    
    
    // Update the Notifcation Label based on Notification setting,
    // and logButton and acctMod button to the correct title depending on login status.
    override func viewDidLoad() {
        super.viewDidLoad()
        if(notificationsOn){
            NotificationLabel.text = "Notifications: On"
        }
        else{
            NotificationLabel.text = "Notifications: Off"
        }
        
        // Fetch the user to check login status
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        
        if user.loggedIn(){
            logButton.setTitle("Log Out", for: UIControlState.normal)
            acctMod.setTitle("Edit Account", for: UIControlState.normal)
        }
        else{
            logButton.setTitle("Log In", for: UIControlState.normal)
            acctMod.setTitle("Create Account", for: UIControlState.normal)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // If the segue being performed is the logSegue, perform the actions related to that button touch.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "logSegue"){
            self.handleLogTouch()
        }
    }
}
