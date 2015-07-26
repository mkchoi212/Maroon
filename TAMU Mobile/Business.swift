//
//  Business.swift
//  Yelp
//
//  Created by Kristen on 2/9/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//
import MapKit

class Business : NSObject, MKAnnotation {
    
    var categories: String
    var name: String
    var address: String
    var displayAddress: String
    var latitude: Double?
    var longitude: Double?
    var numberOfReviews: Int
    var imageURL: String?
    var ratingImageUrl: String?
    var distance: Double
    var displayPhone: String?
    var phoneNumber: String?
    var recomendedReviewImageUrl: String?
    var recomendedReviewText: String?
    var closed : NSNumber?
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
    }
    
    var title: String {
        get {
            return name
        }
    }
    
    init(json: JSON) {
        var categoryNames = [String]()
        
        if var categoryArray = json["categories"].array {
            categoryNames = categoryArray.map { array in
                if var category = array[0].string {
                    return category
                }
                return ""
            }
        }
        
        self.categories = ", ".join(categoryNames)
        
        if var name = json["name"].string {
            self.name = name
        } else {
            self.name = ""
        }
        
        if var imageURL = json["image_url"].string {
            self.imageURL = imageURL
        }
        
        self.displayAddress = ""
        self.address = ""
        if let location = json["location"].dictionary {
            if let street = location["address"]?[0].string {
                if let neighborhood = location["neighborhoods"]?[0].string {
                    self.address = "\(street), \(neighborhood)"
                } else {
                    self.address = street
                }
                if let city = location["city"]?.string {
                    if let state = location["state_code"]?.string {
                        if let zipCode = location["postal_code"]?.string {
                            self.displayAddress = "\(street), \(city) \(state) \(zipCode)"
                        } else {
                            self.displayAddress = "\(street), \(city) \(state)"
                        }
                    } else {
                        self.displayAddress = "\(street), \(city)"
                    }
                    
                } else {
                    self.displayAddress = "\(street)"
                }
            }
            
            if let coordinate = location["coordinate"]?.dictionary {
                if let latitude = coordinate["latitude"]?.number {
                    self.latitude = latitude.doubleValue
                }
                if let longitude = coordinate["longitude"]?.number {
                    self.longitude = longitude.doubleValue
                }
            }
        }
        
        if let numberOfReviews = json["review_count"].int {
            self.numberOfReviews = numberOfReviews
        } else {
            self.numberOfReviews = 0
        }
        
        if let ratingImageUrl = json["rating_img_url_large"].string {
            self.ratingImageUrl = ratingImageUrl
        }
        
        let milesPerMeter = 0.0006213171
        if let distance = json["distance"].int {
            self.distance = Double(distance) * milesPerMeter
        } else {
            self.distance = 0
        }
        
        if let displayPhone = json["display_phone"].string {
            self.displayPhone = displayPhone
        }
        
        if let isClosed = json["is_closed"].bool {
            self.closed = isClosed
        }
        
        if let phoneNumber = json["phone"].string {
            self.phoneNumber = phoneNumber
        }
        
        if let recomendedReviewImageUrl = json["snippet_image_url"].string {
            self.recomendedReviewImageUrl = recomendedReviewImageUrl
        }
        
        if let recomendedReviewText = json["snippet_text"].string {
            self.recomendedReviewText = recomendedReviewText
        }
    }
    
    class func businessWithDictionaries(jsonArray: [JSON]) -> [Business] {
        return jsonArray.map { Business(json: $0) }
    }
}