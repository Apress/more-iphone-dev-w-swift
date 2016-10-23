//
//  ViewController.swift
//  Camera_2
//
//  Created by Jayant Varma on 26/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_13
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var theButton: UIButton!
    
    var session: AVCaptureSession!
    var theCamera: AVCaptureDevice!
    var theInputSource: AVCaptureDeviceInput!
    var theOutputSource: AVCaptureMetadataOutput!
    var thePreview: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var allCameras = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for camera in allCameras {
            if camera.position == AVCaptureDevicePosition.Back {
                theCamera = camera as! AVCaptureDevice
                break
            }
        }
        
        session = AVCaptureSession()
        if theCamera != nil {
            theInputSource = AVCaptureDeviceInput(device: theCamera, error: nil)
            if session.canAddInput(theInputSource) {
                session.addInput(theInputSource)
            }
            
            theOutputSource = AVCaptureMetadataOutput()
            if session.canAddOutput(theOutputSource) {
                session.addOutput(theOutputSource)
            }
            
            var options = [AVMetadataObjectTypeQRCode]
            theOutputSource.setMetadataObjectsDelegate(self, queue: DISPATCH_QUEUE_PRIORITY_DEFAULT)
            theOutputSource.metadataObjectTypes = options
        
            thePreview = AVCaptureVideoPreviewLayer(session: session)
            self.view.layer.addSublayer(thePreview)
            thePreview.frame = self.view.bounds
            thePreview.videoGravity = AVLayerVideoGravityResizeAspectFill
        }
        
        session.startRunning()
    }
    
    //MARK: - AVCaptureMetadataObjectsDelegate functions
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        //
        for theItem in metadataObjects {
            if let _item = theItem as? AVMetadataMachineReadableCodeObject {
                println("We read \(_item.stringValue) from a barcode of type : \(_item.type)")
                showAlert("We got \(_item.stringValue)", theMessage: "barcode type:  \(_item.type)")
            }
        }
    }
    
    func showAlert(theTitle: String, theMessage: String, theButton: String = "OK", completion:((UIAlertAction!) -> Void)! = nil){
        let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: .Alert)
        let OKButton = UIAlertAction(title: theButton, style: .Default, handler: completion)
        alert.addAction(OKButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressed(sender: AnyObject){
        var kText = "Hello from More iOS development using Swift"
        
        var filter = CIFilter(name: "CIQRCodeGenerator")
        filter.setDefaults()
        
        var data = kText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        
        
        var outputImage = filter.outputImage
        var context = CIContext(options: nil)
        var cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent())
        var image = UIImage(CGImage: cgImage, scale: 1, orientation: .Up)
        
        // Blurry, anti-aliased Barcode
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        var scaleRef = self.view.bounds.width / image!.size.width
        
        var width = image!.size.width * scaleRef
        var height = image!.size.height * scaleRef
        
        println("\(image?.size.width)x\(image?.size.height)")
        println("\(width)x\(height), \(scaleRef)")
        
        
        var quality = kCGInterpolationNone
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        var _context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(_context, quality)
        image!.drawInRect(CGRectMake(0, 0, width, height))
        var _temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(_temp, nil, nil, nil)
        
        showAlert("Barcode Saved",theMessage: "The barcode has been saved to the Photos Album")
    }
    

}

