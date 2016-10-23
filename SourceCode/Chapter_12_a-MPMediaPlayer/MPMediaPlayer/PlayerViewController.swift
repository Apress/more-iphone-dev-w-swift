//
//  PlayerViewController.swift
//  MPMediaPlayer
//
//  Created by Jayant Varma on 21/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_12
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {

    @IBOutlet var artist: UILabel!
    @IBOutlet var song: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var volume: UIView!

    var newVolume: MPVolumeView!
    
    @IBOutlet var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    
    var player: MPMusicPlayerController!
    var mediaItem: MPMediaItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.pauseButton = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: "playPausePressed:")
        self.pauseButton.style = .Plain
        
        self.player = MPMusicPlayerController.applicationMusicPlayer()
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "playingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: self.player)
        notificationCenter.addObserver(self, selector: "playbackStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: self.player)
        self.player.beginGeneratingPlaybackNotifications()
        self.volume.backgroundColor = UIColor.clearColor()
        //self.volume.hidden = true
        
//        let _W:CGFloat = UIScreen.mainScreen().bounds.width
//        var frame = self.volume.frame
//        frame.size.width = _W
        
        let _W: CGFloat = UIScreen.mainScreen().bounds.width
        var frame = self.volume.bounds
        frame.size.width = _W

        newVolume = MPVolumeView(frame: frame) //CGRectMake(0, 0, _W, 40))
        self.volume.addSubview(newVolume)
        //self.view.addSubview(newVolume)
        newVolume.userInteractionEnabled = true
        newVolume.targetForAction("volumeChanged:", withSender: self.player)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var collection = MPMediaItemCollection(items: [self.mediaItem])
        self.player.setQueueWithItemCollection(collection)
        self.player.play()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.player.endGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: self.player)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: self.player)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Notification Events
    
    func playingItemChanged(notification: NSNotification){
        if let currentItem = self.player.nowPlayingItem {
            if let artwork = currentItem.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork? {
                self.imageView.image = artwork.imageWithSize(self.imageView.bounds.size)
                self.imageView.hidden = false
            }
            self.artist.text = currentItem.valueForProperty(MPMediaItemPropertyArtist) as! String?
            self.song.text = currentItem.valueForProperty(MPMediaItemPropertyTitle) as! String?
        } else {
            self.imageView.image = nil
            self.imageView.hidden = true
            self.artist.text = nil
            self.song.text = nil
        }
    }
    
    func playbackStateChanged(notification: NSNotification) {
        var playbackState = self.player.playbackState
        var items = self.toolbar.items!
        if playbackState == .Stopped || playbackState == .Paused {
            items[2] = self.playButton
        }else if playbackState == .Playing {
            items[2] = self.pauseButton
        }
        self.toolbar.items = items
    }
    
    
    @IBAction func volumeChanged(sender: AnyObject) {
        // Do nothing for now
    }
    
    @IBAction func playPausePressed(sender: AnyObject){
        var playbackState = self.player.playbackState as MPMusicPlaybackState
        if playbackState == .Stopped || playbackState == .Paused {
            self.player.play()
        } else if playbackState == .Playing {
            self.player.pause()
        }
    }
    
    @IBAction func donePressed(sender: AnyObject){
        self.player.stop()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
