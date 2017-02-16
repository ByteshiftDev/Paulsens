//
//  RewardsViewController.swift
//  CoreApplicationPrototype
//
//  Created by Brett Chafin on 1/10/17.
//  Copyright © 2017 InboundRXCapstone. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController {

    
    @IBOutlet weak var rewardsCollectionView: UICollectionView!
    @IBOutlet weak var phold: UILabel!
    //hardcoded array of images.
    var images = [UIImage(named: "1reward"),UIImage(named: "2reward"),UIImage(named: "3reward"),UIImage(named: "4reward"),UIImage(named: "5reward")]
    var points = 0
    
    func UpdatePoints(){
        self.phold.text = String(points)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rewardsCollectionView.delegate = self
        self.rewardsCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}

extension RewardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //number of kinds of sections. We only want one type of dimension, so return 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //count how many images are in the array.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    //fill cell with an image in the array.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rewardsCollectionView.dequeueReusableCell(withReuseIdentifier: "rewardsCollectionCell", for: indexPath) as! RewardsCollectionViewCell
        cell.rewardsImageView.image = images[indexPath.row]
        return cell
    }
    //when clicking on a cell, print out which one is getting selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item is: " , indexPath.row)
    }
}
