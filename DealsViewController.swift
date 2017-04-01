//
//  DealsViewController.swift
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
 Uses webcall to populate daily deals in a collective view cell
*/

import UIKit

class DealsViewController: UIViewController {
    @IBOutlet weak var dealsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // This sets a background default view that displays if there are no products.
        self.dealsCollectionView.backgroundView = UIButton()
        let backgroundView = self.dealsCollectionView.backgroundView as! UIButton
        backgroundView.titleLabel?.numberOfLines = 0
        backgroundView.titleLabel?.adjustsFontSizeToFitWidth = true
        backgroundView.backgroundColor = UIColor(red: 0.24, green: 0.34, blue: 0.45, alpha: 1.0)
        backgroundView.setTitle("Reload?", for: UIControlState.normal)
        backgroundView.addTarget(self, action: #selector(refreshDeals), for: .touchUpInside)
        
        updateDeals()
        dealsCollectionView.delegate = self
        dealsCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // If the view is going to appear, reload the data, given the data source is implemented
    // This uses the products to update the cells on the page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dealsCollectionView.reloadData()
    }
    
    @IBAction func refreshDeals() {
        updateDeals()
    }
    
    // If the segue prepared for is going to the popup, and there is a product list
    // Get the cell the call came from and pass that cell's product on to the popup.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the segue prepared for is going to the popup, and there is a product list
        // Get the cell the call came from and pass that cell's product on to the popup.
        if(segue.identifier == "dealsPopUp" && sender != nil){
            let cell = sender as! DealsCollectionViewCell
            let next = segue.destination as! DetailsViewController
            next.products = cell.product
            next.products?.image = cell.dealsImage.image!
        }
    }
    
    
    /*
        Right now updateDeals() updates rewards since there is no test data with daily_deal == true
    */
    func updateDeals() {
        let webCallController = WebCallController()
        webCallController.getRewardsList { (isError, errorMessage, dailyDealsList) in
            if !isError {
                var newProducts = [Product]()
                for dict in dailyDealsList! {
                    newProducts.append(Product(title: dict["title"] as! String,
                                        description: dict["description"] as! String,
                                        cost: dict["cost"] as! Int,
                                        image: UIImage(named: "640x360_advil")!,
                                        URLString: dict["image"] as! String,
                                        id: dict["id"] as! Int))
                }
                self.products = newProducts
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let dispAlert = appDelegate.isDisplayingPopup
                    if(!dispAlert){
                        appDelegate.isDisplayingPopup = true
                        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle:UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated:true, completion: { () in
                            appDelegate.isDisplayingPopup = false })
                    //})
                    }
                })
                return
            }
            // Make sure the UI update occurs on the MAIN thread
            DispatchQueue.main.async(execute: { () -> Void in
                if(self.products.count > 0){
                    self.dealsCollectionView.reloadData()
                    let bgView = self.dealsCollectionView.backgroundView as! UIButton
                    bgView.isEnabled = false
                    bgView.isHidden = true
                } else {
                    let bgView = self.dealsCollectionView.backgroundView as! UIButton
                    bgView.isEnabled = true
                    bgView.isHidden = false
                }
            })
        }
    }
}

extension DealsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wc = WebCallController()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealCell", for: indexPath) as! DealsCollectionViewCell
        cell.product = products[indexPath.row]
        cell.dealsTitle.text = products[indexPath.row].title
        
        let url = "https://paulsens-beacon.herokuapp.com" + products[indexPath.row].URLString
        wc.downloadImageFromURL(url, cell: cell, indexPath: indexPath.row)
        
        cell.dealsImage.image = products[indexPath.row].image
        //cell.dealsDescription.text = products![indexPath.row].description
        //cell.dealsCost.text = String(describing: products![indexPath.row].cost)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    //sets the size of the cell to the size of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.invalidateLayout()
        return CGSize(width: self.view.frame.width, height:(self.view.frame.height)) // Set your item size here
    }
    
}
