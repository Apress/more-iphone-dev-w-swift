//
//  ViewController.swift
//  mapMe
//
//  Created by Jayant Varma on 15/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_10
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var manager: CLLocationManager!
    var geocoder: CLGeocoder!
    var placemark: CLPlacemark!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - (Private) Instance Methods
    
    func openCallout(annotation: MKAnnotation){
        self.progressBar.progress = 1.0
        self.progressLabel.text = NSLocalizedString("Showing Annotation",
                                            comment: "Showing Annotation")
        self.mapView.selectAnnotation(annotation, animated: true)
        
        self.button.hidden = true
        self.progressBar.hidden = true
        self.progressLabel.text = ""
    }
    
    func showAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func showAlertWithCompletion(title:String,
                               message: String,
                           buttonTitle: String = "OK",
                            completion:((alertAction: UIAlertAction!)->())!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: buttonTitle, style: .Default, handler: completion)
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func reverseGeocode(location: CLLocation){
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) -> Void in
            if nil != error {
                let title = NSLocalizedString("Error translating coordinates into location",
                                     comment: "Error translating coordinates into location")
                let message = NSLocalizedString("Geocoder did not recognize coordinates",
                                       comment: "Geocoder did not recognize coordinates")
                self.showAlert(title, message: message)
            } else if placemarks.count > 0 {
                var placemark:CLPlacemark = placemarks[0] as! CLPlacemark
                self.progressBar.progress = 0.5
                self.progressLabel.text = NSLocalizedString("Location Determined",
                                                   comment: "Location Determined")
                var annotation = MapLocation()
                annotation.street = placemark.thoroughfare
                annotation.city = placemark.locality
                annotation.state = placemark.administrativeArea
                annotation.zip = placemark.postalCode
                annotation.coordinate = location.coordinate
                
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var oldLocation: CLLocation = locations.first as! CLLocation
        var newLocation: CLLocation = locations.last as! CLLocation
        if newLocation.timestamp.timeIntervalSince1970 <
           NSDate.timeIntervalSinceReferenceDate() - 60 {
            return
        }
        
        var viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000)
        var adjustedRegion = self.mapView.regionThatFits(viewRegion)
        self.mapView.setRegion(adjustedRegion, animated: true)
        
        manager.delegate = nil
        manager.stopUpdatingLocation()
        
        self.progressBar.progress = 0.25
        self.progressLabel.text = NSLocalizedString("Reverse Geocoding Location",
            comment: "Reverse Geocoding Location")
        
        self.reverseGeocode(newLocation)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        let errorType = error.code == CLError.Denied.rawValue
            ? NSLocalizedString("Access Denied", comment: "Access Denied")
            : NSLocalizedString("Unknown Error", comment: "Unknown Error")
        let title = NSLocalizedString("Error Getting Location", comment: "ErrorGetting Location")
        showAlert(title, message: errorType)
    }
    
    //MARK: - MKMapViewDelegate Methods
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        let placemarkIdentifier = "Map Location Identifier"
//        if annotation .isKindOfClass(MapLocation){
//            var annotationView: MKPinAnnotationView!
//            if let _annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(placemarkIdentifier) as? MKPinAnnotationView {
//                annotationView = _annotationView

        let placemarkIdentifier = "Map Location Identifier"
        if let _annotation = annotation as? MapLocation {
            var annotationView: MKPinAnnotationView!
            if let _annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(placemarkIdentifier) as? MKPinAnnotationView {
                annotationView = _annotationView
            } else {
                annotationView = MKPinAnnotationView(annotation: _annotation, reuseIdentifier: placemarkIdentifier)
            }
            annotationView.enabled = true
            annotationView.animatesDrop = true
            annotationView.pinColor = MKPinAnnotationColor.Purple
            annotationView.canShowCallout = true
            
            //NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "openCallout:", userInfo: nil, repeats: false)
            
            dispatch_after(dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(0.5 * Double(NSEC_PER_SEC))
                ), dispatch_get_main_queue(), {
                self.openCallout(annotation!)
            })
            
            self.progressLabel.text = NSLocalizedString("Creating Annotation", comment: "CreatingAnnotation")
            self.progressBar.progress = 0.75
                        
            return annotationView
        }
        return nil
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView!, withError error: NSError!) {
        let title = NSLocalizedString("Error loading map", comment: "Error loading map")
        let message = error.localizedDescription
        
        showAlertWithCompletion(title, message: message, completion: {
            _ in
            self.progressBar.hidden = true
            self.progressLabel.text = ""
            self.button.hidden = false
        })
        
    }
    
    
    
    
    // MARK: - View Control Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.mapView.mapType = MKMapType.Standard
//        self.mapView.mapType = MKMapType.Satellite
//        self.mapView.mapType = MKMapType.Hybrid

        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        
        var coords:CLLocationCoordinate2D = self.mapView.userLocation.coordinate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Action Method
    
    @IBAction func findMe(sender: AnyObject) {
        if manager == nil {
            manager = CLLocationManager()
        }
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.progressBar.hidden = false
        self.progressBar.progress = 0
        self.progressLabel.text = NSLocalizedString("Determining Current Location",
                                           comment: "Determining Current Location")
        self.button.hidden = true
    }
}

