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
    var buildings = [Building]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
            longitude: -96.342316, zoom: 16)
        mapView.animateToCameraPosition(camera)
        
        loadBuildings()
    }
    
    func loadBuildings(){
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("tamubuildings", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let json : JSON = JSON(data: jsonData)
        
        let itemArray = json["buildings"].arrayObject!
        
        for item in itemArray{
            let subJson = item as! [String : AnyObject]
            var building = Building(name: subJson["name"] as! String, address: subJson["address"] as! String, city: subJson["city"] as! String, zip: subJson["zip"] as! Int, section: subJson["section"] as! String)
            if let abbrev = subJson["abbrev"] as? String {
                building.abbrev = abbrev
            }
            else{
                building.abbrev = ""
            }
            
            buildings.append(building)
        }
        println(buildings.count)
    }

    
    //MARK : ETC delegate methods
    
    func extraRightItemDidPressed() {
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.urlString = "http://transport.tamu.edu/busroutes/"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}
