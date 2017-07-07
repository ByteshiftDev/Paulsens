//
//  PopUpViewController.swift
//  CoreApplicationPrototype
//
//  InboundRX iOS RFID Beacon Detecting Application
//  https://gitlab.com/InboundRX-Capstone/Paulsens-iOS-App
//
//  (c) 2017 Brett Chafin, Jason Brophy, Luke Kwak, Paul Huynh, Jason Custodio, Cher Moua, Thaddeus Sundin
//
//  You are free to use, copy, modify, and distribute this file, with attribution,
//  under the terms of the MIT license. See "license.txt" for more info.


import UIKit

class WalletPopUpViewController: UIViewController {
  
  /******************************/
  /******* Local Varibles *******/
  /******************************/
  
  // Set upon passing control to this view by the external controller.
  var reward: Reward? = nil
  
  /****************************/
  /******* View Outlets *******/
  /****************************/
  
  
  @IBOutlet weak var rewardTitle: UILabel!
  @IBOutlet weak var rewardDesc: UILabel!
  @IBOutlet weak var rewardRedeem: UIButton!
  
  /****************************/
  /******* View Actions *******/
  /****************************/
  
  
  // Dismiss the popup
  @IBAction func cancelButton() {
    self.dismiss(animated: true, completion: nil)
  }
  
  /********************************************/
  /******* Default Controller Functions *******/
  /********************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set the color behind the popup, then, update the fields with the passed
    // in products information.  This view will never reappear when dismissed without
    // A did load, so no need to override WillAppear
    self.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
    if(reward != nil){
      rewardTitle.text = reward!.title
      rewardDesc.text = reward!.des
    }
    
    rewardDesc.numberOfLines = 0
    rewardDesc.sizeToFit()
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
