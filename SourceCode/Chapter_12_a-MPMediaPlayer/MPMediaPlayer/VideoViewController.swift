//
//  VideoViewController.swift
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

class VideoViewController: MediaViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadMediaItemsForMediaType(MPMediaType.TVShow)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var mediaItem = self.mediaItems.objectAtIndex(indexPath.row) as! MPMediaItem
        if let mediaURL = mediaItem.valueForProperty(MPMediaItemPropertyAssetURL) as? NSURL {
            var player = MPMoviePlayerViewController(contentURL: mediaURL)
            self.presentMoviePlayerViewControllerAnimated(player)
        }
    }
    
    

}
