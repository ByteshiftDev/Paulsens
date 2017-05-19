//
//  WalletViewController.swift
//  CoreApplicationPrototype
//
//  Created by Paul on 4/14/17.
//  Copyright © 2017 InboundRXCapstone. All rights reserved.
//

import UIKit

struct Reward{
    let title : String!
    let des   : String!
    
    init(title: String, des: String){
        self.title = title
        self.des = des
    }
}




class WalletViewController: UITableViewController{
    
    @IBOutlet var walletTableView: UITableView!
    
    let cellID = "WalletCell"
    var selectedIndexPath = -1
    private var rewardArray = [Reward]()
    //var wallet = [Reward]()

    @IBAction func useReward(_ sender: UIButton) {
        
        print("LOOK HERE")
        createAlert(title: "REDEEMING REWARD", message: "Are you sure you want to redeem your reward?")
      
    }
   
    //Create pop up for wallet
    func createAlert(title: String, message: String){
        
        // Alert style confirmation
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Handler used to transition to other code, cancel confirmation
        let noButton  = UIAlertAction(title: "NO",  style: UIAlertActionStyle.cancel, handler: nil)
        let yesButton  = UIAlertAction(title: "YES",  style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(noButton)   // Add NO  button to Alert controller
        alert.addAction(yesButton)
        
        // Completion: do something after alert is displayed
        present(alert, animated: true, completion: nil)  // Display Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rewardArray.append(Reward(title: "Dope reward" , des: "Cool Beans!" ))
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        for dict in user.userRewards{
            rewardArray.append(Reward(title: dict["title"] , des: dict["des"] ))
    
        }
        
        tableView.tableFooterView = UIView() // Create blank rows after filled in cells
    }
    
    // CONFIGURING A TABLE VIEW (REQUIRED)
    // Tells the data source to return the number of rows in a given section of a table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardArray.count
    }
    
    // CONFIGURING A TABLE VIEW (REQUIRED)
    // Asks the data source for a cell to insert in a particular location of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let cell = dequeued as! WalletTableViewCell
        
        cell.rewardTitle.text = rewardArray[indexPath.row].title
        cell.rewardDes.text = rewardArray[indexPath.row].des
        
        return cell
        
    }
    
    // MANAGING SELECTIONS
    // Tells the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndexPath == indexPath.row){
            selectedIndexPath = -1
        }
        else{
            selectedIndexPath = indexPath.row
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // CONFIGURING ROWS FOR THE TABLE VIEW
    // Asks the delegate for the height to use for a row in a specified location.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndexPath{
            return WalletTableViewCell.expandHeight
        }
        else{
            return WalletTableViewCell.defaultHeight
        }
    }
    
    
}

