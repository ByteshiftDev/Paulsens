//
//  RewardsCollectionViewCell.swift
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
 A layout for one rewards cell in a collection view.
 A cell shows an image, a point cost, and title of product
*/

import UIKit

protocol RewardsCollectionViewCellDelegate {
    func redeemDeal(forCell: RewardsCollectionViewCell)
    func infoDeal(forCell: RewardsCollectionViewCell)
}

class RewardsCollectionViewCell: UICollectionViewCell {

    /************ Class Varibles ********/
    
    var delegate: RewardsCollectionViewCellDelegate? = nil
    var product: Product? = nil
    
    /************ View Outlets ********/
    
    //The items in the cell of the collection view
    @IBOutlet var productLabel: UILabel!
    
    @IBOutlet var productCost: UILabel!
    
    @IBOutlet var productButton: UIButton!
    
    /************ View Actions ********/
    
    //redeem button, does nothing at the moment
    @IBAction func redeemButton(_ sender: Any) {
        //Nothing as of yet
        
    }
    
    
}
