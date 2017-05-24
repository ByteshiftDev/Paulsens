//
//  CreateAccountController.swift
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

class EditAccountTableViewController: UITableViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //Edit Password Variables
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextField: UITextField!
    @IBAction func editPasswordSubmit(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        
        let result = user.editPassword(currentPassword: PasswordTextField.text, password: newPasswordTextField.text, repeatPassword: repeatNewPasswordTextField.text)
        
        //user.editAccount(email: user.emailGetter(), currentPassword: oldPasswordTextField.text, password: newPasswordTextField.text, repeatPassword: repeatNewPasswordTextField.text, phone: user.phoneGetter(), address: user.addressGetter())
        
        if(!result.0){
            let alertController = UIAlertController(title: "Error", message: result.1, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated:true, completion:nil)
            return
        }
        else{
            //don't need to set password, it is not stored
            segueToHome()
        }
    }


    //Edit Phone Number Variables
    @IBOutlet weak var currentPhoneNumberLabel: UILabel!
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    @IBAction func editPhoneNumberSubmit(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        
        let result = user.editPhone(phone: newPhoneNumberTextField.text, currentPassword: PasswordTextField.text)
        
        //user.editAccount(email: user.emailGetter(), currentPassword: user.passwordGetter(), password: user.passwordGetter(), repeatPassword: user.passwordGetter(), phone: newPhoneNumberTextField.text, address: user.addressGetter())
        
        if(!result.0){
            let alertController = UIAlertController(title: "Error", message: result.1, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated:true, completion:nil)
            return
        }
        else{
            //update current phone number lable and segue home.
            currentPhoneNumberLabel.text = newPhoneNumberTextField.text
            //set phone
            user.setPhoneNumber(phoneNumber: newPhoneNumberTextField.text)
            segueToHome()
        }
    }

    
    //Edit Address Variables
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    let statesAbbrev = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    let statePicker = UIPickerView()
    
    @IBAction func editAddressSubmit(_ sender: UIButton) {
        
        let address = addressTextField.text! + locationTextField.text! + stateTextField.text! + zipCodeTextField.text!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        
        let result = user.editAddress(address: address, currentPassword: PasswordTextField.text)
        
        //user.editAccount(email: user.emailGetter(), currentPassword: user.passwordGetter(), password: user.passwordGetter(), repeatPassword: user.passwordGetter(), phone: user.phoneGetter(), address: address)
        
        if(!result.0){
            let alertController = UIAlertController(title: "Error", message: result.1, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated:true, completion:nil)
            return
        }
        else{
            //update current phone number lable and segue home.
            currentAddressLabel.text = address
            //set address
            user.setAddress(address: address)
            segueToHome()
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.delegate = self
        statePicker.dataSource = self
        
        //Binding textfield to picker
        stateTextField.inputView = statePicker
        
        //Need to make textfields into delegates so they can use keyboards and be dismissed
        self.PasswordTextField.delegate = self
        self.newPasswordTextField.delegate = self
        self.repeatNewPasswordTextField.delegate = self
        self.newPhoneNumberTextField.delegate = self
        self.addressTextField.delegate = self
        self.locationTextField.delegate = self
        self.stateTextField.delegate = self
        self.zipCodeTextField.delegate = self
        
        //Number Keypad
        newPhoneNumberTextField.keyboardType = UIKeyboardType.numberPad
        
        //Keypad dismissed when clicking outside of the keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
            #selector(EditAccountTableViewController.dismissKeyboard)))
        
        // First grab the user for the application
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        currentPhoneNumberLabel.text = user.phoneGetter()
        currentAddressLabel.text = user.addressGetter()
        
    }
    
    

    //Next four functions are for statesPicker
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesAbbrev.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statesAbbrev[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = statesAbbrev[row]
        self.view.endEditing(false)
    }
    
    
    //Next four functions are for keyboards with textfields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        PasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        repeatNewPasswordTextField.resignFirstResponder()
        newPhoneNumberTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        zipCodeTextField.resignFirstResponder()
        newPhoneNumberTextField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func dismissKeyboard(){
        PasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        repeatNewPasswordTextField.resignFirstResponder()
        newPhoneNumberTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        zipCodeTextField.resignFirstResponder()
        newPhoneNumberTextField.resignFirstResponder()
    }
    
    
    //Segue to home function
    private func segueToHome(){
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
}
