//
//  RewardsViewController.swift
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
 Rewards screen that shows the users current points and a collection
 of rewards that a user may redeem. A web call is made to populate the 
 collection view from the server by storing them in a Product struct.
*/

import UIKit

// A struct to group the relevant product items
struct Product {
    var title: String
    var description: String
    var cost: Int
    var image: UIImage
    var id: Int
    
    init(title: String, description: String, cost: Int, image: UIImage, id: Int){
        self.title = title
        self.description = description
        self.cost = cost
        self.image = image
        self.id = id
    }
}

class RewardsViewController: UIViewController{
    
    /************ Class Varibles ********/
    
    private let refreshControl = UIRefreshControl()
    
    /************ View Outlets **********/
    
    @IBOutlet weak var rewardsCollectionView: UICollectionView!
    
    @IBOutlet weak var prodButton: UIButton!
    
    @IBOutlet weak var phold: UILabel!

    /************ View Actions **********/
    
    // The list of products for the view, that the rewards relate to.
    // This is the Data source
    var products = [Product]()
    
    
    // This exists but is not yet hooked up, it would be used to 
    // unwind back to rewards from login if coming from the login screen
    @IBAction func unwindtoRewards(segue:UIStoryboardSegue) { }

    
    //This will display the points in the text field
    func updatePoints(){
        //Call user to update and return points.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        self.phold.text = user.updatePoints()
    }
    
    
    // Performs the segue to the popup from the clicked cell
    @IBAction func showDetail(_ sender: Any?) {
        self.performSegue(withIdentifier: "rewardPopUp2", sender: sender as! UIButton)
    }
    
    /******* Additional Functions *******/
    
    // Get the information from the web server regarding the rewards that are redeemable.
    func updateRewards() {
        let webCallController = WebCallController() // Create a web call controller object to make the call.
        webCallController.getRewardsList { (isError, errorMessage, rewardsList) in
            var newProducts = [Product]()
            // If the rewardsList retrieved is not empty, run through each dictionary in the list
            // If its not a daily deal, its a reward, so grab its relevant info to create the product.
            if(isError){
                DispatchQueue.main.async(execute: { () -> Void in
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
            }
            if rewardsList != nil {
                for dict in rewardsList! {
                    newProducts.append(Product(title: dict["title"] as! String, description: dict["description"] as! String, cost: dict["cost"] as! Int, image: UIImage(named: "Paulsens_Logo_Gold3")!, id: dict["id"] as! Int))
                }
                self.products = newProducts
            }
            // Make sure the UI update occurs on the MAIN thread
            DispatchQueue.main.async(execute: { () -> Void in
                self.rewardsCollectionView.reloadData()
                if(self.products.count > 0){
                    self.rewardsCollectionView.backgroundView!.isHidden = true
                }
                else {
                    self.rewardsCollectionView.backgroundView!.isHidden = false
                }
            })
        }
    }
    
    /********* Refresh Control *********/
    
    // Setup the refreshControl to invoke loadData when the user pulls down on the screen
    private func setupCollView() {
        
        self.rewardsCollectionView!.alwaysBounceVertical = true
        self.refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        self.rewardsCollectionView.addSubview(self.refreshControl)
    }
    
    
    // Update the rewards, then end refreshing
    // This possibly needs a fix to wait for update to finish before ending refreshing.
    @objc private func loadData() {
        updateRewards()
        self.refreshControl.endRefreshing()
    }
    
    /************ Default Controller Functions *********/
    
    // Setup the refreshControl object, then setup
    // the delegate and data source for the collection view to itself to use the extensions.
    // Finally update the Rewards cells and point labels using the corresponding functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollView()
        
        self.rewardsCollectionView.backgroundView = UILabel()
        let backgroundView = self.rewardsCollectionView.backgroundView as! UILabel
        backgroundView.adjustsFontSizeToFitWidth = true
        backgroundView.numberOfLines = 0
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.textAlignment = NSTextAlignment.center
        backgroundView.text = "There appears to be nothing here"
        
        self.rewardsCollectionView.delegate = self
        self.rewardsCollectionView.dataSource = self
        updateRewards()
        updatePoints()
    }
    
    
    // If the view is going to appear, reload the data, given the data source is implemented
    // This uses the products to update the cells on the page, then update the points label given the 
    // user's current points
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePoints()
    }
    
    
    // If the segue prepared for is going to the popup, and there is a product list
    // Get the cell the call came from and pass that cell's product on to the popup.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "rewardPopUp2" && sender != nil){
            let button = sender as! UIButton
            let content = button.superview
            let cell = content?.superview as! RewardsCollectionViewCell
            let nextScene = segue.destination as! PopUpViewController
            nextScene.product = cell.product
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension RewardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // This is a required override for the Data source implementation.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    
    // This function sets the cell's respective elements to the correct information by pulling it from the 
    // corresponding spot in the products list, and applies a colored border to the cell.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rewardsCollectionCell", for: indexPath) as! RewardsCollectionViewCell
        cell.product = products[indexPath.row]
        cell.productLabel.text = products[indexPath.row].title
        downlaodImageFromURL("https://www.getupandgobaked.com/wp-content/uploads/2015/03/smart-cookie-pic-copy.jpg", cell: cell)
        cell.productCost.text = String(describing: products[indexPath.row].cost)
        cell.layer.borderColor = UIColor(red: 0.24, green: 0.34, blue: 0.45, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 5
        return cell
        
    }
    
    func downlaodImageFromURL(_ url: String, cell: RewardsCollectionViewCell) {
            let catPictureURL = URL(string: url)!
            
            // Creating a session object with the default configuration.
            // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
            let session = URLSession(configuration: .default)
            
            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded sample picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            cell.productButton.setImage(image, for: UIControlState.normal)
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()
        }

}
