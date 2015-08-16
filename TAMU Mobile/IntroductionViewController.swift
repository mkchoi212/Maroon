//
//  IntroductionViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 8/6/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import FoldingTabBar
import SKPanoramaView

class IntroductionViewController: UIViewController, MYIntroductionDelegate, CLLocationManagerDelegate {
    
    var introductionView = MYIntroductionView()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpParallaxBackground()
        animateLabel()
        
    }
    
    func setUpParallaxBackground(){
        var panoramaView = SKPanoramaView(frame: view.frame, image: UIImage(named: "kyle"))
        panoramaView.animationDuration = 90.0
        view.addSubview(panoramaView)
        panoramaView.startAnimating()

    }

    func animateLabel(){
        var titleLabel = UILabel(frame: CGRectMake(0, self.view.bounds.height/2-self.view.bounds.height/5, self.view.bounds.width, self.view.bounds.height/4))
        self.view.addSubview(titleLabel)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "MAROON"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(60)
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            titleLabel.frame = CGRectMake(0, 15, titleLabel.bounds.width, titleLabel.bounds.height)
        }) { (Bool) -> Void in
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.introductionPanels()
        }
    }
    
    func introductionDidFinishWithType(finishType: MYFinishType) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        presentViewController(delegate.setupAnimatedTabBar(), animated: true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorialSeen")
    }

    
    func introductionDidChangeToPanel(panel: MYIntroductionPanel!, withIndex panelIndex: Int) {
        if panelIndex == 4{
            introductionView.SkipButton.setTitle("Home", forState: UIControlState.Normal)
        }
    }
    
    func introductionPanels() {
        let panel1 = MYIntroductionPanel(withimage: UIImage(named: "panel1"), title: "WELCOME", description: "Welcome Ag!")
        let panel2 = MYIntroductionPanel(withimage: UIImage(named: "panel2"), title: "DISCOVER", description: "Discover the A&M'S campus in a new way")
        let panel3 = MYIntroductionPanel(withimage: UIImage(named: "panel3"), title: "FOOD", description: "Finding food in cstat has never been easier")
        let panel4 = MYIntroductionPanel(withimage: UIImage(named: "panel4"), title: "ATHLETICS", description: "Aggie fan's ultimate tool")
        let panel5 = MYIntroductionPanel(withimage: UIImage(named: "panel5"), title: "MORE", description: "There's much more to discover...")

        self.introductionView = MYIntroductionView(frame: CGRectMake(0, 30, self.view.bounds.width, self.view.bounds.height-55), headerText: "", panels: [panel1, panel2, panel3, panel4, panel5], languageDirection: MYLanguageDirectionLeftToRight)
        introductionView.HeaderImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        introductionView.HeaderLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        introductionView.HeaderView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        introductionView.PageControl.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        introductionView.SkipButton.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        introductionView.delegate = self
        introductionView.showInView(self.view, animateDuration: 2.0)
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
    
}
