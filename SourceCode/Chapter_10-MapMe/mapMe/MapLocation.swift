//
//  MapLocation.swift
//  mapMe
//
//  Created by Jayant Varma on 15/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_10
// Book: More iOS Development with Swift, Apress 2015
//


import Foundation
import MapKit

class MapLocation: NSObject, NSCoding, MKAnnotation {
    var street: String!
    var city: String!
    var state: String!
    var zip: String!
    var _coordinate: CLLocationCoordinate2D!
    
    //MARK: - MKAnnotation Protocol Methods
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return _coordinate
        }
        set {
            _coordinate = newValue
        }
    }
    
    var title: String {
        get {
            return NSLocalizedString("You are Here", comment: "You are Here")
        }
    }
    
    var subtitle: String {
        get {
        var result = ""

        if self.street != nil {
            result += self.street
            
            if self.city != nil || self.state != nil || self.zip != nil {
                result += ", "
            }
        }
        if self.city != nil {
            result += self.city
            
            if self.state != nil {
                result += ", "
            }
        }
        if self.state != nil {
            result += self.state
        }
        if self.zip != nil {
            result += " " + self.zip
        }
        
        return result
        }
    }
    
    //MARK: - NSCoder Protocol Methods
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.street, forKey: "street")
        aCoder.encodeObject(self.city, forKey: "city")
        aCoder.encodeObject(self.state, forKey: "state")
        aCoder.encodeObject(self.zip, forKey: "zip")
        }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.street = aDecoder.decodeObjectForKey("street") as? String
        self.city = aDecoder.decodeObjectForKey("city") as? String
        self.state = aDecoder.decodeObjectForKey("state") as? String
        self.zip = aDecoder.decodeObjectForKey("zip") as? String
    }

    override init() {
        super.init()
        //<#code#>
    }
    
}
