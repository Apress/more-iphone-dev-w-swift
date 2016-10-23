//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Jayant Varma on 27/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_13
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var error: NSError?
    var theData: NSData!
    var theURL: NSURL!
    var thePlayer: AVAudioPlayer!
    var recorder: AVAudioRecorder!
    
    @IBOutlet weak var theButton: UIButton!
    var isPlaying = false
    
    
    @IBOutlet weak var theTime: UILabel!
    
    @IBOutlet weak var PMPO: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: &error)
//        println(">>AVSession ERROR: \(error) - \(error?.localizedDescription)")

        // TODO: - Please add your own music file to the project and update the name accordingly
        
        var file = NSBundle.mainBundle().pathForResource("megamix", ofType: "mp3")
        
        // This assert is for you to remember to add your own MP3 file before you run the project.
        assert(file != nil)
        
        theURL = NSURL(fileURLWithPath: file!)
        
        thePlayer = AVAudioPlayer(contentsOfURL: theURL, error: &self.error)
        thePlayer.delegate = self
        thePlayer.enableRate = true
        
        thePlayer.meteringEnabled = true
        
        //thePlayer.numberOfLoops = 10
        
        thePlayer.prepareToPlay()
        
        // Comment if you do not want to update the Time and PMPO
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update:", userInfo: nil, repeats: true)
        
        // Make sure that the device is prepared for playback and recording
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
    }

    func update(sender: AnyObject){
        
        // Update the meters, if metering is enabled
        self.thePlayer.updateMeters()
        
        dispatch_async(dispatch_get_main_queue(), {
            var curr = "Time: ".stringByAppendingFormat("%0.2f", self.thePlayer.currentTime/60)
            curr = curr.stringByAppendingFormat(" / %0.2f", self.thePlayer.duration/60)
            self.theTime.text = curr //"\(self.thePlayer.currentTime) / \(self.thePlayer.duration)"
            self.PMPO.text = "\(self.thePlayer.peakPowerForChannel(0)) / \(self.thePlayer.peakPowerForChannel(1))"
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(sender:AnyObject){
        //thePlayer.playAtTime(thePlayer.duration)
        
        // Play rate of 1 = Normal, 1.5 is Faster and 0.5 is slower
        
        if isPlaying == false {
            thePlayer.rate = 1
            thePlayer.play()
            theButton.setTitle("Pause", forState:.Normal)
        } else {
            thePlayer.pause()
            theButton.setTitle("Play", forState: .Normal)
        }

        isPlaying = !isPlaying

    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println(">>\(flag)")
    }

    
    @IBAction func record(sender: AnyObject){

        //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: &self.error)
        //if AVAudioSession.sharedInstance().recordPermission()  == AVAudioSessionRecordPermission.Granted {
        
        let docsDir = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
        //var theFile = NSURL(string: docsDir.path!.stringByAppendingPathComponent("recording.wav"))
        var theFile = NSURL(string: "recording.wav", relativeToURL: docsDir)
    
        var settings = [AVSampleRateKey:44100, AVNumberOfChannelsKey:2, AVEncoderBitRateKey:16, AVEncoderAudioQualityKey:AVAudioQuality.High.rawValue]
    
        self.recorder = AVAudioRecorder(URL: theFile, settings: nil, error: &self.error)
        //println(">>>\(error), \(error?.localizedDescription)")
        
        //Change 10 for longer than 10 seconds or shorter recordings.
        self.recorder.recordForDuration(10)
        
        //}

        self.recorder.deleteRecording()
    }
    
        
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}

