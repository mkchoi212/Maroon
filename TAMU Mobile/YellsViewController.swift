//
//  YellsViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class YellsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var yellLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var yellTitle: UILabel!
    @IBOutlet weak var passBackLabel: UILabel!
    var yells = [Yell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Yells"
        
        var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        self.backgroundImage.addSubview(blurView)
        
        loadYells()
    }
    
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
        
        self.yellTitle.attributedText = underlinedString
        self.passBackLabel.text = self.yells[indexPath.section].passback
        self.yellLabel.text = self.yells[indexPath.section].call
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
        self.passBackLabel.text = self.yells.first!.passback
        self.yellLabel.text = self.yells.first!.call

        collectionView.reloadData()
        collectionView.reloadInputViews()
    }
}
