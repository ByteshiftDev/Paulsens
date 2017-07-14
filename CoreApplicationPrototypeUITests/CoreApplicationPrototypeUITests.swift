//
//  CoreApplicationPrototypeUITests.swift
//  CoreApplicationPrototypeUITests
//
//  Created by Thaddeus Sundin on 11/21/16.
//  Copyright © 2016 InboundRXCapstone. All rights reserved.
//

import XCTest

class CoreApplicationPrototypeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //This function tests out the user capability to log in and 
    //log out. Want to log in and log out in one function due to 
    //persistent data
    func testLogInLogOut(){
        
        let app = XCUIApplication()
        let itemButton = app.navigationBars["Home"].buttons["Item"]
        itemButton.tap()
        
        let logInButton = app.buttons["Log In"]
        logInButton.tap()
    
        
        let emailAddressTextField = app.textFields["email address"]
        emailAddressTextField.tap()
        emailAddressTextField.typeText("edittest@edit.com")
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password123")
        
        app.switches["0"].tap()
        app.switches["1"].tap()
        logInButton.tap()
        itemButton.tap()
        app.buttons["Log Out"].tap()
        
    }
    
    
    
    // Test whether a user rushing to the login page can login
    // while the login page is pulling from the server
    func testFastLoginInvalid() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Item"].tap()
        app.buttons["Log In"].tap()
        let emailTextField = app.textFields["email address"]
        let passwordTextField = app.secureTextFields["password"]
        emailTextField.tap()
        emailTextField.typeText("whargarbl")
        passwordTextField.tap()
        passwordTextField.typeText("whargarbl")
        app.buttons["Log In"].tap()
        XCTAssert(app.alerts["Error"].exists)
    }
    
    
    //Test out the setting page, So far this is only a switch for notification, and the labels involved.  Login tests the create
    // and edit button for validity.
    func testSettings(){
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Item"].tap()

    }
    
    
    //Tests the tab bar, to make sure the correct view is showing up to the 
    //corresponding bar button, needs assertions
    func testTabBar(){
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let aboutButton = tabBarsQuery.buttons["About"]
        aboutButton.tap()
        
        let historyButton = tabBarsQuery.buttons["History"]
        historyButton.tap()
        tabBarsQuery.buttons["Rewards"].tap()
        app.alerts["Error"].buttons["Cancel"].tap()
        tabBarsQuery.buttons["Home"].tap()
        aboutButton.tap()
        historyButton.tap()

    }
    
    //THis test goes to history and back to home, and then back to history again
    func testHistory() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let historyButton = tabBarsQuery.buttons["History"]
        historyButton.tap()
        tabBarsQuery.buttons["Home"].tap()
        historyButton.tap()
        
    }
    
    
    //This test is just scrolling back and forth with the daily deals
    func testDailyDeals(){
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        let image = app.collectionViews.cells.otherElements.children(matching: .image).element
        image.tap()
        
        let xButton = app.buttons["[X]"]
        xButton.tap()
        image.swipeLeft()
        image.tap()
        xButton.tap()
        image.swipeRight()
        
        
        
    }
    

    
    //This test is the user going paulsen's website through the about page
    func testAboutWeb(){
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        app.tabBars.buttons["About"].tap()
        
        let httpsWwwPaulsenspharmacyComTextView = app.textViews.containing(.link, identifier:"https://www.paulsenspharmacy.com").element
        //XCTAssert(httpsWwwPaulsenspharmacyComTextView.)
        let window = app.windows.element(boundBy: 0)
        XCTAssert(window.frame.contains(httpsWwwPaulsenspharmacyComTextView.frame))
        httpsWwwPaulsenspharmacyComTextView.swipeUp()
        httpsWwwPaulsenspharmacyComTextView.tap()
        
        let websiteTransferAlert = app.alerts["WEBSITE TRANSFER"]
        XCTAssert(app.alerts["WEBSITE TRANSFER"].exists)
        websiteTransferAlert.buttons["NO"].tap()
        httpsWwwPaulsenspharmacyComTextView.tap()
        websiteTransferAlert.buttons["YES"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        app.statusBars.buttons["Return to CoreApplicationPrototype"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        
        
        /*
        let app = XCUIApplication()
        app.tabBars.buttons["About"].tap()
        
        let httpsWwwPaulsenspharmacyComTextView = app.textViews.containing(.link, identifier:"https://www.paulsenspharmacy.com").element
        httpsWwwPaulsenspharmacyComTextView.tap()
        
        let websiteTransferAlert = app.alerts["WEBSITE TRANSFER"]
        XCTAssert(app.alerts["WEBSITE TRANSFER"].exists)
        websiteTransferAlert.buttons["NO"].tap()
        httpsWwwPaulsenspharmacyComTextView.tap()
        websiteTransferAlert.buttons["YES"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        app.statusBars.buttons["Return to CoreApplicationPrototype"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        */

        
    }
    
    
    //This is the user clicking on the address in the about page
    func testAboutMap(){
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["About"].tap()
        
        let httpsWwwPaulsenspharmacyComTextView = app.textViews.containing(.link, identifier:"https://www.paulsenspharmacy.com").element
        httpsWwwPaulsenspharmacyComTextView.tap()
        
        let mapTransferAlert = app.alerts["MAP TRANSFER"]
        XCTAssert(app.alerts["MAP TRANSFER"].exists)
        mapTransferAlert.buttons["NO"].tap()
        httpsWwwPaulsenspharmacyComTextView.tap()
        XCTAssert(app.alerts["MAP TRANSFER"].exists)
        mapTransferAlert.buttons["YES"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        app.alerts["Allow “Maps” to access your location while you use the app?"].buttons["Allow"].tap()
        app.statusBars.buttons["Return to CoreApplicationPrototype"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        tabBarsQuery.buttons["Home"].tap()
        
    }
    
    func testAboutMap2(){
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        app.tabBars.buttons["About"].tap()
        
        let httpsWwwPaulsenspharmacyComTextView = app.textViews.containing(.link, identifier:"https://www.paulsenspharmacy.com").element
        httpsWwwPaulsenspharmacyComTextView.tap()
        httpsWwwPaulsenspharmacyComTextView.tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        app.otherElements["PlaceCardViewController"].children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        
    }
    
    
    //This test is for when the user clicks and close a daily deal
    func DailyDealClick(){
        let app = XCUIApplication()
        let image = app.collectionViews.images["640x360_advil"]
        image.swipeLeft()
        image.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .textView).element.tap()
        app.staticTexts["Price: $57"].tap()
        
        let xButton = app.buttons["[X]"]
        xButton.tap()
        image.swipeLeft()
        image.tap()
        xButton.tap()
        
    }
    
    
    //Checks the reward button, when a user is not logged in, to 
    //reject the user from two different location of the app
    func testNotLoggedInUserRewardsCheck(){
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let rewardsButton = tabBarsQuery.buttons["Rewards"]
        rewardsButton.tap()
        tabBarsQuery.buttons["Home"].tap()
        app.navigationBars["Home"].buttons["Item"].tap()
        rewardsButton.tap()
        app.alerts["Error"].buttons["Cancel"].tap()
        
    }
    
    
    //CLicking the setting button and back to home
    func testSettingButton(){
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Item"].tap()
        app.navigationBars["CoreApplicationPrototype.SettingsView"].buttons["Home"].tap()
        
    }
    
}
