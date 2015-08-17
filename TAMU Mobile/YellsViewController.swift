//
//  YellsViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import FoldingTabBar

class YellsViewController: SAParallaxViewController, YALTabBarInteracting {
    var yells = [Yell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadYells()
    }

    @IBAction func closeVC(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
        self.yells.append(Yell(name: "Aggie War Hymn", passback: "All hail to dear old Texas A&M\nRally around Maroon and White\nGood luck to the dear old Texas Aggies\nThey are the boys who show the real old fight\nThat good old Aggie spirit thrills us\nAnd makes us yell and yell and yell\nSo let’s fight for dear old Texas A&M\nWe’re goin’ to beat you all to\nChig-gar-roo-gar-rem\nChig-gar-roo-gar-rem\nRough Tough! Real Stuff! Texas A&M\n\nGood-bye to texas university\nSo long to the Orange and the White\nGood luck to dear old Texas Aggies\nThey are the boys that show the real old fight\n“The eyes of Texas are upon you…”\nThat is the song they sing so well (Sounds like hell)\nSo good-bye to texas university\nWe’re going to beat you all to\nChig-gar-roo-gar-rem\nChig-gar-roo-gar-rem\nRough! Tough! Real Stuff! Texas A&M", call: "hymn"))
        collectionView.reloadData()
    }
    
    func extraRightItemDidPressed(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        let selectedYell = yells[indexPath.item]
        let cells = collectionView.visibleCells() as? [SAParallaxViewCell]
        let containerView = SATransitionContainerView(frame: view.bounds)
        containerView.setViews(cells: cells!, view: view)
        
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("detail") as! SADetailViewController
        detailVC.yell = selectedYell.call
        detailVC.passback = selectedYell.passback
        detailVC.yellName = selectedYell.name
        
        detailVC.transitioningDelegate = self
        detailVC.trantisionContainerView = containerView
        
        presentViewController(detailVC, animated: true, completion: nil)
    }
}
   extension YellsViewController: UICollectionViewDataSource {
        override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)

            if let cell = cell as? SAParallaxViewCell {
                
                for view in cell.containerView.accessoryView.subviews {
                    if let view = view as? UILabel {
                        view.removeFromSuperview()
                    }
                }

                var yellName = yells[indexPath.item].name
                let imageName = yellName.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil).lowercaseString
                if let image = UIImage(named: imageName) {
                    cell.setImage(image)
                }
                
                let label = UILabel(frame: cell.containerView.accessoryView.bounds)
                label.textAlignment = .Center
                label.text = yellName.uppercaseString
                label.textColor = .whiteColor()
                label.font = .systemFontOfSize(30)
                cell.containerView.accessoryView.addSubview(label)
            }
            
            return cell
        }
        override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return yells.count
        }
    }

    extension YellsViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 210)
        }
    }