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

class CampusMapViewController: UIViewController, YALTabBarInteracting {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
            longitude: -96.342316, zoom: 16)
        mapView.animateToCameraPosition(camera)
    }
    
    func extraRightItemDidPressed(){
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.urlString = "http://transport.tamu.edu/busroutes/"
        navigationController?.pushViewController(webVC, animated: true)
    }
}
