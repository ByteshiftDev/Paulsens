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
    
  var seconds = 6
    
  var reward: Reward? = nil
    
  var timer = Timer()
  
  /****************************/
  /******* View Outlets *******/
  /****************************/
  
  
  @IBOutlet weak var rewardTitle: UILabel!
  @IBOutlet weak var rewardDesc: UILabel!
  @IBOutlet weak var rewardRedeem: UIButton!
  
  @IBOutlet weak var timerLabel: UILabel!
    
  /****************************/
  /******* View Actions *******/
  /****************************/
  
  
   @IBAction func redeemReward(_ sender: Any) {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WalletPopUpViewController.counter), userInfo: nil, repeats: true)
    
    rewardRedeem.isHidden = true
    
    let webCallController = WebCallController() // Create a web call controller object to make the call.
    webCallController.testReward(rewardId: (reward!.rewardId)!)
    

   }
    
  // Dismiss the popup
  @IBAction func cancelButton() {
    self.dismiss(animated: true, completion: nil)
  }
  
  /********************************************/
  /******* Default Controller Functions *******/
  /********************************************/
  
    func counter(){
        seconds -= 1
        timerLabel.text = String(seconds) + " Seconds"
        
        if(seconds == 0)
        {
            timer.invalidate()
            rewardRedeem.isHidden = false
        }
    }
    
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
