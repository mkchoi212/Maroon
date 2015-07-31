//
//  CreditTableViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/30/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class CreditViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textview: UITextView!
    
    override func viewDidLoad() {
        let RTFPath = NSBundle.mainBundle().pathForResource("text", ofType: "rtf")!
        let RTFData = NSData(contentsOfFile: RTFPath)!
        let options = [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType]

        textview.attributedText = NSAttributedString(data: RTFData, options: options, documentAttributes: nil, error: nil)
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let webVC = mainSB.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.urlString = URL.absoluteString!
        navigationController?.pushViewController(webVC, animated: true)
        return false
    }
}
