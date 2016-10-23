//
//  HeroDetailController.swift
//  SuperDB
//
//  Created by Jayant Varma on 17/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_4
// Book: More iOS Development with Swift, Apress 2015
//
// Updated: For Swift 1.2


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

class HeroDetailController: UITableViewController {

    var saveButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var sections:[AnyObject]!
    var hero: NSManagedObject!
    
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
        
        
        var pListURL = NSBundle.mainBundle().URLForResource("HeroDetailConfiguration", withExtension: "plist")
        var pList = NSDictionary(contentsOfURL: pListURL!)
        self.sections = pList?.valueForKey("sections") as! [AnyObject]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView related functions
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var section = indexPath.section
        var row = indexPath.row
        
        switch section {
            case HeroEditControllerSections.Name.rawValue:
                switch row {
                    case HeroEditControllerName.Row.rawValue:
                        //Create a controller to edit name
                        // push it on the stack
                        ()
                    default:
                        ()
                }
            case HeroEditControllerSections.General.rawValue:
                switch row {
                    case HeroEditControllerGeneralSection.SecretIdentityRow.rawValue:
                        ()
                    case HeroEditControllerGeneralSection.BirthdayRow.rawValue:
                        ()
                    case HeroEditControllerGeneralSection.SexRow.rawValue:
                        ()
                    default:
                        ()
                }
            default:
                ()
        }
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.rightBarButtonItem = editing ? self.saveButton : self.editButtonItem()
        self.navigationItem.leftBarButtonItem = editing ? self.cancelButton : self.backButton
    }
    
    //MARK: - (Private) Instance Methods
    
    func save() {
        self.setEditing(false, animated: true)
        
        for cell in self.tableView.visibleCells() {
            let _cell = cell as! SuperDBEditCell
            self.hero.setValue(_cell.value, forKey: _cell.key)

            var error: NSError?
            self.hero.managedObjectContext?.save(&error)
            if error != nil{
                println("Error saving : \(error?.localizedDescription)")
            }
        }
        
        self.tableView.reloadData()
        // This makes the animation of moving out of edit state adrupt
    }
    
    func cancel() {
        self.setEditing(false, animated: true)
    }
    
    
    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    */

    /**/
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var sectionIndex = indexPath.section
        var rowIndex = indexPath.row
        var _sections = self.sections as NSArray
        var section = _sections.objectAtIndex(sectionIndex) as! NSDictionary
        var rows = section.objectForKey("rows") as! NSArray
        var row = rows.objectAtIndex(rowIndex) as! NSDictionary
        var dataKey = row.objectForKey("key") as! String
        
//        let cellIdentifier = "SuperDBEditCell" //"HeroDetailCell"
//        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SuperDBEditCell
//        
//        if cell == nil {
//            cell = SuperDBEditCell(style: .Value2, reuseIdentifier: cellIdentifier)
//        }
//        
//        // Configure the cell...
//
//        cell?.label.text = row.objectForKey("label") as String!
//        cell?.textField.text = self.hero.valueForKey(dataKey) as String!
//        
//        cell?.key = dataKey

        var cellClassName = row.valueForKey("class") as! String
        var cell = tableView.dequeueReusableCellWithIdentifier(cellClassName) as? SuperDBEditCell
        if cell == nil {
            switch cellClassName {
                case "SuperDBDateCell":
                    cell = SuperDBDateCell(style: .Value2, reuseIdentifier: cellClassName)
                case "SuperDBPickerCell":
                    cell = SuperDBPickerCell(style: .Value2, reuseIdentifier: cellClassName)
                default:
                    cell = SuperDBEditCell(style: .Value2, reuseIdentifier: cellClassName)
            }
        }
        
        if let _values = row["values"] as? NSArray {
            (cell as! SuperDBPickerCell).values = _values as [AnyObject]
        }
        
        cell?.key = dataKey
        cell?.value = self.hero.valueForKey(dataKey)
        cell?.label.text = row.objectForKey("label") as! String!
        
        return cell!
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
