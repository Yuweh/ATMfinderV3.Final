//
//  MainMapVC.swift
//  ATMFinder-GoogleMaps
//
//  Created by EDI on 27/12/17.
//  Copyright © 2017 EDI. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation
import GoogleMaps

struct AtmDetailsStruct {
    
    private(set) public var atmName : String
    private(set) public var atmLocation : String
    
    init(atmName: String, atmLocation: String) {
        self.atmName = atmName
        self.atmLocation = atmLocation
        
    }
    
}

class MainMapVC: UIViewController, newLocationsDelegate {
    
    var currentLocation: CLLocation! // This is our current location
    var previousLocation: CLLocation! // If we change location this is our previous location
    
    let locationManager = CLLocationManager() // Manage our location
    
    // We can store our map line - this makes it easier to move and access
    var mapRouteLine = GMSPolyline()
    
    // Store the location coordinates of the nearby locations
    var locationCoordinates = NSMutableArray()
    
    var atmDetailsArray: [AtmDetailsStruct] = [AtmDetailsStruct]()
    
 
    @IBOutlet weak var mapView: GMSMapView!
    //@IBOutlet var mapView: GMSMapView!
    
    
    @IBOutlet weak var atmTableView: UITableView!
    //
 

    @IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Tourist Map"
        self.tabBarItem.image = UIImage(named: "icn_30_map.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        SearchNearbyManager.sharedInstance.delegate = self;
        
        // Only show the location label if we know our current location and address
        self.updateLocationLabel(text: "")
        
        //connect atmTableView
        atmTableView.delegate = self as! UITableViewDelegate
        atmTableView.dataSource = self as! UITableViewDataSource
    }
    
    // This is a delegate method for returning new locations from the NearbyMapsManager
    func returnNewLocations(locations: NSArray) {
        
        // Clear our arrays and reset the map
        locationCoordinates.removeAllObjects()
        mapView.clear()
        
        // We loop through the results in our array then plot each one on the map
        for i in 0 ... locations.count - 1 {
            
            let dict = locations[i] as! NSDictionary;
            
            // for locationCoordinate NSArray
            let geometry = dict["geometry"] as! NSDictionary
            let coordinates = geometry["location"] as! NSDictionary
            
            let longitude = coordinates["lng"] as! CLLocationDegrees
            let latitude = coordinates["lat"] as! CLLocationDegrees
            
            let itemLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // for atmDetailsArray
            
            let atmName = dict["name"] as! String
            let atmAddress = dict["vicinity"] as! String
            
            let atmInfo = AtmDetailsStruct(atmName: atmName, atmLocation: atmAddress)
            print(atmInfo)
            
            atmDetailsArray.append(atmInfo)
            locationCoordinates.addObjects(from: [itemLocation])
            
            let marker = GMSMarker(position: itemLocation)
            marker.title = dict["name"] as? String
            marker.map = mapView
        }
    }
    
    func updateNearbyLocations(currentLocation: CLLocation) {
        SearchNearbyManager.sharedInstance.getNearbyLocationsWithLocation(location: currentLocation)
    }
    
    func updateLocationLabel(text: String) {
        
        self.locationLabel.text = text
        
        UIView.animate(withDuration: 0.2, animations: {
            //self.locationLabel.alpha = self.locationLabel.text?.count = 0 ? 0.0 : 0.7
        })
    }
    
    // Use this to set the address at the bottom of the screen
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            if let address = response?.firstResult() {
                
                var addressString = String()
                
                // Concatinate the lines of the address into a single string
                for String in address.lines! {
                    addressString = addressString + " " + String
                }
                
                self.updateLocationLabel(text: addressString)
            }
        }
    }
    
}

extension MainMapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
        else {
            
            // This occurs if the user presses the button before our locations have been retreived
            let alert = UIAlertController(title: "Current Location Needed", message: "We need your current location to provide more accurate information and for you to get the most out of this app", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            mapView.animate(toLocation: location.coordinate)
            self.updateNearbyLocations(currentLocation: location)

        }
    }
}

extension MainMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        reverseGeocodeCoordinate(coordinate: position.target)
    }
}

extension MainMapVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ATMCustomCell = tableView.dequeueReusableCell(withIdentifier: "ATMcell", for: indexPath) as! ATMCustomCell
        let atmDetailsInfo = atmDetailsArray[indexPath.row]
        cell.textLabel?.text = atmDetailsInfo.atmName
        cell.textLabel?.text = atmDetailsInfo.atmLocation
        
//        cell.textLabel?.text = atmDetailsInfo.atmName
//        cell.detailTextLabel?.text = atmDetailsInfo.atmLocation
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return atmDetailsArray.count
    }
    
}
