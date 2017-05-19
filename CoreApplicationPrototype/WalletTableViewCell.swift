//
//  WalletTableViewCell.swift
//  CoreApplicationPrototype
//
//  Created by Paul on 4/14/17.
//  Copyright © 2017 InboundRXCapstone. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell{
    
    @IBOutlet weak var rewardTitle: UILabel!    //Reward Title
    
    @IBOutlet weak var rewardDes: UILabel!      //Reward description


    class var expandHeight: CGFloat{get{return 250}}    //Height when expanded
    class var defaultHeight: CGFloat{get{return 44}}    //Default height
    
   }

extension UITableViewCell{
    var indexPath: IndexPath?{
        return (superview as? UITableView)?.indexPath(for: self)
    }
    
}
