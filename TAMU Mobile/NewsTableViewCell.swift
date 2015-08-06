//
//  NewsTableViewCell.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/27/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    var link = String()
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.x += 15
            frame.size.width -= 2 * 15
            super.frame = frame
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}
