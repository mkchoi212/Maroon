//
//  HomeNewsTableViewCell.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 8/9/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class HomeNewsTableViewCell: UITableViewCell {
    
    @IBOutlet var newsCategory: UILabel!
    @IBOutlet var newsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.newsTitle.textColor = UIColor.blackColor()
        self.newsTitle.numberOfLines = 0
        self.newsTitle.sizeToFit()
    }
}
