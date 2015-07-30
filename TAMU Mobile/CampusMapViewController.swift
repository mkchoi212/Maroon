//
//  CampusMapViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/29/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import GoogleMaps
import FoldingTabBar

class CampusMapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YALTabBarInteracting {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .Plain, target: self, action: "onListButton")
        
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
            longitude: -96.342316, zoom: 16)
        mapView.animateToCameraPosition(camera)
        mapView.animateToViewingAngle(45)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
    
    func onListButton() {
        UIView.transitionFromView(mapView, toView: tableView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
        
    }
    
    func onMapButton() {
        UIView.transitionFromView(tableView, toView: mapView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion : nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .Plain, target: self, action: "onListButton")
    }
    
    func extraRightItemDidPressed(){
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.coolaf = false
        navigationController?.pushViewController(webVC, animated: true)
    }
}
