
//
//  dummy.swift
//  SuperDB
//
//  Created by Jayant Varma on 24/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

import UIKit

class dummy {
   
    init(){

    var url:NSURL? = NSBundle.mainBundle().URLForResource("NoBackup", withExtension: "txt")
    var error: NSError? = nil
    var success = url?.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey, error: &error)

    }
    
}
