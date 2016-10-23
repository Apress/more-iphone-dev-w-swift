//
//  HeroDetailConfiguration.swift
//  SuperDB
//
//  Created by Jayant Varma on 19/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_7
// Book: More iOS Development with Swift, Apress 2015
//
// Updated: For Swift 1.2


import UIKit

class ManagedObjectConfiguration: NSObject {
    var sections:[AnyObject]!
    
    init(resource: String) {
        super.init()
        var pListURL = NSBundle.mainBundle().URLForResource(resource, withExtension: "plist")!
        var pList = NSDictionary(contentsOfURL: pListURL) as NSDictionary!
        self.sections = pList.valueForKey("sections") as! [AnyObject]
    }

    func numberOfSections() -> Int {
        return self.sections.count
    }

    func numberOfRowsInSection(section: Int) -> Int{
        var sectionDict = self.sections[section] as! NSDictionary
        if let rows = sectionDict.objectForKey("rows") as? NSArray {
            return rows.count
        }
        return 0
    }

    func headerInSection(section: Int) -> String? {
        var sectionDict = self.sections[section] as! NSDictionary
        return sectionDict.objectForKey("header") as? String
    }
    
    func rowForIndexPath(indexPath: NSIndexPath) -> NSDictionary{
        var sectionIndex = indexPath.section
        
        if self.sections.count < sectionIndex { return NSDictionary() }
        
        //var rowIndex = indexPath.row
        var rowIndex = self.isDynamicSection(sectionIndex) ? 0 : indexPath.row
        var section = self.sections[sectionIndex] as! NSDictionary
        var rows = section.objectForKey("rows") as! NSArray
        var row = rows.objectAtIndex(rowIndex) as! NSDictionary
        return row
    }
    
    func cellClassnameForIndexPath(indexPath: NSIndexPath) -> String {
        var row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.objectForKey("class") as! String
        //return getObjectForKey("class", indexPath: indexPath) as String
    }
    
    func valuesForIndexPath(indexPath: NSIndexPath) -> NSArray? {
        var row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.objectForKey("values") as? NSArray
        //return getObjectForKey("values", indexPath: indexPath) as NSArray
    }
    
    func attributeKeyForIndexPaths(indexPath: NSIndexPath) -> String {
        var row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.objectForKey("key") as! String
        //return getObjectForKey("key", indexPath: indexPath) as String
    }
    
    func labelForIndexPath(indexPath: NSIndexPath) -> String {
        var row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.objectForKey("label") as! String
        //return getObjectForKey("label", indexPath: indexPath) as String
    }
    
    func getObjectForKey(key: String, indexPath:NSIndexPath) -> AnyObject? {
        var row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.objectForKey("values")
    }
    
    func isDynamicSection(section: Int) -> Bool{
        var dynamic = false
        var sectionDict = self.sections[section] as! NSDictionary
        if let dynamicNumber = sectionDict.objectForKey("dynamic") as? NSNumber{
            dynamic = dynamicNumber.boolValue
        }
        return dynamic
    }
    
    func dynamicAttributeKeyForSection(section: Int) -> String? {
        if !self.isDynamicSection(section) {
            return nil
        }
        var indexPath = NSIndexPath(forRow: 0, inSection: section)
        return self.attributeKeyForIndexPaths(indexPath)
    }
    
}
