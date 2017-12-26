//
//  ViewController.swift
//  ATMfinderV3
//
//  Created by Francis Jemuel Bergonia on 24/12/2017.
//  Copyright © 2017 Francis Jemuel Bergonia. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, newLocationsDelegate {

    var currentLocation: CLLocation!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    // Store the location coordinates of the nearby locations
    var locationCoordinates = NSMutableArray()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "ATM Finder"
        self.tabBarItem.image = UIImage(named: "icn_30_map.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self as? GMSMapViewDelegate
        
        //self.mapView.isMyLocationEnabled = true
        
        //showMarker(position: (locationManager.location?.coordinate)!)
        //mapView.delegate = self as? GMSMapViewDelegate
        // 1.
        SearchNearbyManager.sharedInstance.delegate = self as newLocationsDelegate
    
    }
    
    // This is a delegate method for returning new locations from the NearbyMapsManager
    func returnNewLocations(locations: NSArray) {
        
        // Clear our arrays and reset the map
        locationCoordinates.removeAllObjects()
        mapView.clear()
        
        // We loop through the results in our array then plot each one on the map
        for i in 0 ... locations.count - 1 {
            
            let dict = locations[i] as! NSDictionary;
            
            let geometry = dict["geometry"] as! NSDictionary
            let coordinates = geometry["location"] as! NSDictionary
            
            let longitude = coordinates["lng"] as! CLLocationDegrees
            let latitude = coordinates["lat"] as! CLLocationDegrees
            
            let itemLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            locationCoordinates.addObjects(from: [itemLocation])
            
            let marker = GMSMarker(position: itemLocation)
            marker.title = dict["name"] as? String
            marker.icon = dict["icon"] as? UIImage
            marker.map = mapView
        }
    }
    
    // 2.
    func updateNearbyLocations(currentLocation: CLLocation) {
        SearchNearbyManager.sharedInstance.getNearbyLocationsWithLocation(location: currentLocation)
    }
    
    
//    func initializeTheLocationManager() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
    
    //Show a Marker on the map
//    func showMarker(position: CLLocationCoordinate2D){
//        let marker = GMSMarker()
//        marker.position = position
//        marker.title = "You are here"
//        marker.snippet = " "
//        marker.map = mapView
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    
    
}

