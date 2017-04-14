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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: cellID, for: <#T##IndexPath#>)
        
        let cell = dequeued as! WalletTableViewCell
        
        cell.rewardTitle.text = rewardArray[indexPath.row].title
        cell.rewardDes.text = rewardArray[indexPath.row].des
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndexPath == indexPath.row){
            selectedIndexPath = -1
        }
        else{
            selectedIndexPath = indexPath.row
        }
        
        tableView.reloadRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>)
    }
    
    
}
