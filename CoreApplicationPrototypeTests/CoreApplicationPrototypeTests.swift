//
//  CoreApplicationPrototypeTests.swift
//  CoreApplicationPrototypeTests
//
//  Created by Thaddeus Sundin on 11/21/16.
//  Copyright © 2016 InboundRXCapstone. All rights reserved.
//

import XCTest
@testable import CoreApplicationPrototype

class CoreApplicationPrototypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    // Test the webCallController daily Deals web call
    // First set an expectation, then, make the callback function call
    // Inside do any tests desired, (here make sure if error we get no list)
    // and an error message.  If no error, make sure any deals contained
    // are actually daily deals, then fulfill the set expectation
    // so it doesnt time out.
    func testDealsWebCall () {
        let exp = expectation(description: "getDailyDeals")
        let webCallController = WebCallController()
        webCallController.getDailyDealList(callback: { (isError, errorMessage, dailyDealsList) in
            if isError {
                XCTAssertNotNil(errorMessage)
                XCTAssertNil(dailyDealsList)
            } else {
                for dict in dailyDealsList! {
                    XCTAssert(dict["daily_deal"] as! Bool)
                }
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    // Test the webCallController Rewards web call
    // First set an expectation, then, make the callback function call
    // Inside do any tests desired, (here make sure if error we get no list)
    // and an error message.  If no error, make sure any deals contained
    // are actually rewards.  Once this is done, fulfill the expectation
    // so it doesn't time out and fail
    func testRewardsWebCall () {
        let exp = expectation(description: "getRewards")
        let webCallController = WebCallController()
        webCallController.getRewardsList(callback: { (isError, errorMessage, rewardsList) in
            if isError {
                XCTAssertNotNil(errorMessage)
                XCTAssertNil(rewardsList)
            } else {
                for dict in rewardsList! {
                    XCTAssertFalse(dict["daily_deal"] as! Bool)
                }
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    
    // Test the webCallController getHistoryList web call
    // First set an expectation, then, make the callback function call
    // Inside do any tests desired, (here make sure if error we get no list)
    // and an error message.  If no error, make sure the list is not empty
    // then fulfill the set expectation so it doesnt time out.
    func testHistoryWebCall () {
        let exp = expectation(description: "getHistory")
        let webCallController = WebCallController()
        webCallController.getHistoricalEventList(callback: { (isError, errorMessage, historicalEvents) in
            if isError {
                XCTAssertNotNil(errorMessage)
                XCTAssertNil(historicalEvents)
            } else {
                XCTAssertNotNil(historicalEvents)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    // Test the webCallController Beacons web call
    // First set an expectation, then, make the callback function call
    // Inside do any tests desired, (here make sure if error we get no list)
    // and an error message.  If no error, make certain there is in fact a list
    func testBeaconsWebCall () {
        let exp = expectation(description: "getBeacons")
        let webCallController = WebCallController()
        webCallController.getBeaconList(callback: { (isError, errorMessage, beaconList) in
            if isError {
                XCTAssertNotNil(errorMessage)
                XCTAssertNil(beaconList)
            } else {
                XCTAssertNotNil(beaconList)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    // Unit test the user login and logout functions.  This does
    // Test the webCallController function as well.
    func testUser() {
        let user = User(userEmail: "noUser")
        XCTAssertTrue(user.loggedIn() == false)
        var result = user.loginUser(emailField: "example@example.com", passwordField: "example")
        XCTAssert(result.0)
        XCTAssert(user.loggedIn())
        result = user.logOut()
        XCTAssert(result.0)
        XCTAssertTrue(user.loggedIn() == false)
    }
    
    
    
    // test the functionality of the create account call.  This function attemps 3 creations, all
    // invalid.  the first creates a new user with an existing email, the second creates a user
    // with an invalid email, the final creates a user with an invalid password.
    func testCreateAccount () {
        let webCallController = WebCallController()
        var result = webCallController.createNewUser(userDict: ["email": "example@example.com", "password": "example2"])
        XCTAssert(result.0)
        result = webCallController.createNewUser(userDict: ["email": "example", "password": "password"])
        XCTAssert(result.0)
        result = webCallController.createNewUser(userDict: ["email": "whargarbl@whargarbl.com", "password": "pass"])
        XCTAssert(result.0)
    }
    
    
    // Test the edit account functionality of the web controller using an already created account
    // get a user and webCallController.  Then, login a user whom exists, update their password
    // to the reverse of current, assert the call was successful, then try to login with the old
    // password, which should fail, then try to login with the new password, should succeeed.
    // Reset the password to the original, then repeat that process.  Now, test trying to edit
    // while not logged in, and test trying to edit with mismatched passwords and the wrong current
    // password.  This should fail.  User functions return true if successful, webCall return true
    // if unsuccessful.
    func testEditAccount () {
        let webCallController = WebCallController()
        let user = User(userEmail: "noUser")
        
        var result = user.loginUser(emailField: "capstone@capstone.com", passwordField: "enotspac")
        XCTAssert(result.0)
        XCTAssert(user.loggedIn())
        
        result = webCallController.editUser(userDict: ["email": "capstone@capstone.com", "current_password": "enotspac", "password": "capstone", "password_confirmation": "capstone"])
        XCTAssertFalse(result.0)
        
        result = user.logOut()
        result = user.loginUser(emailField: "capstone@capstone.com", passwordField: "enotspac")
        XCTAssertFalse(result.0)
        XCTAssertFalse(user.loggedIn())
        
        result = user.loginUser(emailField: "capstone@capstone.com", passwordField: "capstone")
        XCTAssert(result.0)
        XCTAssert(user.loggedIn())
        
        result = webCallController.editUser(userDict: ["email": "capstone@capstone.com", "current_password": "capstone", "password": "enotspac", "password_confirmation": "enotspac"])
        XCTAssertFalse(result.0)
        
        result = user.loginUser(emailField: "capstone@capstone.com", passwordField: "capstone")
        XCTAssertFalse(result.0)
        XCTAssertFalse(user.loggedIn())
        
        result = user.loginUser(emailField: "capstone@capstone.com", passwordField: "enotspac")
        XCTAssert(result.0)
        XCTAssert(user.loggedIn())
        
        result = user.logOut()
        XCTAssertFalse(user.loggedIn())
        
        result = webCallController.editUser(userDict: ["email": "capstonasdfae@capstone.com", "current_password": "capstone", "password": "enotspac", "password_confirmation": "enotspac"])
        XCTAssert(result.0)
        
        result = user.loginUser(emailField: "capstone@capstone.com", passwordField: "enotspac")
        
        result = webCallController.editUser(userDict: ["email": "capstone@capstone.com", "current_password": "capstone", "password": "enotsp", "password_confirmation": "etspac"])
        XCTAssert(result.0)


    }
}
