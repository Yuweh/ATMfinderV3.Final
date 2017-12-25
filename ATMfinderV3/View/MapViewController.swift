//
//  ViewController.swift
//  ATMfinderV3
//
//  Created by Francis Jemuel Bergonia on 24/12/2017.
//  Copyright © 2017 Francis Jemuel Bergonia. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import MapKit
import SwiftyJSON

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    //to call Google Data Service
    //let dataProvider = GoogleDataProvider()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //to corrtect
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
        else {
            
            // This occurs if the user presses the button before our locations have been retreived
            let alert = UIAlertController(title: "Oh no", message: "We can't show you nearby locations if we don't know where you are! Go into settings to change your location services to get the most out of this app", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // We want to refresh the nearby locations when we move a certain distance away from our update location
            // We want to call this once we are far enough away from the last search point
            
            // If either of our locations are nil then this is the first time it is being loaded up so we want to get the nearby locations
//            if (previousLocation == nil || currentLocation == nil) {
//                previousLocation = location
//                currentLocation = location
            
                mapView.animate(toLocation: location.coordinate)
                
//                self.updateNearbyLocations(currentLocation: location)
            }
            
            // We want a previous location variable as we don't want to update the nearby locations regularly
            // If the user doesn't move far away enough there is no point
//            if currentLocation.distance(from: previousLocation) > 100 {
//
//                previousLocation = currentLocation
//                currentLocation = location
//
//                self.updateNearbyLocations(currentLocation: location)
//            }
        
            locationManager.stopUpdatingLocation()
        }
    }

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        //reverseGeocodeCoordinate(coordinate: position.target)
    }
}

