//
//  MediaListControllerTableViewController.swift
//  AVKitMediaPlayer2
//
//  Created by Jayant Varma on 23/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_12
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit
import AVFoundation
import AVKit
import Photos


//import MediaPlayer
//PHPhotoLibrary

class MediaListControllerTableViewController: UITableViewController{

    let manager = PHImageManager.defaultManager()
    var videos:PHFetchResult!

    //var imageRequests = [NSIndexPath: PHImageRequestID]()

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Video Browser"
        //self.title = "Image Browser"

        self.videos = PHAsset.fetchAssetsWithMediaType(.Video, options: nil)
        //self.videos = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
//        var volume = MPVolumeView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
//        self.view.addSubview(volume)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if PHPhotoLibrary.authorizationStatus() == .Denied {
                let alert = UIAlertController(
                        title: "Requires Access to Photos",
                      message: "Please allow this app to access your Photos Library from the Settings > Privacy > Photos setting",
               preferredStyle: .Alert)
                let OKButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(OKButton)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.videos?.count ?? 0
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        dispatch_async(dispatch_get_main_queue(), {
        var theAsset = self.videos.objectAtIndex(indexPath.row) as! PHAsset
    
        self.manager.requestImageForAsset(self.videos.objectAtIndex(indexPath.row) as! PHAsset,
                                 targetSize: CGSizeMake(150, 150),
                                contentMode: PHImageContentMode.AspectFill,
                                    options: nil,
                              resultHandler: {
            image, info in
                                
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 1)
            var context = UIGraphicsGetCurrentContext()
                                //CGContextDrawImage(context, CGRectMake(0, 0, 100, 100), 
                                //(image as UIImage).CGImage)
            (image as UIImage).drawInRect(CGRectMake(0, 0, 100, 100))
            var img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
                                
                                cell.imageView?.image = img //image
            var duration = String(format: "%0.1fs", theAsset.duration)
            var details = "(\(theAsset.pixelWidth) x \(theAsset.pixelHeight)) - \(duration)"
            cell.textLabel?.text = details
                                
                                //cell.detailTextLabel?.text = "\(theAsset.creationDate)"
                                
            cell.accessoryType = theAsset.favorite ? .Checkmark : .None
                                
            //cell.detailTextLabel?.text = details
        })
            })
        //dispatch_async(dispatch_get_main_queue(), {
        
//        if let request = imageRequests[indexPath] {
//            manager.cancelImageRequest(request)
//        }
//        
//        //var theAsset = self.videos.objectAtIndex(indexPath.row) as PHAsset
//        imageRequests[indexPath] =
//            self.manager.requestAVAssetForVideo(theAsset, options: nil, resultHandler: {
//                avasset, avaudio, info in
//                var filename = (avasset as AVURLAsset).URL.lastPathComponent
//                cell.textLabel?.text = filename!
//            })
        
        
        //})
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var theAsset = self.videos.objectAtIndex(indexPath.row) as! PHAsset
        
        if theAsset.mediaType == .Video {
            
            println(">> Showing video <<<")
            
            manager.requestPlayerItemForVideo(theAsset as PHAsset, options: nil, resultHandler: {
                item, info in
                var playerVC = AVPlayerViewController()
                var player:AVPlayer  = AVPlayer(playerItem: item)
                playerVC.player = player
                
                player.play()
                self.presentViewController(playerVC, animated: true, completion: nil)
            })
//        } else if theAsset.mediaType == .Image{
//            manager.requestImageDataForAsset(theAsset, options: nil, resultHandler:
//                {
//                    data, title, orientation, info in
//                    //<#((NSData!, String!, UIImageOrientation, [NSObject : AnyObject]!) -> Void)!##(NSData!, String!, UIImageOrientation, [NSObject : AnyObject]!) -> Void#>)
//                    //println("\(title), \(orientation.rawValue), \(info)")
//                    //var filePath = (info as NSDictionary).objectForKey("PHImageFileURLKey") as String?
//                    //println("\(filePath)")
//            })
        }
        
    
//    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//            let request = PHAssetChangeRequest(forAsset: theAsset)
//            request.favorite = !request.favorite
//        },
//        completionHandler: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
