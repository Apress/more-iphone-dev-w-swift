//
//  ViewController.swift
//  AVKitMediaPlayer
//
//  Created by Jayant Varma on 22/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_12
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit
import AVKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    
    @IBAction func showVideo(sender: AnyObject) {
        
        let player = AVPlayer(URL: NSURL(fileURLWithPath: pathFor("stackofCards")!))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.addChildViewController(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.view.frame = self.view.frame
        player.play()
        
        
        //dispatch_async(dispatch_get_main_queue(), {

//            var playerVC = AVPlayerViewController()
//            
//            let manager = PHImageManager.defaultManager()
//            var assets = PHAsset.fetchAssetsWithMediaType(.Video, options: nil)
//            var theItems:[AVPlayerItem] = []
//            var total = assets.count
//        
//            var player = AVQueuePlayer()
//        
//            for i in 1..<total {
//                let theAsset = assets[i as Int] as PHAsset
//                manager.requestPlayerItemForVideo(theAsset, options: nil, resultHandler: {
//                    item, info in
//                    //theItems.append(item)
//                    player.insertItem(item, afterItem: nil)
//                    theItems.append(item)
//                })
        

//            self.addChildViewController(playerVC)
//            self.view.addSubview(playerVC.view)
//            playerVC.view.frame = self.view.frame
//            
//            player.play()
                
                //self.presentViewController(playerVC, animated: true, completion: nil)
//            }
            
//            println("We have \(theItems.count)")
//            AVQueuePlayer.queuePlayerWithItems(theItems)
//            playerVC.player = player
//            player.play()
//            //self.navigationController?.pushViewController(playerVC, animated: true)
//            self.presentViewController(playerVC, animated: true, completion: nil)

    //})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // Show a Video included in the project
//        var filePath = NSBundle.mainBundle().pathForResource("stackofCards", ofType: "mp4")
//        if let _videoPlayer = segue.destinationViewController as? PlayerViewController{
//            if filePath != nil {
//                _videoPlayer.videoURL = NSURL(fileURLWithPath: filePath!)
//            }
//        }
        
        // Play the Apple Watch video from the URL
        
        if let _videoPlayer = segue.destinationViewController as? PlayerViewController {
            _videoPlayer.videoURL = NSURL(string: "http://images.apple.com/media/us/watch/2014/videos/e71af271_d18c_4d78_918d_d008fc4d702d/tour/reveal/watch-reveal-cc-us-20140909_r848-9dwc.mov")
        }

        
        // Play a series of videos from an array of videos.
        
//        var videos: [String!] = []
//        videos.append(pathFor("stackofCards"))
//        
//        if let _videoPlayer = segue.destinationViewController as? PlayerViewController {
//            _videoPlayer.videos = videos
//        }
        
    }

    func pathFor(theFile:String, ofType: String = "mp4") -> String? {
        var filePath = NSBundle.mainBundle().pathForResource(theFile, ofType: ofType)
        return filePath
    }
    
    
}

