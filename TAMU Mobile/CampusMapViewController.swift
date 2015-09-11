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
import MapKit
import CWStatusBarNotification

class CampusMapViewController: UIViewController, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource, YALTabBarInteracting, GMSMapViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    var buildings = [Building]()
    var searchResults = [Building]()
    var searchActive = false
    var geocoder = CLGeocoder()
    var currentMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
            longitude: -96.342316, zoom: 16)
        mapView.animateToCameraPosition(camera)
        mapView.myLocationEnabled = true
        
        loadBuildings()
        view.sendSubviewToBack(tableView)
        tableView.reloadData()
    }
    
    
    //MARK : TABLEVIEW DELEGATE
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var campusBuilding : Building
        
        if searchActive {
            campusBuilding = searchResults[indexPath.row]
        }
        else {
            campusBuilding = buildings[indexPath.row]
        }
        cell.textLabel?.text = "\(campusBuilding.name), \(campusBuilding.abbrev)"
        cell.detailTextLabel?.text = campusBuilding.section
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedBuilding = searchResults[indexPath.row]
        let buildingAddress = "\(selectedBuilding.name), College Station, TX \(selectedBuilding.zip)"
 
        var notification = CWStatusBarNotification()
        notification.notificationLabelBackgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        mapView.clear()
        
        SVGeocoder.geocode(buildingAddress, completion: { (placemarks : [AnyObject]!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            if error == nil{
                if let placemark = placemarks?.first as? SVPlacemark {
                    println(placemark)
                    if placemark.formattedAddress == "College Station, TX, USA" || placemark.formattedAddress == "College Station, TX 77840, USA"{
                        notification.displayNotificationWithMessage("Inaccurate coordinates. Trying alternate server", forDuration: 1.0)
                        self.appleGeocodeBackup(selectedBuilding)
                    }
                    else{
                        self.currentMarker.title = selectedBuilding.name
                        self.currentMarker.snippet = selectedBuilding.section
                        self.currentMarker.position = placemark.location.coordinate
                        self.currentMarker.map = self.mapView
                        self.dismissKeyboard()
                        var camera = GMSCameraPosition.cameraWithLatitude(placemark.location.coordinate.latitude,
                            longitude: placemark.location.coordinate.longitude, zoom: 17)
                        self.mapView.animateToCameraPosition(camera)
                    }
                }
            }
            else {
                notification.displayNotificationWithMessage("Server overloaded. Coordinates may be slightly inaccurate", forDuration: 2.0)
                self.appleGeocodeBackup(selectedBuilding)
            }
        })
    }
    
    
    // CURRENTLY USED AS FALLBACK
    func appleGeocodeBackup(building : Building) {
        let alternateAddress = "\(building.name), \(building.address), College Station, TX \(building.zip)"
        
        geocoder.geocodeAddressString(alternateAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.currentMarker.title = building.name
                self.currentMarker.snippet = building.section
                self.currentMarker.position = placemark.location.coordinate
                self.currentMarker.map = self.mapView
                self.dismissKeyboard()
                var camera = GMSCameraPosition.cameraWithLatitude(placemark.location.coordinate.latitude,
                    longitude: placemark.location.coordinate.longitude, zoom: 17)
                self.mapView.animateToCameraPosition(camera)
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return searchResults.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = buildings.filter({ (text) -> Bool in
            let tmp: NSString = text.name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(searchResults.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        if searchText.isEmpty{
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.dismissKeyboard()
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        view.bringSubviewToFront(tableView)
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        dismissKeyboard()
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard()
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
    }

    @IBAction func startNav(sender: AnyObject) {
        if currentMarker.title != nil {
            let regionDistance:CLLocationDistance = 10000
            let coordinates = currentMarker.position
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            var options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            var mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(currentMarker.title)"
            mapItem.openInMapsWithLaunchOptions(options)
        }
        else {
            let notification = CWStatusBarNotification()
            notification.notificationLabelBackgroundColor = UIColor.blackColor()
            notification.displayNotificationWithMessage("Please select a location first", forDuration: 2.0)
        }
    }
    
    //MARK : ETC delegate methods
    
    func extraRightItemDidPressed() {
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.urlString = "http://transport.tamu.edu/busroutes/"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func dismissKeyboard() {
        view.sendSubviewToBack(tableView)
        searchBar.endEditing(true)
    }
}
