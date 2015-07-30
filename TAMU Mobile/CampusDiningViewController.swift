//
//  CampusDiningViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//
//campusdining.json date... sun : 1, mon : 2, tues : 3,wed : 4, thur : 5, fri : 6, sat : 7
import Foundation
import GoogleMaps
import FoldingTabBar

class CampusDiningViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YALTabBarInteracting {

    var campusPlaces = [CampusFood]()
    var markers = [GMSMarker]()
    var mapUpdated = false
    @IBOutlet weak var tableView: UITableView!
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
        
        loadVenues()
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
        longitude: -96.342316, zoom: 15)
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
            
            var hoursObject = subJson["hours"] as! [AnyObject]
            var hoursArray = [Hours]()
            for day in hoursObject{
                let dayHours = Hours(day: day["day"] as! String, begTime: day["begTime"] as! String, endTime: day["endTime"] as! String)
                hoursArray.append(dayHours)
            }
            venue.hours = hoursArray
            marker.map = mapView

            campusPlaces.append(venue)
            self.markers.append(marker)
        }
        
        isOpen()
        tableView.reloadData()
    }
    
    //MARK: UITableView Delegate/Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campusPlaces.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CampusDiningCell
        let foodPlace = campusPlaces[indexPath.row]
        cell.mainLabel.text = foodPlace.address.name
        cell.addressLabel.text = foodPlace.address.address

        if foodPlace.open{
            cell.statusLabel.backgroundColor = UIColor(red: 90.0/255.0, green: 214.0/255.0, blue: 83.0/255.0, alpha: 1)
            cell.statusLabel.text = "Open"
        }
        else{
            cell.statusLabel.backgroundColor = UIColor.redColor()
            cell.statusLabel.text = "Closed"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }

    func isOpen(){
        let todayDate = getDayOfWeek()
        let now = NSDate()
        var open = Bool()
        
        for (index, venue) in enumerate(campusPlaces){
            for businessDay in venue.hours{
                if businessDay.day.toInt() == todayDate{
                    let begTime = now.dateAt(hours: businessDay.begTime.getHour(), minutes: businessDay.begTime.getMinutes())
                    let endTime = now.dateAt(hours: businessDay.endTime.getHour(), minutes: businessDay.endTime.getMinutes())
                    
                    if now > begTime && now < endTime{
                        venue.open = true
                        markers[index].snippet = "Open"
                        break
                    }
                    else{
                        venue.open = false
                        markers[index].snippet = "Closed"
                        break
                    }
                }
                else{
                    markers[index].snippet = "Closed"
                    venue.open = false
                }
            }
        }
    }
    
    func getDayOfWeek() -> Int {
        let now = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponents = myCalendar?.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: now)
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
    
    func extraRightItemDidPressed(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}



