//
//  CitySearchVC.swift
//  SAPHanaUsers
//
//  Created by Praveer on 15/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class CitySearchVC: UIViewController {

    @IBOutlet weak var oCityTable: UITableView!
    @IBOutlet weak var oSearch: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        oCityTable.dataSource = self
        oCityTable.delegate = self
        oSearch.delegate = self
    }
    
    @IBAction func ActionBackToEmployee(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CitySearchVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return iSearchCity.count
        } else {
            return iCity.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = oCityTable.dequeueReusableCell(withIdentifier: C_CITY_CELL, for: indexPath) as? CityCell else {return UITableViewCell()}
        cell.updateCityName(index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Select") { (rowaction, indexpath) in
            if isSearching{
                selCity = "\(iSearchCity[indexPath.row].name)-\(iSearchCity[indexPath.row].id)"
            } else {
                selCity = "\(iCity[indexPath.row].name)-\(iCity[indexPath.row].id)"
            }
            iSearchCity = []
            isSearching = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
        selectAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return [selectAction]
    }
}

extension CitySearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        iSearchCity = iCity.filter({$0.name.prefix(searchText.count) == searchText})
        isSearching = true
        oCityTable.reloadData()
    }
}
