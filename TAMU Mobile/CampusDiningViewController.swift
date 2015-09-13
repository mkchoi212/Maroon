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
import CWStatusBarNotification

class CampusDiningViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, YALTabBarInteracting {

    var searchResults = [CampusFood]()
    var campusPlaces = [CampusFood]()
    var markers = [GMSMarker]()
    var mapUpdated = false
    var searchActive = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var mapView: GMSMapView!
    var selectedVenue = CampusFood()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
        
        loadVenues()
        var camera = GMSCameraPosition.cameraWithLatitude(30.614919,
        longitude: -96.342316, zoom: 15)
        mapView.animateToCameraPosition(camera)
        mapView.myLocationEnabled = true
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
        if searchActive{
            return searchResults.count
        }
        else{
            return campusPlaces.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CampusDiningCell
        var foodPlace : CampusFood

        if searchActive {
            foodPlace = searchResults[indexPath.row]
        }
        else{
            foodPlace = campusPlaces[indexPath.row]
        }
        
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
        
        if foodPlace.address.name == "Commons Foodcourt"{
            cell.statusLabel.backgroundColor = UIColor.lightGrayColor()
            cell.statusLabel.text = "???"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var foodPlace : CampusFood
        if searchActive {
            foodPlace = searchResults[indexPath.row]
        }
        else{
            foodPlace = campusPlaces[indexPath.row]
        }
        selectedVenue = foodPlace
        
        self.onMapButton()
        var camera = GMSCameraPosition.cameraWithLatitude((foodPlace.address.lat as NSString).doubleValue,
            longitude: (foodPlace.address.lon as NSString).doubleValue, zoom: 18)
        mapView.animateToCameraPosition(camera)
        
        let searchMarker = NSPredicate(format: "%K == %@", "title", foodPlace.address.name)
        let userLocations = (markers as NSArray).filteredArrayUsingPredicate(searchMarker) as? [GMSMarker]
        
        let marker = userLocations?.first
        mapView.selectedMarker = marker
        
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.endEditing(true)
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
    
    
    //MARK : BAR BUTTON ITEMS
    
    func onListButton() {        
        UIView.transitionFromView(mapView, toView: tableView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
    }
    
    func onMapButton() {
        searchBar.endEditing(true)
        
        UIView.transitionFromView(tableView, toView: mapView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion : nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .Plain, target: self, action: "onListButton")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "startnav"), style: .Plain, target: self, action: "startNav")
    }
    
    func extraRightItemDidPressed(){
        let yelpVC = storyboard?.instantiateViewControllerWithIdentifier("yelp") as! ViewController
        navigationController?.pushViewController(yelpVC, animated: true)
    }
    
    func startNav(){
        if !(selectedVenue.address.name.isEmpty) {
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2D(latitude: (selectedVenue.address.lat as NSString).doubleValue, longitude: (selectedVenue.address.lon as NSString).doubleValue)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            var options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking
            ]
            var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            var mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(selectedVenue.address.name)"
            mapItem.openInMapsWithLaunchOptions(options)
        }
        else {
            let notification = CWStatusBarNotification()
            notification.notificationLabelBackgroundColor = UIColor.blackColor()
            notification.displayNotificationWithMessage("Please select a location first", forDuration: 2.0)
        }
    }
    
    //MARK : SEARCH BAR DELEGATES
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchText.isEmpty{
            searchActive = false
        }
        else{
            searchResults = campusPlaces.filter({ (text) -> Bool in
                let tmp: NSString = text.address.name
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
            if(searchResults.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
        tableView.reloadData()
    }
    
}



