//
//  PowerViewController.swift
//  SuperDB
//
//  Created by Jayant Varma on 19/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_7
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit

class PowerViewController: ManagedObjectController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.config = ManagedObjectConfiguration(resource: "PowerViewConfiguration")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       
}
