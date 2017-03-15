//
//  WebCallController.swift
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
 Makes webcalls to the server. Creates dictionary array based on the JSON data received.
 Displays error if JSON data is invalid.
 Type of webcalls: beacons, history, user info, deals, rewards
*/

/*
 Important note about making HTTP web calls:
 Must edit info.plist
 Add the key "App Transport Security Settings" of type Dictionary
 Under this key, add the subkey "Allow Arbitrary Loads" of type Boolean and set it to "YES"
 (If this still doesn't work, clean the project (Shift+Command+k))
*/

class WebCallController {
    
    // --------------------------
    // ----- Core functions -----
    // --------------------------
    
    // Make a call to a web address to retrieve some data
    // Returns an array of dictionaries via a completion handler
    func webCall(urlToCall: String, callback: @escaping (Dictionary<String, AnyObject>) -> ()) {
        let url = URL(string: urlToCall)
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            
            // If there was an error, print it to the console and return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                return
            }
            
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved:\n")
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                // let dictionaryArray = json as! [[String: AnyObject]]
                let dictionaryArray = json as! Dictionary<String, AnyObject>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
            }
            
            }.resume()
    }
    
    
    // Make a call to the web server to sign in
    // Callback function is run synchronously after this function
    func webLogIn(loginCredentials: Dictionary<String, Any>, callback: @escaping (Dictionary<String, AnyObject>) -> ()) {
        // Prepare json data
        let json = loginCredentials
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // Create post request
        let url = URL(string: "http://paulsens-beacon.herokuapp.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Insert a header specifying that json data is in the request
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // Insert a header to specify that we want a JSON formatted response
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        // Insert the actual json data into the request
        request.httpBody = jsonData
        
        //Create a semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // If there was an error, print it to the console and return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                return
            }
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved:\n")
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                // let dictionaryArray = json as! [[String: AnyObject]]
                let dictionaryArray = json as! Dictionary<String, AnyObject>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
            }
            
            // Signal the semaphore
            semaphore.signal()
        }
        // Let the dataTask resume (run the urlsession request, essentially)
        task.resume()
        // Wait on the semaphore within the callback function
        semaphore.wait()
    }
    
    
    // Make a POST request to the web server
    // Callback function is run synchronously after this function
    func postRequest(urlToCall: String, data: Dictionary<String, Any>, callback: @escaping (Dictionary<String, AnyObject>) -> ()) {
        // Convert data into JSON format
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        // Create POST request
        let url = URL(string: urlToCall)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Insert JSON header and JSON data
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // Insert a header to specify that we want a JSON formatted response
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // If there was an error, print it to the console and return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                return
            }
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved from POST:\n")
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                // let dictionaryArray = json as! [[String: AnyObject]]
                let dictionaryArray = json as! Dictionary<String, AnyObject>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
            }
            // Signal the semaphore
            semaphore.signal()
        }
        // Let the dataTask resume (run the urlsession request, essentially)
        task.resume()
        // Wait on the semaphore within the callback function
        semaphore.wait()
    }
    
    
    // Make a DELETE request to the web server
    // Callback function is run synchronously after this function
    func deleteRequest(urlToCall: String) {
        
        // Create DELETE request
        let url = URL(string: urlToCall)!
        var request = URLRequest(url: url)
        // Insert a header to specify that we want a JSON formatted response
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "DELETE"
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // If there was an error, print it to the console and return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                return
            }
            // Otherwise, print the data to the console
            //            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("\n\nDataRecieved from DELETE:\n")
            //            print(str!)
            //            print("\n-----\n")
            
            // Signal the semaphore
            semaphore.signal()
        }
        // Let the dataTask resume (run the urlsession request, essentially)
        task.resume()
        // Wait on the semaphore within the callback function
        semaphore.wait()
    }
    
    
    // Make a PATCH request to the web server
    // Callback function is run synchronously after this function
    func patchRequest(urlToCall: String, data: Dictionary<String, Any>, callback: @escaping (Dictionary<String, AnyObject>) -> ()) {
        // Convert data into JSON format
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        // Create PATCH request
        let url = URL(string: urlToCall)!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Insert JSON header and JSON data
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // Insert a header to specify that we want a JSON formatted response
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // If there was an error, print it to the console and return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                return
            }
            // Otherwise, print the data to the console
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("\n\nDataRecieved from PATCH:\n")
//            print(str!)
//            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                // let dictionaryArray = json as! [[String: AnyObject]]
                let dictionaryArray = json as! Dictionary<String, AnyObject>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
            }
            // Signal the semaphore
            semaphore.signal()
        }
        // Let the dataTask resume (run the urlsession request, essentially)
        task.resume()
        // Wait on the semaphore within the callback function
        semaphore.wait()
    }
    
    
    // ---------------------------------------------------------------
    // ----- Functions to retrieve specific data from web server -----
    // ---------------------------------------------------------------
    
    
    // Print the list of beacons to the console
    func printBeaconList() {
        // Test logging in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                print("There was an error: " + error)
            }
            
            self.webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/beacons.json") { (dictionaryArray) in
                var i = 1
                let beaconsList = dictionaryArray["beacons"] as? Array<Dictionary<String, AnyObject>>
                for dictionary in beaconsList! {
                    print("Dictionary \(i):\n")
                    print(dictionary)
                    print("\n-----\n")
                    i = i+1
                }
            }
        }
    }
    
    
    // Returns an array of dictionaries, where each dictionary represents a beacon in the web server
    // Returns nil if the web server call does not correctly return data
    // NOTE: Returns data via closure
    func getBeaconList(callback: @escaping ((Bool, String, Array<Dictionary<String, AnyObject>>?)) -> ()) {
        // Log in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) { (dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
        
        
        // Call the web server to return the beacon list
        self.webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/beacons.json") { (beaconJson) in
            // If the beacon list was returned correctly, pass it to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let beaconList = beaconJson["beacons"] as? Array<Dictionary<String, AnyObject>>{
                callback((false, "No error detected.", beaconList))
            } else if let error = beaconJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the beacon list.", nil))
            }
        }
        
    }
    
    
    // Returns an array of dictionaries, where each dictionary represents a historical event in the web server
    // Returns nil if the web server call does not correctly return data
    // NOTE: Returns data via closure
    func getHistoricalEventList(callback: @escaping ((Bool, String, Array<Dictionary<String, AnyObject>>?)) -> ()) {
        // Log in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
        // Call web server to return list of historical events
        self.webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/historical_events.json") { (historicalEventsJson) in
            // If the historical event list was returned correctly, pass it to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let historicalEventList = historicalEventsJson["historical_events"] as? Array<Dictionary<String, AnyObject>>{
                callback((false, "No error detected.", historicalEventList))
            } else if let error = historicalEventsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the list of historical events.", nil))
            }
        }
    }
    
    
    // Returns an array of dictionaries, where each dictionary represents a reward in the promotions table on the web server
    // Returns nil if the web server call does not correctly return data
    // NOTE: Returns data via closure
    func getRewardsList(callback: @escaping ((Bool, String, Array<Dictionary<String, AnyObject>>?)) -> ()) {
        // Log in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
        
        // Call web server to return rewards list
        self.webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/promotions.json") { (promotionsJson) in
            // If the promotions list was returned correctly, extract all rewards and pass them to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let promotionsList = promotionsJson["promotions"] as? Array<Dictionary<String, AnyObject>> {
                var rewardsList = [[String: AnyObject]]()
                for promotion in promotionsList {
                    if(promotion["daily_deal"] as! Bool == false) {
                        rewardsList.append(promotion)
                    }
                }
                callback((false, "No error detected.", rewardsList))
            } else if let error = promotionsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the list of historical events.", nil))
            }
        }
    }
    
    
    // Returns an array of dictionaries, where each dictionary represents a daily deal in the promotions table on the web server
    // Returns nil if the web server call does not correctly return data
    // NOTE: Returns data via closure
    func getDailyDealList(callback: @escaping ((Bool, String, Array<Dictionary<String, AnyObject>>?)) -> ()) {
        // Log in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
        
        // Call web server to return daily deals list
        self.webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/promotions.json") { (promotionsJson) in
            // If the promotions list was returned correctly, extract all daily deals and pass them to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let promotionsList = promotionsJson["promotions"] as? Array<Dictionary<String, AnyObject>> {
                var dailyDealList = [[String: AnyObject]]()
                for promotion in promotionsList {
                    if(promotion["daily_deal"] as! Bool == true) {
                        dailyDealList.append(promotion)
                    }
                }
                callback((false, "No error detected.", dailyDealList))
            } else if let error = promotionsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the list of historical events.", nil))
            }
        }
    }
    
    
    // Add a new user to the web server
    // Expected dictionary formats:
    // ["email": emailString, "password": passwordString]
    // ["email": emailString, "password": passwordString, "address": addressString]
    // ["email": emailString, "password": passwordString, "phone": phoneString]
    // ["email": emailString, "password": passwordString, "address": addressString, "phone": phoneString]
    func createNewUser(userDict: Dictionary<String, String>) -> (isError: Bool, error: String) {
        // Create a new dictionary in the format which the web server expects
        // ["user": dictionaryWithUserInfo]
        let data = ["user": userDict]
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        //Call the POST function to send data to web server and catch the response
        var toReturn: (Bool, String) = (true, "There was an error catching the response from the web server.")
        postRequest(urlToCall: "http://paulsens-beacon.herokuapp.com/account", data: data) {(dataJson) in
            if let error = dataJson["error"] as? String {
                toReturn = (true, error)
            } else {
                toReturn = (false, "No error detected")
            }
            // Signal the semaphore
            semaphore.signal()
        }
        // Wait on the semaphore within the callback function
        semaphore.wait()
        return toReturn
    }
    
    
    // Log a user in to the web server
    // Expected dictionary formats:
    // ["email": emailString, "password": passwordString]
    func userLogIn(userDict: Dictionary<String, String>) -> (isError: Bool, error: String) {
        // Create a new dictionary in the format which the web server expects
        // ["user": dictionaryWithUserInfo]
        let data = ["user": userDict]
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Call the weblogin function to log the user in and catch the response
        var toReturn: (Bool, String) = (true, "There was an error catching the response from the web server.")
        webLogIn(loginCredentials: data) { (dataJson) in
            if let error = dataJson["error"] as? String {
                toReturn = (true, error)
            } else {
                toReturn = (false, "No error detected")
            }
            // Signal the semaphore
            semaphore.signal()
        }
        // Wait on the semaphore within the callback function
        semaphore.wait()
        return toReturn
    }
    
    // Log the current user out
    func userLogOut() {
        deleteRequest(urlToCall: "http://paulsens-beacon.herokuapp.com/logout")
    }
    
    
    // Returns a string representing the point value of the currently logged in user
    // Returns nil if point value cannot be extracted from the web call
    func getUserPoints(callback: @escaping ((Bool, String, String?)) -> ()) {
        // Call web server to return the user's points
        webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/account/points.json") { (pointsJson) in
            if let points = pointsJson["value"] as? String {
                callback((false, "No error.", points))
            }
            else if let error = pointsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the user's point value.", nil))
            }
        }
    }
    
    
    // Edit an existing user's info
    // Expected dictionary formats:
    // ["email": emailString, "password": edited_passwordString, "password_confirmation": edited_passwordString]
    // ["email": emailString, "password": edited_passwordString, "password_confirmation": edited_passwordString, "address": edited_addressString]
    // ["email": emailString, "password": edited_passwordString, "password_confirmation": edited_passwordString, "phone": edited_phoneString]
    // ["email": emailString, "password": edited_passwordString, "password_confirmation": edited_passwordString, "address": edited_addressString, "phone": edited_phoneString]
    func editUser(userDict: Dictionary<String, String>) -> (isError: Bool, error: String){
        // Create a new dictionary in the format which the web server expects
        // ["user": dictionaryWithUserInfo]
        let data = ["user": userDict]
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Call the PATCH function to send data to web server telling it to alter that entry in the user table
        // Catch the response
        var toReturn: (Bool, String) = (true, "There was an error catching the response from the web server.")
        patchRequest(urlToCall: "http://paulsens-beacon.herokuapp.com/account", data: data) { (dataJson) in
            if let error = dataJson["error"] as? String {
                toReturn = (true, error)
            } else {
                toReturn = (false, "No error detected")
            }
            // Signal the semaphore
            semaphore.signal()
        }
        // Wait on the semaphore within the callback function
        semaphore.wait()
        return toReturn
    }
}






