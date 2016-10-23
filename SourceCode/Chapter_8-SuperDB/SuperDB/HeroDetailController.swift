//
//  HeroDetailController.swift
//  SuperDB
//
//  Created by Jayant Varma on 19/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_8
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit
import CoreData

class HeroDetailController: ManagedObjectController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.config = ManagedObjectConfiguration(resource: "HeroDetailConfiguration")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View DataSource
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.removeRelationshipObjectInIndexPath(indexPath)
        } else if editingStyle == .Insert {
            var newObject = self.addRelationshipObjectForSection(indexPath.section) as NSManagedObject
            self.performSegueWithIdentifier("PowerViewSegue", sender: newObject)
        }
        
        super.tableView(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }
    
    //MARK: - Table view Delegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        var key = self.config.attributeKeyForIndexPaths(indexPath) as String
        
//        var relationshipSet = self.managedObject.mutableSetValueForKey(key) as NSMutableSet
//        var relationshipObject = relationshipSet.allObjects[indexPath.row] as NSManagedObject
//        self.performSegueWithIdentifier("PowerViewSegue", sender: relationshipObject)
        
        var entity = self.managedObject.entity as NSEntityDescription
        var properties = entity.propertiesByName as NSDictionary
        var property = properties.objectForKey(key) as NSPropertyDescription
        
        if let _attr = property as? NSRelationshipDescription {
            var relationshipSet = self.managedObject.mutableSetValueForKey(key) as NSMutableSet
            var relationshipObject = relationshipSet.allObjects[indexPath.row] as NSManagedObject
            self.performSegueWithIdentifier("PowerViewSegue", sender: relationshipObject)
        } else if let _attr = property as? NSFetchedPropertyDescription {
            var fetchedProperties = self.managedObject.valueForKey(key) as NSArray
            self.performSegueWithIdentifier("ReportViewSegue", sender: fetchedProperties)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PowerViewSegue" {
            if let _sender = sender as? NSManagedObject {
                var detailController = segue.destinationViewController as ManagedObjectController
                detailController.managedObject = _sender
                
                queryAverageAge()
                
            } else {
                //Show Alert Error
            }
        } else if segue.identifier == "ReportViewSegue" {
            if let _sender = sender as? NSArray {
                var reportController = segue.destinationViewController as HeroReportController
                reportController.heros = _sender
            } else {
                //showAlert Error
            }
        }
    }
    
    
    func queryAverageAge(){
        var ex = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "birthDate")])
        var pred = NSPredicate(format: "sex == 'Female'")
        var ed = NSExpressionDescription()
        ed.name = "averageBirthDate"
        ed.expression = ex
        ed.expressionResultType = .DateAttributeType
        
        var properties = [ed]
        
        var request = NSFetchRequest() as NSFetchRequest
        request.predicate = pred
        request.propertiesToFetch = properties
        request.resultType = .DictionaryResultType
        
        var context = self.managedObject.managedObjectContext!
        var entity = NSEntityDescription.entityForName("Hero", inManagedObjectContext: context)

        request.entity = entity
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)! 
        var date = results[0].valueForKey(ed.name) as NSDate
        println(">> Average birthdates for female heros: \(date)")
    }
    
    
}
