//
//  ViewController.swift
//  Yelp
//
//  Created by Kristen on 2/8/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking
import BDBOAuth1Manager
import FoldingTabBar

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate, YALTabBarInteracting{
    var client: YelpClient!
    
    @IBOutlet private weak var businessMapView: MKMapView! // make strong?
    @IBOutlet private weak var businessTableView: UITableView! // make strong?
    private let yelpConsumerKey = "kRyJ7J0tzSytiDxknPNS3Q"
    private let yelpConsumerSecret = "9ghoeZyZXYUR0GDnHnEdfqoqLkk"
    private let yelpToken = "Gdz-5v2nxZYXLhWYT5sKUmHYj3Lr3sg8"
    private let yelpTokenSecret = "BxxPae9UJmonyoNUXqtKx0PlgQk"

    private var businesses = [Business]()
    private var searchController: UISearchController!
    private let businessLimit = 20
    private var scrollOffset = 20
    private var searchTerm = "Restaurant"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 80.0/255.0, green: 0, blue: 0, alpha: 1.0)
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessMapView.delegate = self
        businessTableView.registerNib(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        businessTableView.estimatedRowHeight = 90
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.backgroundColor = UIColor(red: 80.0/255.0, green: 0, blue: 0, alpha: 1.0)

        navigationItem.title = "Off-campus Food"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "onFilterButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")
        
        // Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor.whiteColor()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor(red: 80.0/255.0, green: 0, blue: 0, alpha: 1.0)
        var textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        businessTableView.tableHeaderView = searchController.searchBar
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        fetchBusinessesWithQuery(searchTerm, params: ["limit": "20"])
    }
    
    func extraLeftItemDidPressed(){
            let foodVC = storyboard?.instantiateViewControllerWithIdentifier("campusfood") as! CampusDiningViewController
//            var nav = UINavigationController(rootViewController: searchVC)
//            nav.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissVC")
//            nav.navigationBar.translucent = false
//    
            self.navigationController?.pushViewController(foodVC, animated: true)
    }
    
    private func fetchBusinessesWithQuery(query: String, params: [String: String] = [:]) {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        client.searchWithTerm(query, additionalParams: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let json = JSON(response)
            self.scrollOffset = self.businessLimit
            
            if let businessessArray = json["businesses"].array {
                self.businesses = Business.businessWithDictionaries(businessessArray)
            } else { // TODO: maybe don't clear out data when request doesn't work?
                self.businesses = []
            }
            
            self.businessTableView.reloadData()
            self.updateMapViewAnnotations()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error.description)
        }

    }
    
    private func fetchInfiniteScrollBusinessesWithQuery(query: String, params: [String: String] = [:]) {

        client.searchWithTerm(query, additionalParams: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let json = JSON(response)
            
            if let businessessArray = json["businesses"].array {
                self.businesses.extend(Business.businessWithDictionaries(businessessArray))
            }
            
            self.businessTableView.reloadData()

            self.scrollOffset += 20
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error.description)
        }

    }
    
    //MARK - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
     }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var spacing = UIView()
        spacing.backgroundColor = UIColor(red: 80.0/255.0, green: 0, blue: 0, alpha: 1.0)
        return spacing
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessCell
        cell.setBusiness(businesses[indexPath.section], forIndex: indexPath.section)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // segue to detailviewcontroller
        self.businessTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController

        detailsViewController.business = self.businesses[indexPath.row]
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - businessTableView.frame.height
        if actualPosition >= contentHeight {

            fetchInfiniteScrollBusinessesWithQuery(searchTerm, params: ["limit" : "\(self.businessLimit)", "offset": "\(self.scrollOffset)"])
        }
    }
    
    private func updateMapViewAnnotations() {
        businessMapView.removeAnnotations(businessMapView.annotations)
        businessMapView.addAnnotations(businesses)
        businessMapView.showAnnotations(businesses, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("MapViewAnnotation")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true
            
            let imageView = UIImageView(frame: CGRectMake(0, 0, 46, 46))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.sd_setImageWithURL(NSURL(string:(annotation as! Business).imageURL!))
            view.leftCalloutAccessoryView = imageView
            let disclosureButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            view.rightCalloutAccessoryView = disclosureButton
        }
        
        view.annotation = annotation
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailsViewController.business = view.annotation as! Business

        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchTerm = searchController.searchBar.text
        fetchBusinessesWithQuery(searchTerm)
    }
    
    func onFilterButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filtersViewController = storyboard.instantiateViewControllerWithIdentifier("FiltersTableViewController") as! FiltersTableViewController
        filtersViewController.delegate = self
        let nvc = UINavigationController(rootViewController: filtersViewController)
        presentViewController(nvc, animated: true, completion: nil)
        
    }
    
    func onListButton() {
        UIView.transitionFromView(businessMapView, toView: businessTableView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "onMapButton")

    }
    
    func onMapButton() {
        UIView.transitionFromView(businessTableView, toView: businessMapView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        updateMapViewAnnotations()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .Plain, target: self, action: "onListButton")
    }
    
    func filtersViewController(filtersViewController: FiltersTableViewController, didChangeFilters filters: [String : String]) {
        println("Fire new network event: \(filters)")
        fetchBusinessesWithQuery(searchTerm, params: filters)
    }

}

