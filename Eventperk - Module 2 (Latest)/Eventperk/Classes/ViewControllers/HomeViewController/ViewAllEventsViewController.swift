//
//  ViewAllEventsViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 02/05/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import AASegmentedControl


class ViewAllEventsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet var segmentedControls: AASegmentedControl!
    @IBOutlet var collection_View:UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupSegmentedControl()
        self.collection_View.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }
    
    func setupSegmentedControl()
    {
        segmentedControls.itemNames = ["Created", "Tendered"]
        segmentedControls.selectedIndex = 0
        segmentedControls.addTarget(self, action: #selector(ExploreViewController.segmentValueChanged(_:)), for: .valueChanged)
    }
    
    func segmentValueChanged(_ sender: AASegmentedControl)
    {
        print("SelectedIndex: ", sender.selectedIndex)
    }
    
    @IBAction func clk_Back(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 5 * 2) / 2 //some width
        let height = width * 1 //ratio
        return CGSize(width: width, height: height);
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
