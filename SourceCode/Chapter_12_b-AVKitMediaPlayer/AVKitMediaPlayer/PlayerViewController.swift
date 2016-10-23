//
//  PlayerViewController.swift
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

class PlayerViewController: AVPlayerViewController {

    let imageManager = PHImageManager.defaultManager()
    var videosA: PHFetchResult!
    
    private var _video: NSURL!
    var videos:[String!]!
    
    var videoURL: NSURL?{
        get{
            return _video
        }
        set{
            _video = newValue
        }
    }
    
    func theVideos() -> [AVPlayerItem]!{
        var results: [AVPlayerItem] = []
        for itm in videos {
            if itm != nil {
                results.append(AVPlayerItem(URL: NSURL(fileURLWithPath: itm)))
                //results.append(AVPlayerItem(URL: NSURL(fileURLWithPath: itm)))
            }
            
        }
        return results
    }

    var videoAsset:PHAsset? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let videoAsset = videoAsset {
            
            imageManager.requestPlayerItemForVideo(videoAsset, options: nil, resultHandler: {
                playerItem, info in
                self.player = self.createPlayerByPrefixingItem(playerItem)

                self.player = AVPlayer(playerItem: playerItem)
            })
        }
    }
    
    private func createPlayerByPrefixingItem(playerItem: AVPlayerItem) -> AVPlayer {
        return AVQueuePlayer(items: [playerItem])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        videosA = PHAsset.fetchAssetsWithMediaType(.Audio, options: nil) as PHFetchResult
//        
//        if videosA.count > 0 {
//            self.videoAsset = videosA[0] as? PHAsset
//        }
        
        
        if videoURL != nil {
            dispatch_async(dispatch_get_main_queue(), {
                
                var playerx = AVPlayer(URL: self.videoURL)
                self.player = playerx
                
                //Allow or disallow the playback controls when playing the movie
                self.showsPlaybackControls = false
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                var theVideo = self.theVideos()
                var playerx = AVQueuePlayer()
                
                for itm in theVideo {
                    playerx.insertItem(itm, afterItem: nil)
                }
                    //var playerx = AVQueuePlayer.queuePlayerWithItems(theVideo) as AVQueuePlayer
                    //AVQueuePlayer(items: self.theVideos())
                self.player = playerx
                self.player.play()
            })
        }

    
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

}
