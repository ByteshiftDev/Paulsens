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
    
    var screenHight = UIScreen.main.nativeBounds.height
    
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
        //print(UIDevice.current.modelName)
        switch screenHight{
        case 1136:
            if(textField == phone){
                ScrollView.setContentOffset(CGPoint(x:0,y:40), animated: true)
            }
            if(textField == address){
                ScrollView.setContentOffset(CGPoint(x:0,y:45), animated: true)
            }
            break
        case 1334:
            if(textField == address){
                ScrollView.setContentOffset(CGPoint(x:0,y:25), animated: true)
            }
            break
        case 1920:
            if(textField == address){
                ScrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
            }
            break
        default:
            break
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x:0,y:-25), animated: true)    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
