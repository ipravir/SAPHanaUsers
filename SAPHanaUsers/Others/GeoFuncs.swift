//
//  GeoFuncs.swift
//  sapuserdetails
//
//  Created by Praveer on 15/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class DropPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var identifire: String
    
    init(coord: CLLocationCoordinate2D, identifr: String){
        self.coordinate = coord
        self.identifire = identifr
        super.init()
    }
}

class GeoFuncs{
    static var instance = GeoFuncs()
    var locationManager = CLLocationManager()
    let authorization = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 100000
    
    func currentLoc(oMap: MKMapView) {
        guard let current = locationManager.location?.coordinate else {return}
        let centralArea = MKCoordinateRegion(center: current, latitudinalMeters: regionRadius * 5, longitudinalMeters: regionRadius * 5)
        oMap.setRegion(centralArea, animated: true)
    }
    
    func displayPin(countryID: String, Lat: Float, Long: Float, oMap: MKMapView){
        let latitude:CLLocationDegrees = CLLocationDegrees(exactly: Lat)!
        let longitude:CLLocationDegrees =  CLLocationDegrees(exactly: Long)!
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        for Pinned in oMap.annotations{
            oMap.removeAnnotation(Pinned)
        }
        let annotation = DropPin(coord: coordinates, identifr: "CreatedPin")
        oMap.addAnnotation(annotation)
        
        GeneralClass.instance.getCountryArea(countryId: countryID) { (response) in
             let regionArea = MKCoordinateRegion(center: coordinates, latitudinalMeters: calcArea * 2, longitudinalMeters: calcArea * 2)
             oMap.setRegion(regionArea, animated: true)
        }
    }
}

