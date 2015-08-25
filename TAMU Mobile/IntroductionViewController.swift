//
//  IntroductionViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 8/6/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class IntroductionViewController: VideoSplashViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("am", ofType: "m4v")!)!
        self.videoFrame = view.frame
        self.fillMode = .AspectFill
        self.alwaysRepeat = true
        self.startTime = 0
        self.duration = 19.0
        self.alpha = 0.7
        self.backgroundColor = UIColor.blackColor()
        self.contentURL = url
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    
       // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorialSeen")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tutorialButton.layer.cornerRadius = 5.0
        homeButton.layer.cornerRadius = 5.0
    
    }
    
    @IBAction func showTutorial(sender: AnyObject) {
        modalPresentationStyle = .Custom
        var modalVC = storyboard?.instantiateViewControllerWithIdentifier("tutorialVC") as! TutorialViewController
        modalVC.transitioningDelegate = AG_blurTransitionDelegate
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
    @IBAction func goHome(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        presentViewController(delegate.setupAnimatedTabBar(), animated: true, completion: nil)
//        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorialSeen")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }
        else if (status == CLAuthorizationStatus.Denied){
            let alertVC = UIAlertController(title: "Background Location Access Disabled", message: "In order to be see your location on the map, please open this app's settings and set location access to 'When In Use'.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil)
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(openAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
        else if (status == CLAuthorizationStatus.NotDetermined){
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
