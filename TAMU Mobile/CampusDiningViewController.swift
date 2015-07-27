//
//  CampusDiningViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import GoogleMaps

class CampusDiningViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var campusPlaces = [CampusFood]()
    var markers = [GMSMarker]()
    var mapUpdated = false
    @IBOutlet weak var tableView: UITableView!
    var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "On-Campus"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
        
        loadVenues()
        
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
            longitude: -96.342316, zoom: 16)
        self.mapView.animateToCameraPosition(camera)
    }

    func loadVenues(){
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("campusdining", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let json : JSON = JSON(data: jsonData)
        
        let itemArray = json["locations"].arrayObject!
    
        for item in itemArray{
            var marker = GMSMarker()
      
            let subJson = item as! [String : AnyObject]
            var venue = CampusFood()
            var address = FoodLocation(name : subJson["name"] as! String, address: subJson["address"] as! String, city: subJson["city"] as! String, state: subJson["state"] as! String, zip: subJson["zip"] as! String, lat: subJson["lat"] as! String, lon: subJson["lon"] as! String)
            venue.address = address
            
            marker.position = CLLocationCoordinate2DMake((subJson["lat"] as! NSString).doubleValue, (subJson["lon"] as! NSString).doubleValue)
            marker.title = subJson["name"] as! String
            marker.snippet = "Australia"
            
            var hoursObject = subJson["hours"] as! [AnyObject]
            var hoursArray = [Hours]()
            for day in hoursObject{
                let dayHours = Hours(day: day["day"] as! String, begTime: day["begTime"] as! String, endTime: day["endTime"] as! String, begDate: day["begDate"] as! String, endDate: day["endDate"] as! String)
                hoursArray.append(dayHours)
            }
            venue.hours = hoursArray
            marker.map = mapView
            self.campusPlaces.append(venue)
            self.markers.append(marker)
            isOpen(venue.hours)
        }
    }
    
    func isOpen(schedule : [Hours]) -> Bool{

        for item in schedule{
          println(item.day.toInt(), getDayOfWeek())
        }
        return true
    }
    
    func getDayOfWeek()->Int {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponents = myCalendar?.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: todayDate)
        let weekDay = myComponents?.weekday
        return weekDay!
    }
    
    func onListButton() {
        UIView.transitionFromView(mapView, toView: tableView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
        
    }
    
    func onMapButton() {
        UIView.transitionFromView(tableView, toView: mapView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion : nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .Plain, target: self, action: "onListButton")
    }
}



