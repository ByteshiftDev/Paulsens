//
//  AboutViewController.swift
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
 Displays desctiption about Paulsens. Has external links that takes User to
 Paulsen's website, shows directions, and calls Paulsen's contact number.
 Uses alerts to confirm transferring to safari, phone, and maps.
*/

import UIKit
import MapKit

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutTextView: UITextView!
    var newLine = "\n\n"
    
    /*
        You change change these Strings here as needed.
    */
    var paulsensPhone = "(503)287-1163"
    var paulsensWebsite = "https://www.paulsenspharmacy.com"
    var paulsensAddress = "4246 NE Sandy Blvd\nPortland, OR 97213"
    var paulsensHours = "Monday - Friday 9:00am - 6:30pm\nSaturday 10:00am - 2:00pm"
    var paulsensAboutMessage = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

    
    // Display map directions
    func map() {
        // Destination Coordinates
        let latitude:  CLLocationDegrees = 45.536317
        let longitude: CLLocationDegrees = -122.619141
        
        let regionDistance: CLLocationDistance = 1000
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMakeWithDistance(center, regionDistance, regionDistance)
        
        // How the map appears
        let option = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        
        // Place map marker on location
        let placemark = MKPlacemark(coordinate: center)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "Paulsen's Pharmacy"
        mapItem.openInMaps(launchOptions: option)
    }
  
    // Create confirmation alert function
    func createAlert(title: String, message: String, action: UIAlertAction){
        
        // Alert style confirmation
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Handler used to transition to other code, cancel confirmation
        let noButton  = UIAlertAction(title: "NO",  style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(action)     // Add YES button to Alert controller
        alert.addAction(noButton)   // Add NO  button to Alert controller
        
        // Completion: do something after alert is displayed
        present(alert, animated: true, completion: nil)  // Display Alert
    }
    
    // Safari Transfer confirmation
    @IBAction func url() {
        let inputTitle   = "WEBSITE TRANSFER"
        let inputMessage = "Do you want to open this website in Safari?"
        
        let link = "https://www.paulsenspharmacy.com"
        // Action Handler to open URL
        let yesButton = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string: link)! as URL)
            })
        
        createAlert(title: inputTitle, message: inputMessage, action: yesButton)
    }
    
    // Map Transfer confirmation
    @IBAction func address() {
        let inputTitle   = "MAP TRANSFER"
        let inputMessage = "Do you want to open this address in Maps?"
        
        // Open Apple Maps to show directions
        let yesButton = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
           self.map()
        })

        createAlert(title: inputTitle, message: inputMessage, action: yesButton)
    }
    
    // Phone Transfer confirmation
    @IBAction func phone() {
        let inputTitle   = "PHONE TRANSFER"
        let inputMessage = "Do you want to call this number?"
        
        // Call number in "phone"
        let phone = "TEL://5032871163"
        let yesButton = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string: phone)! as URL)
        })
        
        createAlert(title: inputTitle, message: inputMessage, action: yesButton)
    }
    
    //loads the Strings to the textView
    func loadTextViewData() {
        //detects phone, links, addresses
        aboutTextView.dataDetectorTypes = [UIDataDetectorTypes.phoneNumber,UIDataDetectorTypes.link,UIDataDetectorTypes.address]
        aboutTextView.text = "Paulsen's Pharmacy" + newLine
            + paulsensAboutMessage + newLine
            + paulsensHours + newLine
            + paulsensWebsite + newLine
            + paulsensAddress + newLine
            + paulsensPhone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.automaticallyAdjustsScrollViewInsets = false
        self.aboutTextView.delegate = self
        loadTextViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AboutViewController : UITextViewDelegate {
    
    //this is when a user clicks on a URL.
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == paulsensWebsite {
            url()
        }
        else if URL.absoluteString == "tel:" + paulsensPhone {
            phone()
        }
        else {
            address()
        }
        return false
    }
}
