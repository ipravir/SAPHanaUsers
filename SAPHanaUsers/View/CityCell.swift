//
//  CityCell.swift
//  SAPHanaUsers
//
//  Created by Praveer on 15/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCityName(index: IndexPath){
        if isSearching{
            lblCityName.text = iSearchCity[index.row].name
        } else {
            lblCityName.text = iCity[index.row].name
        }
    }

}
