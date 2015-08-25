//
//  ScrollContentViewController.swift
//  Maroon
//
//  Created by Mike Choi on 8/25/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import UIKit

class ScrollContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var pageIndex: Int!
    var imageFile: String!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: self.imageFile)
    }
}
