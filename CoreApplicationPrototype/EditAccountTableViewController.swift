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
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextField: UITextField!
    @IBOutlet weak var editPasswordSubmit: UIButton!

    //Edit Phone Number Variables
    @IBOutlet weak var currentPhoneNumberLabel: UILabel!
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    @IBOutlet weak var editPhoneNumberSubmit: UIButton!
    
    //Edit Address Variables
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var editAddressSubmit: UIButton!
    let statesAbbrev = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    let statePicker = UIPickerView()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.delegate = self
        statePicker.dataSource = self
        
        //Binding textfield to picker
        stateTextField.inputView = statePicker
        
        //Need to make textfields into delegates so they can use keyboards and be dismissed
        self.oldPasswordTextField.delegate = self
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
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let editUser = appDelegate.user
        
        currentPhoneNumberLabel.text = "TEST"
        currentAddressLabel.text = "TEST"
        
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
        oldPasswordTextField.resignFirstResponder()
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
        oldPasswordTextField.resignFirstResponder()
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
        performSegue(withIdentifier: "unwindEditToHome", sender: self)
    }
    
}
