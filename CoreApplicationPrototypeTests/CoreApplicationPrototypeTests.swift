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
        
        var result = user.loginUser(emailField: "edittest@edit.com", passwordField: "password123")
        XCTAssert(result.0)
        XCTAssert(user.loggedIn())
        result = user.logOut()
        XCTAssert(result.0)
        XCTAssertTrue(user.loggedIn() == false)
    }
    
    // Test if the user can change their password then change it back to the original
    // so testUser() can sign in with the same credentials
    func testChangePasswordEditAccount() {
        let user = User(userEmail: "noUser")
        XCTAssertTrue(user.loggedIn() == false)
        
        var result = user.loginUser(emailField: "edittest@edit.com", passwordField: "password123")
        XCTAssert(result.0)
        XCTAssertTrue(user.loggedIn())
        
        result = user.editPassword(currentPassword: "password123", password: "password321", repeatPassword:"password321")
        XCTAssert(result.0)
        
        
        result = user.editPassword(currentPassword: "password321", password: "password123", repeatPassword:"password123")
        XCTAssert(result.0)
        
        result = user.logOut()
        XCTAssertTrue(user.loggedIn() == false)

    }
    
    func testChangePhoneNumberEditAccount() {
        let user = User(userEmail: "noUser")
        XCTAssertTrue(user.loggedIn() == false)
        
        var result = user.loginUser(emailField: "edittest@edit.com", passwordField: "password123")
        XCTAssert(result.0)
        XCTAssertTrue(user.loggedIn())
        
        result = user.editPhone(phone: "1234567890", currentPassword: "password123")
        XCTAssert(result.0)
        
        result = user.logOut()
        XCTAssert(user.loggedIn() == false)
    }
    
    func testChangeAddressEditAccount() {
        let user = User(userEmail: "noUser")
        XCTAssertTrue(user.loggedIn() == false)
        
        var result = user.loginUser(emailField: "edittest@edit.com", passwordField: "password123")
        XCTAssert(result.0)
        XCTAssertTrue(user.loggedIn())
        
        result = user.editAddress(address: "12345 NorthPole Ave., North Pole, North 00000", currentPassword: "password123")
        XCTAssert(result.0)
        
        result = user.logOut()
        XCTAssert(user.loggedIn() == false)
    }
}
