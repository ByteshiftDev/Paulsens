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
    var indexPath = -1
    private var rewardArray = [Reward]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
