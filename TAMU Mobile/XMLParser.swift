//
//  XMLParser.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/27/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//
import UIKit

@objc protocol XMLParserDelegate{
    func parsingWasFinished()
}

class XMLParser: NSObject, NSXMLParserDelegate {
    
    var arrParsedData = [Dictionary<String, String>]()
    var currentDataDictionary = Dictionary<String, String>()
    var currentElement = String()
    var foundCharacters = String()
    var delegate : XMLParserDelegate?
    
    
    func startParsingWithContentsOfURL(rssURL: NSURL) {
        let parser = NSXMLParser(contentsOfURL: rssURL)
        parser!.delegate = self
        parser!.parse()
    }
    

    //MARK: NSXMLParserDelegate method implementation
    
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parsingWasFinished()
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            
            if elementName == "link"{
                foundCharacters = (foundCharacters as NSString).substringFromIndex(0)
            }
            
            currentDataDictionary[currentElement] = foundCharacters
        
            if elementName == "pubDate"{
                currentDataDictionary[currentElement] = foundCharacters
            }

            foundCharacters = ""
            
            if currentElement == "description" {
                //remove rss title header
                if currentDataDictionary[currentElement]!.rangeOfString("Latest news") == nil{
                    arrParsedData.append(currentDataDictionary)
                }
            }
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == "title" || currentElement == "link" || currentElement == "description" || currentElement == "pubDate"{
            foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.description)
    }
    
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print(validationError.description)
    }
    
}
