//
//  SuperDBDateCell.swift
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

let __dateFormatter = NSDateFormatter()

class SuperDBDateCell: SuperDBEditCell {

    private var datePicker: UIDatePicker!
    //lazy var __dateFormatter = NSDateFormatter()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        __dateFormatter.dateStyle = .MediumStyle
        
        self.textField.clearButtonMode = .Never
        self.datePicker = UIDatePicker(frame: CGRectZero)
        self.datePicker.datePickerMode = .Date
        self.datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
        self.textField.inputView = self.datePicker
    }
    
    //MARK: - SuperDBEditCell Overrides
    override var value:AnyObject! {
        get{
            if self.textField.text == nil || count(self.textField.text) == 0 {
                return nil
            } else {
                return self.datePicker.date as NSDate
            }
        }
        set{
            if let _value = newValue as? NSDate {
                self.datePicker.date = _value
                self.textField.text = __dateFormatter.stringFromDate(_value)
            } else {
                self.textField.text = nil
            }
        }
    }
    
    
    //MARK: (Private) Instance Methods
    @IBAction func datePickerChanged(sender: AnyObject){
        var date = self.datePicker.date
        self.value = date
        self.textField.text = __dateFormatter.stringFromDate(date)
    }
}
