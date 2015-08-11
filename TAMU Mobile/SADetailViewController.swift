//
//  SADetailViewController.swift
//  SAParallaxViewControllerSwift
//
//  Created by 鈴木大貴 on 2015/02/05.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

public class SADetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var trantisionContainerView: SATransitionContainerView?
    public var imageView = UIImageView()
    
    public var headerView: UIView?
    public var closeButton: UIButton?
    private var headerColorView: UIView?
    private var headerImageView: UIImageView?
    private var headerContainerView: UIView?
    private var blurImageView: UIImageView?
    private let kHeaderViewHeight: CGFloat = 64
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var passback = String()
    var yell = String()
    var yellName = String()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.tableFooterView = UIView()

        view.backgroundColor = .whiteColor()
        
        let width = UIScreen.mainScreen().bounds.size.width
        imageView.image = trantisionContainerView?.containerView?.imageView.image
        if let imageSize = imageView.image?.size {
            let height = width * imageSize.height / imageSize.width
            imageView.autoresizingMask = .None
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.addSubview(imageView)
            tableHeight.constant = self.view.frame.height - height
        }
        

        let headerContainerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: kHeaderViewHeight))
        headerContainerView.alpha = 0.0
        headerContainerView.clipsToBounds = true
        view.addSubview(headerContainerView)
        self.headerContainerView = headerContainerView
        
        let blurImageView = UIImageView(frame: imageView.bounds)
        blurImageView.image = imageView.image?.blur(20.0)
        headerContainerView.addSubview(blurImageView)
        self.blurImageView = blurImageView
        
        let headerColorView = UIView(frame: headerContainerView.bounds)
        headerColorView.backgroundColor = .blackColor()
        headerColorView.alpha = 0.5
        headerContainerView.addSubview(headerColorView)
        self.headerColorView = headerColorView
        
        let headerView = UIView(frame: headerContainerView.bounds)
        headerContainerView.addSubview(headerView)
        self.headerView = headerView
        
        let closeButton = UIButton(frame: CGRect(x: 0.0, y: 9.0, width: kHeaderViewHeight, height: kHeaderViewHeight))
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "closeAction:", forControlEvents: .TouchUpInside)
        headerView.addSubview(closeButton)
        self.closeButton = closeButton
        
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 9.0, width: self.view.frame.width, height: kHeaderViewHeight))
        titleLabel.text = yellName
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "GillSans-Light", size: 20)!
        titleLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(titleLabel)
        
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "PASSBACK"
        }
        else{
            return "YELL"
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! YellCell
        
        if indexPath.section == 0{
            cell.mainlabel.text = passback
        }
        else{
            cell.mainlabel.text = yell
        }
        
        return cell
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.headerContainerView?.alpha = 1.0
            
        }, completion: { (finished) in })
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public func closeAction(button: UIButton) {
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.headerContainerView?.alpha = 0.0
            
        }, completion: { (finished) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
                
        })
    }
}
