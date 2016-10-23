//
//  SuperDBNonEditable.swift
//  SuperDB
//
//  Created by Jayant Varma on 18/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_8
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit

class SuperDBNonEditableCell: SuperDBEditCell {

    override func isEditable() -> Bool {
        return false
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        self.textField.enabled = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
