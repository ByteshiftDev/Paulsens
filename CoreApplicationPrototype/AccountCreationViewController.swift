//
//  AccountCreationViewController.swift
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
 Allows user to create an account onto webserver using email and password
 (optional phone and address)
*/

import UIKit

class AccountCreationViewController: UIViewController {

    /************** View Outlets **************/
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var repeatPassword: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    /************** View Actions **************/

    //Check users input to make sure everything that the required fields are
    //correctly inputed. If user is successful doing so then they are returned to the home page
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let createUser = appDelegate.user
        
        //Send the text fields to the user create account function to create a user
        let result = createUser.createAccount(email: email.text, password: password.text, repeatPassword: repeatPassword.text, phone: phone.text, address: address.text)
        
        //show the type of error that the user is missing in their creat account application, if the
        // createAccount function returned an error.
        if(!result.0){
            let alertController = UIAlertController(title: "Error", message: result.1, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated:true, completion:nil)
            return
        }
        
        //else return to home, as a sign of success
        segueToHome()
    }

    /***** Additional Controller Functions ****/
    
    // Perform an unwind segue back to home.
    private func segueToHome() {
        performSegue(withIdentifier: "unwindCreateAccToHome", sender: self)
    }
    
    /****** Default Controller Functions ******/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the UITextfield delegates to this class so they use the overridden functions to dismiss the keyboard
        self.email.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
        self.phone.delegate = self
        self.address.delegate = self
    }
}


extension AccountCreationViewController: UITextFieldDelegate {
    
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x:0,y:50), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x:0,y:-10), animated: true)    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
