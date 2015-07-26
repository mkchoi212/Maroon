//
//  YellCell.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class YellCell: UICollectionViewCell {
  
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.masksToBounds = true
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
}
