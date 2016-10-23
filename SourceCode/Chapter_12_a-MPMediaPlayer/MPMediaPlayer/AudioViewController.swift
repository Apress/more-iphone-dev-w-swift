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

class AudioViewController: MediaViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loadMediaItemsForMediaType(.Music)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PlayerSegue" {
            var cell = sender as! UITableViewCell
            var index = cell.tag
            var pvc = segue.destinationViewController as! PlayerViewController
            pvc.mediaItem = self.mediaItems.objectAtIndex(index) as! MPMediaItem
        }
        
    }

}
