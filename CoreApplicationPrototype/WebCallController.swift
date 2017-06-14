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

import UIKit

// Cache to hold images from web
var imageCache = NSCache<AnyObject, AnyObject>()
var SERVER_HOST_URL = "https://ruby-drakkensaer.c9users.io"
//SERVER_HOST_URL = "http://paulsens-beacon.herokuapp.com"

class WebCallController: URLSession {
    
    // --------------------------
    // ----- Core functions -----
    // --------------------------
    
    // Make a call to a web address to retrieve some data
    // Returns an array of dictionaries via a completion handler
    func webCall(urlToCall: String, callback: @escaping (Dictionary<String, Any>) -> ()) {
        
        /*
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
        */
        
        let url = URL(string: urlToCall)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // Insert a header to specify that we want a JSON formatted response
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        //An the token authorization header
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let user = appDelegate?.user
        if let token = user?.webToken {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            // If there was an error, print it to the console 
            // Then, call the closure with the error and return from the function
            if error != nil {
                print("There was an error!:\n" + urlToCall)
                print(error!)
                callback(["error":error!.localizedDescription])
                return
            }
            
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved:\n" + urlToCall)
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(json)
                let dictionaryArray = json as! Dictionary<String, Any>
                callback(dictionaryArray)
                
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
                callback(["error":jsonError.localizedDescription])
            }
            
            }.resume()
    }
    
    
    // Make a call to the web server to sign in
    // Callback function is run synchronously after this function
    func webLogIn(loginCredentials: Dictionary<String, Any>, callback: @escaping (Dictionary<String, Any>) -> ()) {
        // Prepare json data
        let json = loginCredentials
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // Create post request
        let url = URL(string: SERVER_HOST_URL + "/api/login.json")!
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
            // If there was an error, print it to the console
            // Then, call the closure with the error and signal the semaphore. Then return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                callback(["error":error!.localizedDescription])
                semaphore.signal()
                return
            }
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved From Login:\n")
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dictionaryArray = json as! Dictionary<String, Any>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
                callback(["error":jsonError.localizedDescription])
            }
            
            // Signal the semaphore
            semaphore.signal()
        }
        // Let the dataTask resume (run the urlsession request, essentially)
        task.resume()
        // Wait on the semaphore within the callback function
        semaphore.wait()
    }
    
    
    // Make a PUT request to the web server
    // Callback function is run synchronously after this function
    func putRequest(urlToCall: String, data: Dictionary<String, Any>, callback: @escaping (Dictionary<String, Any>) -> ()) {
        // Convert data into JSON format
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        
        // Create POST request
        let url = URL(string: urlToCall)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        
        //grabbing user token for authorization purposed, and adding it as an 'Authorization' header in the request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        if let token = user.webToken {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
    
        
        print("Trying PUT request with URL: " + urlToCall)
        print("With data: " + data.description)
        print("And token: " + user.webToken!)
        
        
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
                callback(["error":error!.localizedDescription])
                semaphore.signal()
                return
            }
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved from PUT:\n")
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dictionaryArray = json as! Dictionary<String, Any>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
                callback(["error":jsonError.localizedDescription])
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
    func postRequest(urlToCall: String, data: Dictionary<String, Any>, callback: @escaping (Dictionary<String, Any>) -> ()) {
        // Convert data into JSON format
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        // Create POST request
        let url = URL(string: urlToCall)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //grabbing user token for authorization purposed, and adding it as an 'Authorization' header in the request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        if let token = user.webToken {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
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
                callback(["error":error!.localizedDescription])
                semaphore.signal()
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
                let dictionaryArray = json as! Dictionary<String, Any>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
                callback(["error":jsonError.localizedDescription])
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
            // If there was an error, print it to the console
            // Then signal the semaphore and return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                semaphore.signal()
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
    func patchRequest(urlToCall: String, data: Dictionary<String, Any>, callback: @escaping (Dictionary<String, Any>) -> ()) {
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
        
        //An the token authorization header
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //let user = appDelegate?.user
        //if let token = user?.webToken {
        //    request.addValue(token, forHTTPHeaderField: "Authorization")
        //}
        
        //bearer token for test@test.com
    request.addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJwYXNzd29yZCI6InBhc3N3b3JkMTIzIiwiZXhwIjoxNDk1NjcxNjE0fQ.I6Ev6Q8fBRQ7HeNB1Tj8udL2LAwKFdPD1ISQ1LMtqd8", forHTTPHeaderField: "Authorization")
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // If there was an error, print it to the console
            // Then, call the closure with the error and signal the semaphore. Then return from the function
            if error != nil {
                print("There was an error!:\n")
                print(error!)
                callback(["error":error!.localizedDescription])
                semaphore.signal()
                return
            }
            
            
            
            // Otherwise, print the data to the console
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\n\nDataRecieved from PATCH:\n")
            print(str!)
            print("\n-----\n")
            
            // Convert the data recieved into JSON

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dictionaryArray = json as! Dictionary<String, Any>
                callback(dictionaryArray)
            } catch let jsonError {
                print("There was a json error!:\n")
                print(jsonError)
//                let err = jsonError as NSError
//                if(err.code == 3840){
//                    callback(["no":"problems"])
//                } else {
                callback(["error":jsonError.localizedDescription])
//                }
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
        
        /*
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                print("There was an error: " + error)
            }
            
            self.webCall(urlToCall: "http://paulsens-beacon.herokuapp.com/beacons.json") { (dictionaryArray) in
                var i = 1
                let beaconsList = dictionaryArray["beacons"] as? Array<Dictionary<String, Any>>
                for dictionary in beaconsList! {
                    print("Dictionary \(i):\n")
                    print(dictionary)
                    print("\n-----\n")
                    i = i+1
                }
            } */
        }
    
    
    
    func downloadImageFromURL(_ url: String, cell: UICollectionViewCell, indexPath: Int) {
      
      // First try setting the image from the cache
      if let image = imageCache.object(forKey: url as AnyObject) as? UIImage{
        if let Cell = cell as? RewardsCollectionViewCell {
          Cell.productButton.setImage(image, for: UIControlState.normal)
        }
        else if let Cell = cell as? DealsCollectionViewCell {
          Cell.dealsImage.image = image
        }
      }
      
      // If image isn't in cache, call the server
      else {
        let pictureURL = URL(string: url)!
      
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded sample picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            let image = UIImage(data: imageData)
                          
                            imageCache.setObject(image!, forKey: url as AnyObject)
                          
                            if let Cell = cell as? RewardsCollectionViewCell {
                                Cell.productButton.setImage(image, for: UIControlState.normal)
                            }
                            else if let Cell = cell as? DealsCollectionViewCell {
                                Cell.dealsImage.image = image
                            }
                            else {
                                print("Cell Error")
                            }
                            
                        })
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
      }
    }
    
    
    // Returns an array of dictionaries, where each dictionary represents a beacon in the web server
    // Returns nil if the web server call does not correctly return data
    // NOTE: Returns data via closure
    func getBeaconList(callback: @escaping ((Bool, String, Array<Dictionary<String, Any>>?)) -> ()) {
        
        
        
        // Log in
        // Catch an error if it occurs
        /*
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) { (dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
        */
        
        
 
        
        // Call the web server to return the beacon list
        self.webCall(urlToCall: SERVER_HOST_URL + "/beacons.json") { (beaconJson) in
            // If the beacon list was returned correctly, pass it to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let beaconList = beaconJson["beacons"] as? Array<Dictionary<String, Any>>{
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
    func getHistoricalEventList(callback: @escaping ((Bool, String, Array<Dictionary<String, Any>>?)) -> ()) {
        // Log in
        // Catch an error if it occurs
        
        /*
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
 
        */
        
        // Call web server to return list of historical events
        self.webCall(urlToCall: SERVER_HOST_URL + "/historical_events.json") { (historicalEventsJson) in
            // If the historical event list was returned correctly, pass it to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let historicalEventList = historicalEventsJson["historical_events"] as? Array<Dictionary<String, Any>>{
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
    func getRewardsList(callback: @escaping ((Bool, String, Array<Dictionary<String, Any>>?)) -> ()) {
        
        
        /*
        // Log in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
        */
        
        // Call web server to return rewards list
        self.webCall(urlToCall: SERVER_HOST_URL + "/promotions.json") { (promotionsJson) in
            // If the promotions list was returned correctly, extract all rewards and pass them to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let promotionsList = promotionsJson["promotions"] as? Array<Dictionary<String, Any>> {
                var rewardsList = [[String: Any]]()
                for promotion in promotionsList {
                    if(promotion["daily_deal"] as! Bool == false) {
                        rewardsList.append(promotion)
                    }
                }
                callback((false, "No error detected.", rewardsList))
            } else if let error = promotionsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the list of rewards.", nil))
            }
        }
    }
    
    
    // Returns an array of dictionaries, where each dictionary represents a daily deal in the promotions table on the web server
    // Returns nil if the web server call does not correctly return data
    // NOTE: Returns data via closure
    func getDailyDealList(callback: @escaping ((Bool, String, Array<Dictionary<String, Any>>?)) -> ()) {
        
        /*
        // Log in
        // Catch an error if it occurs
        webLogIn(loginCredentials: ["user": ["email": "test@test.com", "password": "password123"]]) {(dataJson) in
            if let error = dataJson["error"] as? String {
                callback((true, error, nil))
            }
        }
 */
        
        // Call web server to return daily deals list
        self.webCall(urlToCall: SERVER_HOST_URL + "/promotions.json") { (promotionsJson) in
            // If the promotions list was returned correctly, extract all daily deals and pass them to the closure
            // Otherwise, retrieve the error message that was passed back from the web server and pass that to the closure
            // If this error message cannot be retrieved, pass into the closure a generic erro message
            if let promotionsList = promotionsJson["promotions"] as? Array<Dictionary<String, Any>> {
                var dailyDealList = [[String: Any]]()
                for promotion in promotionsList {
                    if(promotion["daily_deal"] as! Bool == true) {
                        dailyDealList.append(promotion)
                    }
                }
                callback((false, "No error detected.", dailyDealList))
            } else if let error = promotionsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the list of daily deals.", nil))
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
    func userLogIn(userDict: Dictionary<String, String>) -> (isError: Bool, error: String, response: (Dictionary<String, Any>)?) {
        // Create a new dictionary in the format which the web server expects
        // ["user": dictionaryWithUserInfo]
        let data = ["user": userDict]
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Call the weblogin function to log the user in and catch the response
        var toReturn: (Bool, String, Dictionary<String, Any>?) = (true, "There was an error catching the response from the web server.", nil)
        webLogIn(loginCredentials: data) { (dataJson) in
            if let error = dataJson["error"] as? String {
                toReturn = (true, error, nil)
            } else {
                print("We totally logged in!!")
                print(dataJson)
                toReturn = (false, "No error detected", dataJson)
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
        deleteRequest(urlToCall: SERVER_HOST_URL + "/logout.json")
    }
    
    
    
    // Returns a string representing the point value of the currently logged in user
    // Returns nil if point value cannot be extracted from the web call
    func getUserPoints(callback: @escaping ((Bool, String, String?)) -> ()) {
        // Call web server to return the user's points
        webCall(urlToCall: SERVER_HOST_URL + "/account/points.json") { (pointsJson) in
            if let points = pointsJson["value"] as? Int {
                let stringPoints = String(points)
                callback((false, "No error.", stringPoints))
            }
            else if let error = pointsJson["error"] as? String {
                callback((true, error, nil))
            } else {
                print(pointsJson)
                callback((true, "An unexpected error occured while attempting to get the user's point value.", nil))
            }
        }
    }
    
    // Returns a string representing the point value of the currently logged in user
    // Returns nil if point value cannot be extracted from the web call
    func getUserPhoneAddress(callback: @escaping ((Bool, String, String?)) -> ()) {
        // Call web server to return the user's points
        webCall(urlToCall: SERVER_HOST_URL + "/account/users.json") { (userJson) in
            if let phone = userJson["value"] as? String, let address = userJson["value"] {
                print(phone)
                print(address)
                callback((false, "No error.", phone))
            }
            else if let error = userJson["error"] as? String {
                callback((true, error, nil))
            } else {
                callback((true, "An unexpected error occured while attempting to get the user's phone and address", nil))
            }
        }
    }
    
    //Fetch user rewards
    func fetchRewards() -> [Product]? {
        let url = SERVER_HOST_URL + "/account/rewards.json"
        webCall(urlToCall: url) { (serverResponse) in
            if let error = serverResponse["error"] as? String {
                print("Error with fetching rewards!" + error)
            }
            else {
                print("FetchReward Respons: " + String(describing: serverResponse))
            }
        }
        
        return nil
    }
    
    
    
    //Purchase an item with the given id and price
    func purchaseReward(productID: Int, cost: Int, userID: Int) -> Bool {
        
        print(productID)
        print(cost)
        print(userID)
        
        //create dictionary to pass to PUT call
        var products = ["id": productID]
        products = ["cost": cost]
        var data: [String: Any]
        data = ["user": userID]
        data = ["promotions_attributes": products]
        let realData = ["order": data]
        print(realData)
        let url = SERVER_HOST_URL + "/orders.json"
    
         postRequest(urlToCall: url, data: realData) { (dictionaryResponse) in
            if let error = dictionaryResponse["error"] as? String {
                print("Error with purchase reward request" + error)
            }
            else{
                print("purchase response: " + String(describing: dictionaryResponse))
                
            }
        }
        
        return true
        
    }
    
    
    
    //Redeem an already purchased reward. Web Server should be returning a date as to how long the reward will be active
    func redeemReward() -> Date {
        let url = SERVER_HOST_URL + "/orders.json"
        
        let data = ["key":"Value"]
        
        postRequest(urlToCall: url, data: data) { (dictionaryResponse) in
            if let error = dictionaryResponse["error"] as? String {
                print("Error with purchase reward request" + error)
            }
            else{
                print("purchase response: " + String(describing: dictionaryResponse))
                
            }
        }
        
        return Date()
    }
    
    /*
 func putRequest(urlToCall: String, data: Dictionary<String, Any>, */
    
    // Edit an existing user's info
    // Current password is always send in with the put request
    // with current password anything can be attached to it to make changes to the user account
    //Dictionary<String, Dictionary<String, String>>
    //
    func editUser(userDict: Dictionary<String, String>) -> (isError: Bool, error: String){
        // Create a new dictionary in the format which the web server expects
        // ["user": dictionaryWithUserInfo]
        let data = ["user": userDict]
        
        // Create semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        // Call the PATCH function to send data to web server telling it to alter that entry in the user table
        // Catch the response
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        var toReturn: (Bool, String) = (true, "There was an error catching the response from the web server.")
        putRequest(urlToCall: SERVER_HOST_URL + "/users/" + String(user.idGetter()) + ".json", data: data) { (dataJson) in
            
            if let error = dataJson["errors"] as? Dictionary<String, [String]>{
                print(error)
                for (_, element) in error{
                    for elem in element{
                        toReturn = (true, elem)
                    }
                }
               // toReturn = (true, error)
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
