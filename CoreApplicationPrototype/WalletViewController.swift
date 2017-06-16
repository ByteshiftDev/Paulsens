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
    
    private var prod = [Product]()
    
    let webCallController = WebCallController()
    //var wallet = [Reward]()
    
    @IBAction func useReward(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rewardArray.append(Reward(title: "Dope reward" , des: "Cool Beans!" ))
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        for dict in user.userRewards{
            rewardArray.append(Reward(title: dict["title"] , des: dict["des"] ))
    
        }*/
        
        webCallController.fetchRe{(isError, errorMessage, rewardsList) in
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
                print("WALLET")
                var newRewards = [Reward]()
                var i = 0
                for dict in rewardsList! {
                    print("Event \(i):")
                    print(dict)
                    print("\n---\n")
                    //newEvents.append(Event(year: dict["date"] as! String, image: #imageLiteral(resourceName: "Image0"), title: dict["title"] as! String, des: dict["description"] as! String))
                    i = i+1
                }
                
                self.rewardArray = newRewards
                // Make sure the UI update occurs on the MAIN thread
                /*DispatchQueue.main.async(execute: { () -> Void in
                    if self.eventArray.count > 0 {
                        self.historyTableView.reloadData()
                        self.historyTableView.backgroundView!.isHidden = true
                    }
                    else {
                        self.historyTableView.backgroundView!.isHidden = false
                    }
                })*/
                
            }
        }
        for p in prod{
            rewardArray.append(Reward(title: p.title, des: p.description))
        }
        
        tableView.tableFooterView = UIView() // Create blank rows after filled in cells
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardArray.count
    }
    
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
