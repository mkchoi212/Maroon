//
//  HomeViewController.swift
//  Pantry
//
//  Created by Mike Choi on 7/25/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import UIKit
import FoldingTabBar


class HomeViewController: UIViewController, YALTabBarInteracting{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }

    func extraRightItemDidPressed(){
        let tamuVC = storyboard?.instantiateViewControllerWithIdentifier("tamu") as! TamuMenuViewController
        self.navigationController?.pushViewController(tamuVC, animated: true)
    }

    func dismissVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
