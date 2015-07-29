//
//  PrivacyTableViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/28/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class PrivacyTableViewController: UITableViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        tableView.layoutIfNeeded()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height - self.navigationController!.navigationBar.frame.height
        }
        else{
            return self.view.frame.height
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == true {
            centerTable()
        }
    }

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
       centerTable()
    }
    
    func centerTable() {
        var cellIdx = tableView.indexPathForRowAtPoint(CGPointMake(CGRectGetMidX(tableView.bounds), CGRectGetMidY(tableView.bounds)))
        tableView.scrollToRowAtIndexPath(cellIdx!, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
}
