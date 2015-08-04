//
//  YellsViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import FoldingTabBar

class YellsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate, UITableViewDataSource, YALTabBarInteracting {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var yellTitle: UILabel!
    @IBOutlet weak var passBackLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var yellIndex = 0
    var yells = [Yell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Yells"
        
        loadYells()
    }
    
    //MARK : TABLEVIEW DELEGATE
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! YellInfoCell
        if indexPath.section == 0 {
            cell.mainLabel.text = "PASSBACK"
            cell.descriptionLabel.text = yells[yellIndex].passback
        }
        else{
            cell.mainLabel.text = "YELL"
            cell.descriptionLabel.text = yells[yellIndex].call
        }
        return cell
    }
    //MARK : COLLECTIONVIEW DELEGATE
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return yells.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! YellCell
        cell.label.text = self.yells[indexPath.section].name.uppercaseString
        cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2.0
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! YellCell
        let underline = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlinedString = NSAttributedString(string: cell.label.text!.uppercaseString, attributes: underline)
        self.yellTitle.attributedText = underlinedString
        
        yellIndex = indexPath.section
        self.yellTitle.attributedText = underlinedString
        tableView.reloadData()
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
        
        let underline = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlinedString = NSAttributedString(string: self.yells[0].name.uppercaseString, attributes: underline)
        self.yellTitle.attributedText = underlinedString

        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        tableView.reloadData()
    }
    
    func extraRightItemDidPressed(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
