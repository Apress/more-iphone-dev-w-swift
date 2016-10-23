//
//  ViewController.swift
//  Chapter11
//
//  Created by Jayant Varma on 16/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_11
// Book: More iOS Development with Swift, Apress 2015
//

// NOTE: The Mail Composer could cause an error in the Simulator but work on the device.

import UIKit
import MessageUI
import Social

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var mc:MFMessageComposeViewController!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func sendMail(sender: UIButton) {
//        if MFMessageComposeViewController.canSendText() {
//            mc = MFMessageComposeViewController()
//            mc.messageComposeDelegate = self
//            let path = NSBundle.mainBundle().pathForResource("dog", ofType: "png")
//            let data = NSData(contentsOfFile: path!)
//            mc.addAttachmentData(data, typeIdentifier: "image/png", filename: "dog")

//            let theURL = NSURL(string: "http://www.oz-apps.com/wp-content/uploads/2012/09/products.png")
//            let data = NSData(contentsOfURL: theURL!)
//            let image = UIImage(data: data!)
//        
//            self.image.image = image
//            mc.addAttachmentURL(theURL, withAlternateFilename: "Our Products")
        
        //presentViewController(mc, animated: true, completion: nil)
        //}
        
//        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter){
//            
//            let image = UIImage(named: "dog.png")
//            vc.addImage(image)
//            let url = NSURL(string: "http://www.oz-apps.com")
//            println("\(vc.addURL(url))")
//            
//            vc.completionHandler = {
//                results in
//                switch results{
//                    case .Cancelled:
//                        println("Cancelled")
//                    case .Done:
//                        println("Done")
//                    default:
//                        ()
//                }
//                println("All Done")
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//            
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
        
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(sourceType){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = sourceType
        self.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.image.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showActivityIndicator", userInfo: nil, repeats: false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func showActivityIndicator() {
        var message = NSLocalizedString("I took a picture on my iPhone",
                            comment:"I took a picture on my iPhone")
        var activityItems = [message, self.image.image!]
        var activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        println(">> cencelled <<")
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch result.value {
        case MessageComposeResultCancelled.value: ()
        case MessageComposeResultFailed.value: ()
        default: ()
        }
        
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    
}

