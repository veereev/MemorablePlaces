//
//  ViewController.swift
//  MemorablePlaces
//
//  Created by VEERASEKHAR ADDEPALLI on 31/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    func longPress(_ gestureRecognizer : UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == .began
        {
        let touchPoint = gestureRecognizer.location(in: map)
        
        let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
            
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
            (placemarks,error) -> Void in
                
            if error != nil
            {
                print(error)
            }
            else
            {
                
                if let placemark = placemarks?[0]{
                   
                    if placemark.subThoroughfare != nil{
                        title += placemark.subThoroughfare! + "  "
                    }
                    if placemark.thoroughfare != nil{
                        title += placemark.thoroughfare! + "  "
                    }
                    
                    
                }
                
                }
                if title == "" {
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                
                annotation.title = title
                self.map.addAnnotation(annotation)
                places.append(["name":title, "lat":String(coordinate.latitude), "lon": String(coordinate.longitude)])
                UserDefaults.standard.set(places, forKey: "places")
            })
            
            
        
       
        }
    
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        
        
        map.setRegion(region, animated: true)
        
        manager.stopUpdatingLocation()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "You are currently here!"
        map.addAnnotation(annotation)
        
 
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_ :)))
        longPressRecognizer.minimumPressDuration = 2
        
        map.addGestureRecognizer(longPressRecognizer)
        
        if activePlace == -1{
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
           // locationManager.stopUpdatingLocation()
            
        }
        
        else
        {
            //Get place details to display on map
            
            if places.count > activePlace{
                if let name =  places[activePlace]["name"]{
                    if let lat = places[activePlace]["lat"]
                    {
                        if let lon = places[activePlace]["lon"]{
                            
                            if let latitude = Double(lat), let longitutde = Double(lon)
                            {
                                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitutde)
                                let region = MKCoordinateRegion(center: coordinate, span: span)
                                map.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.title = name
                                annotation.coordinate = coordinate
                                map.addAnnotation(annotation)
                            }
                            
                        }
                    }
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

