//
//  User.swift
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
 A User class that stores users information emails and points.
 Also deals with the functionality of a User class such as web calls to log in, log out, update points, create account,
 and log in status.
*/


import UIKit

struct userReward{
    let title : String!
    let des   : String!
    
    init(title: String, des: String){
        self.title = title
        self.des = des
    }
    
    subscript(arg: String)->String{
        if(arg == "title"){
            return title
        }
        else{
            return des
        }
        
    }
 }

class User: NSObject {
    
    /************* Local Varibles *************/
    
    private var email: String //This is used to store the email of the current user.
    
    public var userID: Int?
    
    private var points: Int? //This stores the current users points value (for display only)
    
    private var password: String?
    
    private var phoneNumber: String?
    
    private var address: String?
    
    public var webToken: String? //token
    
    public var userRewards = [userReward]()
    
    /*************** Constructor **************/
    
    init(userEmail: String){
        self.email = userEmail
    }
    
    
    func printUser() {
        print("Printing current User")
        print("Email: " + email)
        print("userID: " + String(describing: userID))
        print("points: " + String(describing: points))
        if let pass = password {
            print("password: " + pass)
        }
        if let num = phoneNumber {
            print("phoneNumber: " + num)
        }
        if let addr = address {
            print("address: " + addr)
        }
        if let token = webToken {
            print("webToken: " + token)
        }
        
    }
    
    /********* Login Status functions *********/

    // Return true if there is a user logged in, false if there is not.
    // Could be modified to return the username of the user if logged in as well.
    func loggedIn() -> Bool{
        return self.email != "noUser"
    }
    
    /******** Log In/Log Out functions ********/
    
    //This function returns a boolean string tuple consisting of success status and possible error message.
    // Return true if log out is successful (if there is a user to logout), 
    // Return false if there is no currently logged in user, as well as a string message stating such
    // Also set the current user points to 0.
    func logOut() -> (Bool, String){
        self.email = "noUser"
        self.points = 0
        let webCallController = WebCallController()
        webCallController.userLogOut()
        return (true, "")
    }
    
    
    // This function takes the emailField string and password string
    // for logging a user in.  The return value is a tuple of a 
    // Boolean for testing success of login, and a string, to be 
    // utilized in event of an error.
    func loginUser(emailField: String?, passwordField: String?)  -> (Bool, String){
        
        let _ = self.logOut()
        let result = self.securityTest(emailField: emailField, passwordField: passwordField)
        if(!result.0){
            return (result.0, result.1)
        }
        
        //take the JSON recieced from the securityTest and create the user
        /* Sample userData
         ["email": chafin@pdx.edu, "id": 73, "preferences": {
         }, "visit_count": 0, "address": <null>, "phone": <null>, "created_at": 2017-04-14T02:34:09.142Z, "updated_at": 2017-04-14T03:35:58.317Z, "points": {
         "cashable_id" = 73;
         "cashable_type" = User;
         "created_at" = "2017-04-14T02:34:09.195Z";
         id = 73;
         "updated_at" = "2017-04-14T02:34:09.195Z";
         value = 0;
         }]*/
 
 
        let user = result.3;
        if let userData = user?["user"] as? Dictionary<String, Any> {
            self.userID = userData["id"] as? Int
            self.email = (userData["email"] as? String ?? "")!
            let pointDict = userData["points"] as? Dictionary<String, Any>
            self.points = (pointDict?["value"] as? Int ?? 0)
            self.address = userData["address"] as? String
            self.phoneNumber = userData["phone"] as? String
        }
        let token = user?["token"] as? String
        self.webToken = "Bearer " + token!

        
        KeychainWrapper.standard.set(self.userID!, forKey: "userID")
        KeychainWrapper.standard.set(self.email, forKey: "email")
        KeychainWrapper.standard.set(self.points!, forKey: "points")
        if let addr = self.address{
            KeychainWrapper.standard.set(addr, forKey: "address")
        }
        if let phoneNum = self.phoneNumber{
            KeychainWrapper.standard.set(phoneNum, forKey: "phoneNumber")
        }
        KeychainWrapper.standard.set(self.webToken!, forKey: "token")

        
        
        printUser()
        
        //return a successful result.
        return (true, "")
        //Error checking needed when we start to get to the login page
        //from multiple paths
    }
    
    
    // This function checks the credentials for a logging in user against
    // Any user not yet logged in found in the database, and checks the credentials
    // Of only the logged in user if used when a user is logged in.  It returns
    // a tuple of a result, true or false, a string error message, and the user's points
    // If they are logged in, to set the value only if being logged in.
    func securityTest(emailField: String?, passwordField: String?) -> (Bool, String, Int, (Dictionary<String, Any>)?){
        //If either field is blank, return false and an error message
        //in string format to state as such.
        if(emailField == "" || passwordField == ""){
            //Error for empty field
            return (false, "A field was left empty", 0, nil)
        }
        
        //Get the dictionary for this email, lowercased, if it exists
        let userInfo = UserDefaults.standard.dictionary(forKey: emailField!.lowercased())
        // Comment in the next line to add webserver dictionary creation
        let webServerDict: [String: String] = ["email": emailField!.lowercased(), "password": passwordField!]
        let webCallController = WebCallController()
        let result = webCallController.userLogIn(userDict: webServerDict)
        if(result.0){
            return (!result.0, result.1, 0, result.2)
        }
        // If there is no user with this email, or the password is incorrect
        // Return an error stating as such, but not specifying which for security.
        var pointsString : String = ""
        if((userInfo) != nil){
            pointsString = userInfo!["points"] as! String
        }else{
            pointsString = self.updatePoints()
            let storedInfo: [String: String] = ["email": self.email.lowercased(), "points": pointsString]
            UserDefaults.standard.setValue(storedInfo, forKey: self.email.lowercased())
        }
        return (true, "", Int(pointsString)!, result.2)

    }
    
    /****** Create/Edit Account Functions *****/
    
    // This function is used to create an account for a user within the app
    // It takes an email, password, repeatPassword, phone number, and address, all as string optionals
    // It forms from this the email, password and point combo to store locally (password removed upon web server call finished)
    // and stores these values in the userDefaults for the application.
    // It also creates a dictionary with the email, password, and then possible phone number and address, if filled not empty.
    func createAccount(email: String?, password: String?, repeatPassword: String?, phone: String?, address: String?) -> (Bool, String){
        
        //Get the Userdefaults object for standard defaults
        let defaults = UserDefaults.standard
        if(email == "" || password == "" || repeatPassword == ""){
            //If there was an empty value in one of the arguments
            //return false, and the a message representing that.
            return (false, "A field was left empty")
        }
        
        //If the passwords supplied do not match, return false and a string stating that.
        if(password! != repeatPassword!){
            return (false, "Passwords do not match")
        }
        
        if((password!.characters.count) < 6){
            return(false, "Password needs to be at least six characters.")
        }
        
        // Populate the locally stored information, and a start to the server information for account creation.
        let storedInfo: [String: String] = ["email": email!.lowercased(), "points": "0"]
        var toServer: [String: String] = ["email": email!.lowercased(), "password": password!]

        // If the phone argument was not empty, add an entry for phone number
        if(phone != ""){
            toServer["phone"] = phone
        }
        
        // If the address argument was not empty, add an entry for the address.
        if(address != ""){
            toServer["address"] = address
        }
        
        let webCallController = WebCallController()
        let result = webCallController.createNewUser(userDict: toServer)
        if(result.0){
            return (!result.0, result.1)
        }
        //Set the defaults item matching key of email lowercased to be
        //the dictionary provided.
        defaults.setValue(storedInfo, forKey: email!.lowercased())
        
        //Makes the user login
        self.email = email!.lowercased()
        self.points = 0
        
        //Successfully created account, so return true, and the empty string
        return (true, "")
    }
    
    
    // This function retrieves the dictionary for the currently logged in user, then updates the stored password (if changed)
    // The password storage will be removed upon server, as such, the server code exists, to create the dictionary to send
    // However at this time it is not used.
    func editAccount(email: String!, currentPassword: String!, password: String!, repeatPassword: String!, phone: String!, address: String!) -> (Bool, String){
        
        //Read in the dictionary for the current user from storage in UserDefaults.
        var toServer = [String: String]()
        
        //if(email == "" || currentPassword == ""){
        //    return (false, "Email and current password are required")
        //}
        
        toServer["current_password"] = currentPassword
        // If the user did not leave the password field blank.
        if(password != ""){
            //If their password does not match the password repetition, return an error
            if(password != repeatPassword){
                return (false, "Passwords do not match")
            }
            // Populate a locally stored dictionary entry and to server dictionary entry with this new password.
            toServer["password"] = password
            toServer["password_confirmation"] = repeatPassword
        }
        else{
            toServer["password"] = currentPassword
            toServer["repeatPassword"] = currentPassword
        }
        
        // If the phone entry is not empty, add its updated info to the dictionary.
        if(phone != ""){
            toServer["phone"] = phone
        }
        
        //If the address entry is not empty, add its updated info to the dictionary.
        if(address != ""){
            toServer["address"] = address
        }
        
        print("LOOK HERE: \n")
        print(toServer)
        
        // Create the Web call controller then make the edit web call
        let webCallController = WebCallController()
        let result = webCallController.editUser(userDict: toServer)
        // If there was an error returned from the call, return the failure and message
        if(result.0){
            return (!result.0, result.1)
        }
        
        // Now store the information again for the user, as it has been updated.
        // Synchronize to force the data to be recognized as updated, then return success.
        return (true, "")
    }
    
    
    func editPassword(currentPassword: String!, password: String!, repeatPassword: String!)->(Bool, String){
        //Read in the dictionary for the current user from storage in UserDefaults.
        var toServer = [String: String]()
        
        toServer["current_password"] = currentPassword

        toServer["password"] = password
        toServer["password_confirmation"] = repeatPassword
        
        print("LOOK HERE: ")
        print(toServer)
        
        // Create the Web call controller then make the edit web call
        let webCallController = WebCallController()
        let result = webCallController.editUser(userDict: toServer)
        // If there was an error returned from the call, return the failure and message
        print("RESULT", result.0)
        if(result.0){
            return (!result.0, result.1)
        }
        return(true, "")
    }
    
    func editPhone(phone: String!, currentPassword: String!)->(Bool, String){
        var toServer = [String: String]()
        toServer["current_password"] = currentPassword
        toServer["phone"] = phone
        print("LOOK HERE: ")
        print(toServer)
        
        // Create the Web call controller then make the edit web call
        let webCallController = WebCallController()
        let result = webCallController.editUser(userDict: toServer)
        // If there was an error returned from the call, return the failure and message
        print("RESULT FROM SERVER", result.0)
        if(result.0){
            return (!result.0, result.1)
        }
        return(true, "")
    }
    
    
    func editAddress(address: String!, currentPassword: String!)->(Bool, String){
        var toServer = [String: String]()
        toServer["current_password"] = currentPassword
        toServer["address"] = address
        print("LOOK HERE: ")
        print(toServer)
        
        // Create the Web call controller then make the edit web call
        let webCallController = WebCallController()
        let result = webCallController.editUser(userDict: toServer)
        // If there was an error returned from the call, return the failure and message
        print("RESULT", result.0)
        if(result.0){
            return (!result.0, result.1)
        }
        return(true, "")
    }
    
    /********* Points Functions *********/
    
    // Currently grabbing information from the server about points
    func updatePoints() -> String {
        
        let webCallController = WebCallController()
        webCallController.getUserPoints { (isError, errorMessage, userPoints) in
            //if the points were not null, set the points to the value retrieved.
            if(!isError){
                self.points = Int(Float(userPoints!)!)
            }
            else{
                print("Error in updatePoints: " + String(errorMessage))
                self.points = 2
            }
        }
        return String(describing: self.points!)
    }
    
    /*
    //grabs the user orders
    func updateRewards() {
     
        let webController = WebCallController()
        
        webController.webCall(urlToCall: SERVER_HOST_URL + "/beacons.json") { (orderJson) in
            // If the order list was returned correctly, pass it to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let beaconList = beaconJson["beacons"] as? Array<Dictionary<String, Any>>{
                callback((false, "No error detected.", beaconList))
            } else if let error = beaconJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the order list.", nil))
            }
        }
    }
    */

    
    // Increment points when entering Entry Beacon Region
    func incrementPoints()
    {
        print("Trying to increment points...") //testing
        if(points == nil){
            print("Error incrementing points: points")
            return
        }
        
        let webCallController = WebCallController()
        self.points! += 1
        let data = ["value": self.points!]
        let Data = ["points": data]
        let url = SERVER_HOST_URL + "/points/" + String(describing: userID!) + ".json"
        webCallController.putRequest(urlToCall: url, data: Data) { (JSONresponse) in
            if let error = JSONresponse["error"] as? String {
                print("error incrementing user points!" + error)
            }
            else{
                print("Success incrementing points") //testing
            }
            //now we can do whatever with this data
            
        }
    }
    
    
    func autoLoginUser(email: String, userID: Int?, points: Int?, phoneNumber: String?, address: String?, webToken: String?){
        self.email = email
        self.userID = userID
        self.points = points
        self.phoneNumber = phoneNumber
        self.address = address
        self.webToken = webToken
    }
    
    
    // These are for diplay on the edit account page
    func phoneGetter()->String{
        if let num = phoneNumber {
            return num
        }
        return ""
    }

    func addressGetter()->String{
        if let addr = address {
            return addr
        }
        return ""
    }
    
    func idGetter()->Int{
        if let id = self.userID {
            return id
        }
        return 0
    }
    
    //this is for help, DELETE LATER
    func emailGetter()->String{
        return email
    }
    
    func setPhoneNumber(phoneNumber: String!){
        self.phoneNumber = phoneNumber
    }
    
    func setAddress(address: String!){
        self.address = address
    }
    

    
    
}
