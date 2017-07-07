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
    let rewardId : Int!
    
    init(title: String, des: String, rewardId: Int){
        self.title = title
        self.des = des
        self.rewardId = rewardId
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
        
        
        
        self.walletTableView.backgroundView = UILabel()
        let bgView = self.walletTableView.backgroundView as! UILabel
        
        bgView.backgroundColor = UIColor.clear
        bgView.textColor = UIColor.white
        bgView.textAlignment = NSTextAlignment.center
        bgView.numberOfLines = 0
        bgView.adjustsFontSizeToFitWidth = true
        bgView.text = "It appears nothing is loaded"
        
        self.walletTableView!.alwaysBounceVertical = true
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        self.walletTableView.addSubview(self.refreshControl!)
        
        loadWallet()
        
        
        tableView.tableFooterView = UIView() // Create blank rows after filled in cells
    }
    
    func loadData() {
        loadWallet()
        self.refreshControl!.endRefreshing()
    }
    
    
    func loadWallet() {
        //rewardArray.append(Reward(title: "Dope reward" , des: "Cool Beans!" ))
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
                
                var rewardIDs = [Int]()
                
                for dict in rewardsList! {
                    print("Reward \(i):")
                    print(dict);
                    let item = (dict["item"] as! [String: Any])
                    let itemTitle = item["title"] as! String
                    let itemDesc = item["description"] as! String
                    let itemId = item["id"] as! Int
                    print(itemTitle)
                    print("\n---\n")
                    newRewards.append(Reward(title: itemTitle, des: itemDesc, rewardId: itemId))
                    
                    i = i+1
                    
                    /*
                     if(dict["rewardable_type"] as! String == "Promotion"){
                     rewardIDs.append(dict["rewardable_id"] as! Int)
                     }*/
                    
                }
                //print(rewardIDs)
                
                //let rewards = self.fetchPromotions(rewardIDs: rewardIDs)
                
                //print(rewards)
                
                
                
                self.rewardArray = newRewards
                // Make sure the UI update occurs on the MAIN thread
                DispatchQueue.main.async(execute: { () -> Void in
                    if self.rewardArray.count > 0 {
                        self.walletTableView.reloadData()
                        self.walletTableView.backgroundView!.isHidden = true
                    }
                    else {
                        self.walletTableView.backgroundView!.isHidden = false
                    }
                })
                
            }
        }
        /*for p in prod{
            rewardArray.append(Reward(title: p.title, des: p.description))
        }*/
        
    }
    
    
    /*
    func fetchPromotions(rewardIDs: [Int]) -> [[String:Any]] {
        let webController = WebCallController()
        var toReturn = [[String:Any]]()
        
        for id in rewardIDs {
            let url = SERVER_HOST_URL + "/promotions/" + String(id)
            webController.webCall(urlToCall: url, callback: { (serverResponse) in
                if let error = serverResponse["error"] as? String {
                    print("Error with fetching wallet rewards!" + error)
                }
                else {
                    toReturn.append(serverResponse)
                }
            })
        }
        return toReturn
    }
    
    func fetchPromotions(rewardIDs: [Int]) -> [String:Any] {
        let webController = WebCallController()
        
        
        
        for id in rewardIDs {
            let url = SERVER_HOST_URL + "/promotions/" + String(id)
            webController.webCall(urlToCall: url, callback: { (serverResponse) in
                if let error = serverResponse["error"] as? String {
                    print("Error with fetching wallet rewards!" + error)
                }
                else {
                    print("Adding: " + String(describing: serverResponse));
                    self.rewardArray.append(Reward(title: serverResponse["title"] as! String, des: serverResponse["description"] as! String))
                    self.walletTableView.reloadData()
                }
            })
        }
        
        return ["nope": "hello no"]
    }*/
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.walletTableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let cell = dequeued as! WalletTableViewCell
      
        cell.reward = rewardArray[indexPath.row]
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
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if(segue.identifier == "WalletPopUp" && sender != nil){
      let button = sender as! UIButton
      let content = button.superview
      let cell = content?.superview as! WalletTableViewCell
      let nextScene = segue.destination as! WalletPopUpViewController
      
      nextScene.reward = cell.reward
    }
  }
  
  @IBAction func showPopUp(_ sender: Any?) {
    self.performSegue(withIdentifier: "WalletPopUp", sender: sender as! UIButton)
  }
  
  
}
