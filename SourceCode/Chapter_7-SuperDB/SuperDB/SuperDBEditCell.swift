//
//  SuperDBEditCell.swift
//  SuperDB
//
//  Created by Jayant Varma on 17/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_7
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit
import CoreData

let kLabelTextColor = UIColor(red: 0.321569, green: 0.4, blue: 0.568627, alpha: 1)

let __CoreDataErrors: NSDictionary = {
    var pList:NSURL = NSBundle.mainBundle().URLForResource("CoreDataErrors", withExtension:"plist")!
    var dict = NSDictionary(contentsOfURL: pList)
    return dict!
    }()


class SuperDBEditCell: UITableViewCell, UITextFieldDelegate {

    var label: UILabel!
    var textField: UITextField!
    var key: String!
    var hero: NSManagedObject!
    
    //MARK: - Property Overrides
    var value: AnyObject! {
        get{
            return self.textField.text
        }
        
        set {
            if let _value = newValue as? String {
                self.textField.text = newValue as? String
            }else if let _value = newValue as? NSDate {
                self.textField.text = __dateFormatter.stringFromDate(newValue as NSDate)
            }else if let _value = newValue as? NSNumber {
                self.textField.text = String(newValue as Int)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None

        self.label = UILabel(frame: CGRectMake(12, 15, 67, 15))
        self.label.backgroundColor = UIColor.clearColor()
        self.label.font = UIFont.boldSystemFontOfSize(UIFont.smallSystemFontSize())
        self.label.textColor = kLabelTextColor
        self.label.text = "label"
        self.contentView.addSubview(self.label)
        
        self.textField = UITextField(frame: CGRectMake(93, 13, 170, 19))
        self.textField.backgroundColor = UIColor.clearColor()
        self.textField.clearButtonMode = .WhileEditing
        self.textField.enabled = false
        self.textField.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        self.textField.text = "Title"
        self.textField.delegate = self
        self.textField.enabled = true
        self.contentView.addSubview(self.textField)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func isEditable() -> Bool {
        return true
    }
    
    override init() {
        super.init()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField.enabled = editing && isEditable()

//        if self.isEditable() {
//            self.textField.enabled = editing
//        }
    }

    //MARK: - UITextFieldDelegate Methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.validate()
    }
    
    func setValue(aValue:AnyObject){
        if let _aValue = aValue as? String{
            self.textField.text = _aValue
        } else {
            self.textField.text = aValue.description
        }
    }
    
    //MARK: - Instance Methods
    @IBAction func validate(){
        var val:AnyObject? = self.value
        var error: NSError? = nil
        if !self.hero.validateValue(&val, forKey: self.key, error: &error) {
            var message: String!
            if error?.domain == "NSCocoaErrorDomain" {
                var userInfo:NSDictionary? = error?.userInfo
                var errorKey = userInfo?.valueForKey("NSValidationErrorKey") as String
                var errorCode:Int = error!.code
                var reason = __CoreDataErrors.valueForKey("\(errorCode)") as String
                message = NSLocalizedString("Validation error on \(errorKey)\rFailure Reason: \(reason)",
                    comment: "Validation error on \(errorKey)\rFailure Reason: \(reason)")
            } else {
                message = error?.localizedDescription
            }
            var title = NSLocalizedString("Validation Error",
                comment: "Validation Error")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let fixAction = UIAlertAction(title: "Fix", style: .Default, handler: {
                _ in
                var result = self.textField.becomeFirstResponder()
            })
            alert.addAction(fixAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
                _ in
                self.setValue(self.hero.valueForKey(self.key)!)
            }
            alert.addAction(cancelAction)
            
            //self.textField.resignFirstResponder()
            
//            if let _func = self.theFunc{
//                _func(alert)
//            }

            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}


