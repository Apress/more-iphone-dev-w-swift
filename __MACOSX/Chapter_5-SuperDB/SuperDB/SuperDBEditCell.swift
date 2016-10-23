//
//  SuperDBEditCell.swift
//  SuperDB
//
//  Created by Jayant Varma on 17/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_5
// Book: More iOS Development with Swift, Apress 2015
//
// Updated: For Swift 1.2



import UIKit

let kLabelTextColor = UIColor(red: 0.321569, green: 0.4, blue: 0.568627, alpha: 1)

class SuperDBEditCell: UITableViewCell {

    var label: UILabel!
    var textField: UITextField!
    var key: String!
    
    //MARK: - Property Overrides
    var value: AnyObject! {
        get{
            return self.textField.text as String
        }
        
        set {
            self.textField.text = newValue as? String
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
        self.contentView.addSubview(self.textField)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField.enabled = editing
    }
    
}


