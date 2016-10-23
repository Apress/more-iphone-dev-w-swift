//
//  ViewController.swift
//  SpeechSynth
//
//  Created by Jayant Varma on 29/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//
// Code : Chapter_12
// Book: More iOS Development with Swift, Apress 2015
//


// NOTE: This will also work with the simulator

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string:"")
    
    @IBAction func speak(sender: AnyObject) {
        myUtterance = AVSpeechUtterance(string:"Hello Humans, How are you?")
        myUtterance.rate = 0.3
        
        synth.speakUtterance(myUtterance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

