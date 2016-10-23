//
//  SuperDBPickerCell.swift
//  SuperDB
//
//  Created by Jayant Varma on 17/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_4
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit

class SuperDBPickerCell: SuperDBEditCell, UIPickerViewDataSource, UIPickerViewDelegate {

    var values:[AnyObject]! = []
    var picker: UIPickerView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textField.clearButtonMode = .Never
        
        self.picker = UIPickerView(frame: CGRectZero)
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.showsSelectionIndicator = true

        self.textField.inputView = self.picker
    }
    
    //MARK: - UIPickerViewDataSource Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.values.count
    }
    
    //MARK: - UIPickerViewDelegate Methods
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.values[row] as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.value = self.values[row]
    }
    
    //MARK: - SuperDBEditCell Overrides
    
    override var value: AnyObject! {
        get {
            return self.textField.text as String!
        }
        set {
            if newValue != nil {
                var index = (self.values as NSArray).indexOfObject(newValue)
                if index != NSNotFound {
                    self.textField.text = newValue as String!
                }
            } else {
                self.textField.text = nil
            }
        }
    }
    
}
