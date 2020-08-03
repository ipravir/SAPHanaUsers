//
//  CountrySearchVC.swift
//  sapuserdetails
//
//  Created by Praveer on 14/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit
import MapKit

class CountrySearchVC: UIViewController {

    @IBOutlet weak var oTable: UITableView!
    @IBOutlet weak var oMap: MKMapView!
    @IBOutlet weak var oSearch: SearchUI!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        oTable.dataSource = self
        oTable.delegate = self
        oSearch.delegate = self
        GeoFuncs.instance.locationManager.delegate = self
        oMap.delegate = self
        locationService()
    }

    @IBAction func ActionBackToNewEmployee(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CountrySearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching{
            GeoFuncs.instance.displayPin(countryID: iSearchCountry[indexPath.row].code, Lat: iSearchCountry[indexPath.row].lat, Long: iSearchCountry[indexPath.row].long, oMap: oMap)
        } else {
            GeoFuncs.instance.displayPin(countryID: iCountry[indexPath.row].code, Lat: iCountry[indexPath.row].lat, Long: iCountry[indexPath.row].long, oMap: oMap)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return iSearchCountry.count
        } else {
             return iCountry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = oTable.dequeueReusableCell(withIdentifier: C_COUNTRY_CELL, for: indexPath) as? CountryCell else { return UITableViewCell()}
        cell.addCountry(index: indexPath)
        if indexPath.row == 0{
            if isSearching {
                GeoFuncs.instance.displayPin(countryID: iSearchCountry[indexPath.row].code, Lat: iSearchCountry[0].lat, Long: iSearchCountry[0].long, oMap: oMap)
            } else {
                GeoFuncs.instance.displayPin(countryID: iCountry[indexPath.row].code, Lat: iCountry[0].lat, Long: iCountry[0].long, oMap: oMap)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Select") { (rowaction, indexpath) in
            if isSearching{
                selCountry = iSearchCountry[indexPath.row].code
            } else {
                selCountry = iCountry[indexPath.row].code
            }
            iSearchCountry = []
            isSearching = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
        selectAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return [selectAction]
    }
}

extension CountrySearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        iSearchCountry = iCountry.filter({$0.name.prefix(searchText.count) == searchText})
        isSearching = true
        oTable.reloadData()
    }
}

extension CountrySearchVC: CLLocationManagerDelegate{
    func locationService(){
        //this will check whether location access authorization is there or not
        if GeoFuncs.instance.authorization == .notDetermined{
            GeoFuncs.instance.locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        GeoFuncs.instance.currentLoc(oMap: oMap)
    }
}

extension CountrySearchVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CreatePin")
        pin.pinTintColor = UIColor.blue
        pin.animatesDrop = true
        return pin
    }
}
