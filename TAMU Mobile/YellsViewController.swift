//
//  YellsViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import FoldingTabBar
import EBCardCollectionViewLayout

class YellsViewController: UIViewController, UICollectionViewDataSource, YALTabBarInteracting {

    @IBOutlet weak var collectionView: UICollectionView!

    var yells = [Yell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadYells()
        
        var anOffset = UIOffsetMake(20, 20)
        let layout = collectionView.collectionViewLayout as! EBCardCollectionViewLayout
        layout.offset = anOffset
        layout.layoutType = EBCardCollectionLayoutType.Vertical
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView.contentOffset = CGPointMake(0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yells.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! YellCell
        var yellName = yells[indexPath.item].name
        cell.label.text = yellName
        cell.passbackLabel.text = yells[indexPath.item].passback
        cell.descriptionLabel.text = yells[indexPath.item].call
        
        cell.imageView.image = UIImage(named: yellName.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil).lowercaseString)
        
        return cell
    }

    func loadYells(){
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("yells", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as! NSDictionary
        var yells : NSArray = jsonResult["yell"] as! NSArray
        for item in yells{
            let yellItem = item as! [String : String]
            var yell = Yell(name: yellItem["name"]!, passback: yellItem["passback"]!, call: yellItem["call"]!)
            self.yells.append(yell)
        }
        collectionView.reloadData()
    }
    
    func extraRightItemDidPressed(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
