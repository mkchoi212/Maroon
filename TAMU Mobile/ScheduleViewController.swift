//
//  ScheduleViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
//http://www.12thman.com/calendar.ashx/calendar.rss?sport_id=3&han=

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var timeline:   TimelineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setupTimeline()
    }
    
    func setupTimeline(){
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        view.addSubview(scrollView)
        
        view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        timeline = TimelineView(bulletType: .Circle, timeFrames: [
            TimeFrame(text: "Arizon State @ Houston\n\n", date: "September 5", image: UIImage(named: "fireworks.jpeg")),
            TimeFrame(text: "Ball State @ Kyle Field\n\n", date: "September 12", image: UIImage(named: "heart.png")),
            TimeFrame(text: "Nevada @ Kyle Field\n\n", date: "September 19",  image: nil),
            TimeFrame(text: "Arkansas @ Arlington\n\n\n\n", date: "September 26", image: UIImage(named: "april.jpeg")),
            TimeFrame(text: "Mississipi State @ Kyle Field\n\n", date: "October 3", image: nil),
            TimeFrame(text: "Alabama @ Kyle Field\n\n", date: "October 17", image: nil),
            TimeFrame(text: "Ole Miss @ Oxford, MI\n\n", date: "October 24", image: nil),
            TimeFrame(text: "South Carolina @ Kyle Field\n\n", date: "October 31", image: nil),
            TimeFrame(text: "Auburn @ Kyle Field\n\n", date: "November 7", image: nil),
            TimeFrame(text: "Western Carolina @ Kyle Field\n\n", date: "November 14", image: nil),
            TimeFrame(text: "Vanderbilt @ Nashvile, TN\n\n", date: "November 21", image: nil),
            TimeFrame(text: "LSU @ Baton Rouge, LA\n\n\n\n", date: "November 28", image: nil),
            TimeFrame(text: "SEC Championship @ Georgia Dome", date: "December 5", image: nil)
            ])
        timeline.titleLabelColor = UIColor.whiteColor()
        timeline.detailLabelColor = UIColor.lightGrayColor()
        scrollView.addSubview(timeline)
        scrollView.addConstraints([
            NSLayoutConstraint(item: timeline, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: timeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
        
        view.sendSubviewToBack(scrollView)
        

    }
}
