//
//  HeroDetailController.swift
//  SuperDB
//
//  Created by Jayant Varma on 17/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_8
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit
import CoreData

enum HeroEditControllerSections: Int {
    case Name
    case General
    case Count
}

enum HeroEditControllerName: Int {
    case Row
    case Count
}

enum HeroEditControllerGeneralSection: Int {
    case SecretIdentityRow
    case BirthdayRow
    case SexRow
    case Count
}

class ManagedObjectController: UITableViewController {

    var saveButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var sections:[AnyObject]!

    var config: ManagedObjectConfiguration!

    var managedObject: NSManagedObject!
    
    func updateDynamicSections(editing: Bool){
        var section: Int
        for (section=0; section < self.config.numberOfSections(); section++){
            if self.config.isDynamicSection(section){
                var indexPath:NSIndexPath
                var row = self.tableView.numberOfRowsInSection(section)
                if editing{
                    indexPath = NSIndexPath(forRow: row, inSection: section)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                } else {
                    indexPath = NSIndexPath(forRow: row-1, inSection: section)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    // MARK: - Class Functions - GUI Based
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
        
        self.backButton = self.navigationItem.leftBarButtonItem
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        
        
//        var pListURL = NSBundle.mainBundle().URLForResource("HeroDetailConfiguration", withExtension: "plist")
//        var pList = NSDictionary(contentsOfURL: pListURL!)
//        self.sections = pList?.valueForKey("sections") as NSArray
        
        self.config = ManagedObjectConfiguration(resource: "HeroDetailConfiguration")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView related functions
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var section = indexPath.section
//        var row = indexPath.row
//        
//        switch section {
//            case HeroEditControllerSections.Name.rawValue:
//                switch row {
//                    case HeroEditControllerName.Row.rawValue:
//                        //Create a controller to edit name
//                        // push it on the stack
//                        ()
//                    default:
//                        ()
//                }
//            case HeroEditControllerSections.General.rawValue:
//                switch row {
//                    case HeroEditControllerGeneralSection.SecretIdentityRow.rawValue:
//                        ()
//                    case HeroEditControllerGeneralSection.BirthdayRow.rawValue:
//                        ()
//                    case HeroEditControllerGeneralSection.SexRow.rawValue:
//                        ()
//                    default:
//                        ()
//                }
//            default:
//                ()
//        }
//    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        self.tableView.beginUpdates()
        self.updateDynamicSections(editing)
        super.setEditing(editing, animated: animated)
        self.tableView.endUpdates()
        
        self.navigationItem.rightBarButtonItem = editing ? self.saveButton : self.editButtonItem()
        self.navigationItem.leftBarButtonItem = editing ? self.cancelButton : self.backButton
        
        self.tableView.reloadData()
    }
    
    //MARK: - (Private) Instance Methods
    
    func save() {
        for cell in self.tableView.visibleCells() {
            let _cell = cell as SuperDBEditCell
            if _cell.isEditable() {
                self.managedObject.setValue(_cell.value, forKey: _cell.key)
            }
            
            self.saveManagedObjectContext()
        }
        
        self.setEditing(false, animated: true)
        
        self.tableView.reloadData()
    }
    
    func cancel() {
        self.setEditing(false, animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        //return self.sections.count
        return self.config.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        //return self.config.numberOfRowsInSection(section)
        var rowCount = self.config.numberOfRowsInSection(section)
        if self.config.isDynamicSection(section){
            if let key = self.config.dynamicAttributeKeyForSection(section) {
                var attributedSet = self.managedObject.mutableSetValueForKey(key) as NSSet
                rowCount = attributedSet.count
                rowCount = self.editing ? attributedSet.count + 1 : attributedSet.count
            }
        }
        
        return rowCount
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {       
        return self.config.headerInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //var row = self.config.rowForIndexPath(indexPath)
        var row = self.config.rowForIndexPath(indexPath)
        //var dataKey = row.objectForKey("key") as String!
        var dataKey = self.config.attributeKeyForIndexPaths(indexPath)
        
        //var cellClassName = row.valueForKey("class") as String
        var cellClassName = self.config.cellClassnameForIndexPath(indexPath)
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellClassName) as? SuperDBEditCell
        if cell == nil {
            switch cellClassName {
                case "SuperDBDateCell":
                    cell = SuperDBDateCell(style: .Value2, reuseIdentifier: cellClassName)
                case "SuperDBColorCell":
                    cell = SuperDBColorCell(style: .Value2, reuseIdentifier: cellClassName)
                case "SuperDBPickerCell":
                    cell = SuperDBPickerCell(style: .Value2, reuseIdentifier: cellClassName)
                case "SuperDBNonEditableCell":
                    cell = SuperDBNonEditableCell(style: .Value2, reuseIdentifier: cellClassName)
                default:
                    cell = SuperDBEditCell(style: .Value2, reuseIdentifier: cellClassName)
            }
        }
        
        cell?.hero = self.managedObject
        cell?.key = dataKey
        cell?.label.text = self.config.labelForIndexPath(indexPath)
        var theData:AnyObject? = self.managedObject.valueForKey(dataKey)

        if let _cell = cell as? SuperDBPickerCell {
            _cell.values = self.config.valuesForIndexPath(indexPath)
        }

        cell?.textField.text = nil
        cell?.value = theData
        
        if self.config.isDynamicSection(indexPath.section) {
            var relationshipSet = self.managedObject.mutableSetValueForKey(dataKey)
            var relationshipArray = relationshipSet.allObjects as NSArray
            if indexPath.row != relationshipArray.count{
                var relationshipObject = relationshipArray.objectAtIndex(indexPath.row) as NSManagedObject
                cell?.value = relationshipObject.valueForKey("name")
                cell?.accessoryType = .DetailDisclosureButton
                cell?.editingAccessoryType = .DetailDisclosureButton
            }else {
                cell?.label.text = nil
                cell?.textField.text = "Add New Power ..."
            }
        }else {
            if let value = self.config.rowForIndexPath(indexPath).objectForKey("value") as? String {
                cell?.value = value
                cell?.accessoryType = .DetailDisclosureButton
                cell?.editingAccessoryType = .DetailDisclosureButton
            } else {
                cell?.value = theData
            }

            if let _theDate = theData as? NSDate {
                cell?.textField.text = __dateFormatter.stringFromDate(_theDate)
            }else if let _color = theData as? UIColor {
                if let _cell = cell as? SuperDBColorCell {
                    _cell.value = _color
                    _cell.textField.attributedText = _cell.attributedColorString
                }
            } else {
                if let res = cell?.value as? String{
                    cell?.textField.text = res
                } else {
                    cell?.textField.text = theData?.description
                }
            }
        }
        
        return cell!
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        //return .None
        var editStyle:UITableViewCellEditingStyle = .None
        var section = indexPath.section
        if self.config.isDynamicSection(section) {
            var rowCount = self.tableView.numberOfRowsInSection(section)
            if indexPath.row == rowCount - 1 {
                editStyle = .Insert
            } else {
                editStyle = .Delete
            }
        }
        return editStyle
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var num: NSNumber = 0
        
//        var key = self.config.attributeKeyForIndexPaths(indexPath)
//        var relationshipSet = self.managedObject.mutableSetValueForKey(key)
//        var managedObjectContext = self.managedObject.managedObjectContext as NSManagedObjectContext?
//        
//        if editingStyle == .Delete {
//            var relationshipObject = relationshipSet.allObjects[indexPath.row] as NSManagedObject
//            relationshipSet .removeObject(relationshipObject)
//        } else if editingStyle == .Insert {
//            var entity = self.managedObject.entity
//            var relationships = entity.relationshipsByName as NSDictionary
//            var destRelationship = relationships.objectForKey(key) as NSRelationshipDescription
//            var destEntity = destRelationship.destinationEntity as NSEntityDescription?
//            
//            var relationshipObject = NSEntityDescription.insertNewObjectForEntityForName(destEntity!.name!, inManagedObjectContext: managedObjectContext!) as NSManagedObject
//            relationshipSet.addObject(relationshipObject)
//        }
//        
//        var error:NSError? = nil
//        if !managedObjectContext!.save(&error){
//            //alert
//        }
        
        if editingStyle == .Delete {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else if editingStyle == .Insert {
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func saveManagedObjectContext(){
        var error: NSError? = nil
        self.managedObject.managedObjectContext?.save(&error)
        if error != nil{
            println("Error saving : \(error?.localizedDescription)")
        }
    }
    
    //MARK: - Instance Methods
    
    func addRelationshipObjectForSection(section: Int) -> NSManagedObject {
        println(">>>> ADDRELATIONSHIP<<<<")
        
        var key = self.config.dynamicAttributeKeyForSection(section)
        var relationshipSet = self.managedObject.mutableSetValueForKey(key!) as NSMutableSet
        var entity = self.managedObject.entity
        var relationships = entity.relationshipsByName as NSDictionary
        var destRelationship = relationships.objectForKey(key!) as NSRelationshipDescription
        var destEntity = destRelationship.destinationEntity as NSEntityDescription?
        var relationshipObject = NSEntityDescription.insertNewObjectForEntityForName(destEntity!.name!, inManagedObjectContext: self.managedObject.managedObjectContext!) as NSManagedObject

        relationshipSet.addObject(relationshipObject)
        self.saveManagedObjectContext()
        
        return relationshipObject
    }
    
    func removeRelationshipObjectInIndexPath(indexPath: NSIndexPath) {
        println(">>>> REMOVERELATIONSHIP<<<<")
        
        var key = self.config.dynamicAttributeKeyForSection(indexPath.section)
        var relationshipSet = self.managedObject.mutableSetValueForKey(key!) as NSMutableSet
        var relationshipObject = relationshipSet.allObjects[indexPath.row] as NSManagedObject
        relationshipSet.removeObject(relationshipObject)
        self.saveManagedObjectContext()
        
    }
    
    

}
