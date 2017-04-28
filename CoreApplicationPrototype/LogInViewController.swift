//
//  LogInViewController.swift
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
 Login view controller that consists of inputting email, password,
 allowing to view password, and submitting it.
*/
import UIKit
import UserNotifications

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    /************ Class Varibles ********/
    
    var viewPassword = false
    
    /************ View Outlets **********/
    
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    /************ View Actions **********/
    
    @IBAction func logInButtonPress(_ sender: UIButton) {
        //This allows to check whether what the user inputed, to login, was a match
        //to a preexisting user, if not then show an error to the user to let them know
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        
        //check users input through the user object
        let result = user.loginUser(emailField: emailField.text, passwordField: passwordField.text)
        
        //Show the error if the login function returned one, as an alert popup.
        if(!result.0){
            let alertController = UIAlertController(title: "Error", message: result.1, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated:true, completion:nil)
            return
        }
        else{
            //save in user information
            /*
            let userDefaults = UserDefaults.standard
            userDefaults.set(emailField.text, forKey: "email")
            userDefaults.set(passwordField.text, forKey: "password")
            userDefaults.synchronize()
            */
            
            let keychain = KeychainWrapper.standard
            keychain.set(emailField.text!, forKey: "email")
            keychain.set(passwordField.text!, forKey: "password")
            
            
        }
        
        
        // Login was successful, return to the home view.
        segueToHome()
    }
    
    
    // Connected to the cancel button, it segues the user back to home on click using an unwind.
    @IBAction func dismiss(_ sender: UIButton) {
        segueToHome()
    }
    
    
    // Update the visibility of the password field based upon the check box
    // This is done by setting it to secure/not secure, depending on button status.
    @IBAction func updatePasswordVisibility(_ sender: UISwitch) {
        if viewPassword {
            passwordField.isSecureTextEntry = true;
            viewPassword = false
        }
        else{
            passwordField.isSecureTextEntry = false;
            viewPassword = true
        }
    }
    
    /************ Additional Controller Functions ******/
    
    //Perform an unwind segue back to the home view.
    private func segueToHome() {
        performSegue(withIdentifier: "unwindLogintoHome", sender: self)
    }
    
    /************ Default Controller Functions *********/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text fields to use this controller as their delegate.
        // This allows for use of the implemented functions
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    
    //'Return' (Labeled as Done) closes the keyboard.
    //'_' uses no argument label
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //touching anywhere outside the keyboard UI will close the keyboard.
    //'_' uses no argument label
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
