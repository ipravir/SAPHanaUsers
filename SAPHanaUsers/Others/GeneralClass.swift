//
//  GeneralClass.swift
//  sapuserdetails
//
//  Created by Praveer on 14/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import Foundation
import UIKit


class GeneralClass{
    
    static let instance = GeneralClass()
    
    
    func dislayCountryFlag(oImg: UIImageView, countryId: String){
        let mainPath = C_FLAG_URL.replacingOccurrences(of: "CNT", with: countryId)
        if let url = URL(string: mainPath){
            if let imgData = NSData(contentsOf: url){
                oImg.contentMode = .scaleAspectFill
                oImg.image = UIImage(data: imgData as Data)
            }
        }
    }
    
    func getCountryArea(countryId: String, complition: @escaping ComplitionHandler) {
        let Url: String = "\(C_COUNTRY_URL)\(countryId)"
        guard let url = URL(string: Url) else {
          print("Error: cannot create URL")
          complition(false)
        return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // make the request
        let task = session.dataTask(with: urlRequest) {
          (data, response, error) in
          guard error == nil else {
            print(error!)
            complition(false)
            return
          }
          guard let responseData = data else {
            print("Error: did not receive data")
            complition(false)
            return
          }
          do {
            guard let oData = try JSONSerialization.jsonObject(with: responseData, options: [])
              as? [String: Any] else {
                return
            }
              for item in oData{
                  if item.key == "area"{
                    calcArea = item.value as? Double
                  }
              }
          } catch  {
            print("error trying to convert data to JSON")
            complition(false)
            return
          }
        }
        task.resume()
        complition(true)
    }
}
    
 
