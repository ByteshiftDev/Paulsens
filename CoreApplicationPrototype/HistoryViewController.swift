//
//  HistoryViewController.swift
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
 Holds the data for what a Historical Event needs:
 year, image, title, description.
 
 Grabs data from the web server abd stores them in a 
 expandable table view.
*/

import UIKit

// Global Struct Event Custom Cell
struct Event  {
    let year  : String!  // Year the event occurred
    let image : UIImage! // Image depicting event
    let title : String!
    let des   : String!
    
    init(year: String, image: UIImage, title: String, des: String) {
        self.year = year
        self.image = image
        self.title = title
        self.des = des
    }
}

class HistoryViewController: UITableViewController {
    
    @IBOutlet var historyTableView: UITableView!
    
    
    let cellID = "cell"                      // Cell identifier for dequeue
    var selectedIndexPath  = -1              // -1 means no rows exist in section
    private var eventArray = [Event]()       // Array of events for cells
    
    let webCallController = WebCallController()
    // Load data into table view cells
    
    func loadHistory() {
        //server call
        webCallController.getHistoricalEventList { (isError, errorMessage, historicalEventsList) in
            if(isError){
                // Make sure the UI update occurs on the MAIN thread
                DispatchQueue.main.async(execute: { () -> Void in
                    // Check the appdelegate to see if we are already displaying a warning, if so, don't display this one
                    // This is to avoid one error such as internet connection failed from causing multiple errors
                    // When the tabbarController attempts to load.
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let dispAlert = appDelegate.isDisplayingPopup
                    if(!dispAlert){
                        appDelegate.isDisplayingPopup = true
                        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle:UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated:true, completion: { () in
                            appDelegate.isDisplayingPopup = false })
                    }
                })
                return
            } else {
                var newEvents = [Event]()
                var i = 0
                for dict in historicalEventsList! {
                    print("Event \(i):")
                    print(dict)
                    print("\n---\n")
                    newEvents.append(Event(year: dict["date"] as! String, image: #imageLiteral(resourceName: "Image0"), title: dict["title"] as! String, des: dict["description"] as! String))
                    i = i+1
                }

                self.eventArray = newEvents
                // Make sure the UI update occurs on the MAIN thread
                DispatchQueue.main.async(execute: { () -> Void in
                    if self.eventArray.count > 0 {
                        self.historyTableView.reloadData()
                        self.historyTableView.backgroundView!.isHidden = true
                    }
                    else {
                        self.historyTableView.backgroundView!.isHidden = false
                    }
                })
                
            }
        }
    }
    
    func loadData() {
        loadHistory()
        self.refreshControl!.endRefreshing()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.historyTableView.backgroundView = UILabel()
        let bgView = self.historyTableView.backgroundView as! UILabel
        
        bgView.backgroundColor = UIColor.clear
        bgView.textColor = UIColor.white
        bgView.textAlignment = NSTextAlignment.center
        bgView.numberOfLines = 0
        bgView.adjustsFontSizeToFitWidth = true
        bgView.text = "It appears nothing is loaded"
        
        self.historyTableView!.alwaysBounceVertical = true
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        self.historyTableView.addSubview(self.refreshControl!)
        
        loadHistory()
        
        tableView.tableFooterView = UIView() // Create blank rows after filled in cells
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.historyTableView.reloadData()
    }
    
    // CONFIGURING A TABLE VIEW (REQUIRED)
    // Tells the data source to return the number of rows in a given section of a table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    // CONFIGURING A TABLE VIEW (REQUIRED)
    // Asks the data source for a cell to insert in a particular location of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let cell = dequeued as! HistoryTableViewCell             // Set cell as a custom cell
        
        cell.yearLabel.text    = eventArray[indexPath.row].year  // Set label in custom cell
        cell.historyView.image = eventArray[indexPath.row].image // Set image in custom cell
        cell.titleLabel.text = eventArray[indexPath.row].title
        cell.desLabel.text = eventArray[indexPath.row].des
        
        return cell
    }
    
    
    // MANAGING SELECTIONS
    // Tells the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedIndexPath == indexPath.row){  // If row is already selected
            selectedIndexPath = -1                // Don't expand/shrink
        }
        else {
            selectedIndexPath = indexPath.row     // Expand row
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    // CONFIGURING ROWS FOR THE TABLE VIEW
    // Asks the delegate for the height to use for a row in a specified location.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == selectedIndexPath {
            return HistoryTableViewCell.expandedHeight // When cell is selected, it is expanded
        } else {
            return HistoryTableViewCell.defaultHeight  // When cell is not selected, it is collapsed
        }
    }
}
