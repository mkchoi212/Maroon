//
//  HomeViewController.swift
//  Pantry
//
//  Created by Mike Choi on 7/25/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import UIKit
import FoldingTabBar

private let kTableHeightHeader: CGFloat = 400
private let kTableToBeCutOff: CGFloat = 70

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, YALTabBarInteracting {

    @IBOutlet var bigHeaderImageView: UIImageView!
    @IBOutlet var newsTableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
     var feed: RSSFeed?
    var tableHeaderView: UIView!
    var tableHeaderMaskToBeVisible: CAShapeLayer!
    var arrayCheckCellHasLoaded = [Bool]()
    var newsArray = [RSSItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNews()
        stylingDateLabel()
        configureNewsTable()
        updatingTableHeaderView()
        
    }

    func stylingDateLabel() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        self.dateLabel.text = dateFormatter.stringFromDate(NSDate())
        self.dateLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        self.dateLabel.textColor = UIColor.whiteColor()
    }
    
    
    func getNews(){
        let request = NSURLRequest(URL: NSURL(string: "http://today.tamu.edu/feed/")!)
        
        RSSParser.parseFeedForRequest(request, callback: { (feed, error) -> Void in
            if let myFeed = feed{
                self.feed = feed
                self.newsArray = feed!.items
                self.newsTableView.reloadData()
            }
            self.arrayCheckCellHasLoaded = [Bool](count: self.newsArray.count, repeatedValue: false)
        })
    }
    

    //MARK: table
    func configureNewsTable() {
        
        self.bigHeaderImageView.image = UIImage(named: "aggies")
        
        self.tableHeaderView = self.newsTableView.tableHeaderView!
        self.newsTableView.tableHeaderView = nil
        self.newsTableView.addSubview(self.tableHeaderView)
        self.newsTableView.sendSubviewToBack(self.tableHeaderView)
        
        self.newsTableView.contentInset = UIEdgeInsetsMake(kTableHeightHeader, 0, 0, 0)
        self.newsTableView.contentOffset = CGPoint(x: 0, y: -kTableHeightHeader)
        
    }
    
    func updatingTableHeaderView() {
        var newsHeaderTableRect = CGRect(x: 0, y: -kTableHeightHeader, width: self.view.frame.size.width, height: kTableHeightHeader)
        
        if self.newsTableView.contentOffset.y < -kTableHeightHeader {
            newsHeaderTableRect.origin.y = self.newsTableView.contentOffset.y
            newsHeaderTableRect.size.height = -self.newsTableView.contentOffset.y
        }
        
        self.tableHeaderView.frame = newsHeaderTableRect
        
        visiblePortionOfNewsTableHeader(newsHeaderTableRect: newsHeaderTableRect)
    }
    
    func visiblePortionOfNewsTableHeader(#newsHeaderTableRect: CGRect) {
        
        self.tableHeaderMaskToBeVisible = CAShapeLayer()
        self.tableHeaderMaskToBeVisible.fillColor = UIColor.blackColor().CGColor
        self.tableHeaderView.layer.mask = self.tableHeaderMaskToBeVisible
        
        let trapeziumHeaderMask = UIBezierPath()
        trapeziumHeaderMask.moveToPoint(CGPointMake(0, 0))
        trapeziumHeaderMask.addLineToPoint(CGPointMake(newsHeaderTableRect.width, 0))
        trapeziumHeaderMask.addLineToPoint(CGPointMake(newsHeaderTableRect.width, newsHeaderTableRect.height))
        trapeziumHeaderMask.addLineToPoint(CGPointMake(0, newsHeaderTableRect.height - kTableToBeCutOff))
        self.tableHeaderMaskToBeVisible.path = trapeziumHeaderMask.CGPath
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = self.feed{
            return feed.items.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell") as! HomeNewsTableViewCell
       
        if let feed = self.feed{
            let item = feed.items[indexPath.row] as RSSItem
            if let category = item.categories.first{
                cell.newsCategory.text = category
                cell.newsCategory.textColor = category.getCategoryColor()
            }
            cell.newsTitle.text = item.title
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = feed!.items[indexPath.row] as RSSItem
        
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        
        webVC.requestURL = item.link!
        webVC.customTitle = item.title!
        
        let navVC = UINavigationController(rootViewController: webVC)
        navVC.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeVC")
        
        let shareImage = UIImage(named: "share-bar")
        navVC.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: shareImage, style: .Plain, target: webVC, action: "openSafari:")
        presentViewController(navVC, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.arrayCheckCellHasLoaded[indexPath.row] == false {
            cell.alpha = 0
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                cell.alpha = 1
                
            });
            self.arrayCheckCellHasLoaded[indexPath.row] = true
        }
    }
    
    //MARK: ScrollView
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updatingTableHeaderView()
    }
    

    func extraRightItemDidPressed(){
        let tamuVC = storyboard?.instantiateViewControllerWithIdentifier("tamu") as! TamuMenuViewController
        self.navigationController?.pushViewController(tamuVC, animated: true)
    }
    
    func closeVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

