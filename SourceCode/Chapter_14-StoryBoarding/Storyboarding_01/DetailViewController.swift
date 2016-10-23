//
//  DetailViewController.swift
//  Storyboarding_01
//
//  Created by Jayant Varma on 1/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_14
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var theButton:UIButton!
    
    var theText: String!
    var hideButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theLabel.text = theText
        theButton.hidden = hideButton
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissButton(sender:AnyObject){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
