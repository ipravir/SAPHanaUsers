//
//  CountryCell.swift
//  sapuserdetails
//
//  Created by Praveer on 14/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var oImgCountryFlag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addCountry(index: IndexPath) {
        if isSearching {
            lblCountryName.text = "\(iSearchCountry[index.row].name) (\(iSearchCountry[index.row].native))"
            GeneralClass.instance.dislayCountryFlag(oImg: oImgCountryFlag, countryId: iSearchCountry[index.row].code)
            return
        } else {
            lblCountryName.text = "\(iCountry[index.row].name) (\(iCountry[index.row].native))"
            GeneralClass.instance.dislayCountryFlag(oImg: oImgCountryFlag, countryId: iCountry[index.row].code)
        }
    }

}
