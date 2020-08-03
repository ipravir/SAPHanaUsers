//
//  NewUpdateEmployeeVC.swift
//  sapuserdetails
//
//  Created by Praveer on 14/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class NewUpdateEmployeeVC: UIViewController {

    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtMName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtMailID: UITextField!
    @IBOutlet weak var txtExtenNo: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var oImgCountryFlag: UIImageView!
    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var bttnSaveUpdate: ButtonDesign!
    @IBOutlet weak var bttnContSearch: UIButton!
    @IBOutlet weak var bttnCitySearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblInformation.isHidden = true
        txtMobileNo.addTarget(self, action: #selector(checkMobileNo), for: .editingChanged)
        txtExtenNo.addTarget(self, action: #selector(checkExtensionNo), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        if displayEmp != nil{
            setDisplayEmployee()
        } else if updateEmp != nil{
            setUpdateEmployee()
        } else {
            let countryCode: String = (Locale.current as NSLocale).object(forKey: .countryCode) as! String
            let country = SAPServices.instance.getCountry(conid: countryCode)
            GeneralClass.instance.dislayCountryFlag(oImg: oImgCountryFlag, countryId: country.code )
            txtCountry.text = countryCode
        }
    }
    
    @IBAction func ActionCountrySearch(_ sender: Any) {
        SAPServices.instance.getCountyries { (response) in
            if response == true{
                guard let oSearch = self.storyboard?.instantiateViewController(withIdentifier: C_COUNTRY_SEARCH_VC) else {return}
                oSearch.modalPresentationStyle = .fullScreen
                self.present(oSearch, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func ActionCitySearch(_ sender: Any) {
        SAPServices.instance.getCities(conID: txtCountry.text!) { (response) in
            if response == true{
                guard let oSearch = self.storyboard?.instantiateViewController(withIdentifier: C_CITYSERACH_VC) else {return}
                oSearch.modalPresentationStyle = .fullScreen
                self.present(oSearch, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func ActionSaveUpdate(_ sender: Any) {
        if let fName: String = txtFName.text{
            if let mail: String = txtMailID.text{
                if let exten: String = txtExtenNo.text{
                    if let mobile: String = txtMobileNo.text{
                        if let city: String = txtCity.text{
                            let newId = SAPServices.instance.newEmployeeID()
                            if newId == 0{
                                lblInformation.text = "Not able to generate new id, Check Connection"
                                lblInformation.isHidden = false
                            } else {
                                let mName: String = txtMName.text!
                                let lName: String = txtLName.text!
                                let contry: String  = txtCountry.text!
                                let cityArray = city.split(separator: "-")
                                if updateEmp == nil{
                                    SAPServices.instance.addNewEmployee(employeeId: newId, fMame: fName, mName: mName, lName: lName, mailid: mail, extenNo: exten, mobileNo: mobile, conId: contry, cityId: String(cityArray[1])) { (response) in
                                        if response == true{
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                } else {
                                    SAPServices.instance.updateEmployeeDetails(employeeId: updateEmp.id, fMame: fName, mName: mName, lName: lName, mailid: mail, extenNo: exten, mobileNo: mobile, conId: contry, cityId: String(cityArray[1])) { (response) in
                                        if response == true{
                                            let emp = employee( id: updateEmp.id,
                                            Name: "\(fName) \(mName) \(lName)",
                                            fName: fName,
                                            mName: mName,
                                            lName: lName,
                                            mail: mail,
                                            exten: exten,
                                            mobile: mobile,
                                            contact: "\(exten)-\(mobile)",
                                            country: "",
                                            conid: contry,
                                            city: "",
                                            cityid: String(cityArray[1]))
                                            iEmployes[iEmployes.indices.filter {iEmployes[$0].id == updateEmp.id}[0]] = emp
                                            updateEmp = nil
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        } else {
                            lblInformation.text = "Invalid City Name"
                            lblInformation.isHidden = false
                        }
                    } else {
                        lblInformation.text = "Invalid Mobile No"
                        lblInformation.isHidden = false
                    }
                } else {
                    lblInformation.text = "Invalid Extension No"
                    lblInformation.isHidden = false
                }
            } else {
                lblInformation.text = "Invalid Mail Id"
                lblInformation.isHidden = false
            }
        } else {
            lblInformation.text = "Invalid Fisrt Name"
            lblInformation.isHidden = false
        }
    }
    
    @IBAction func ActionBackToDetails(_ sender: Any) {
        displayEmp = nil
        updateEmp = nil
        dismiss(animated: true, completion: nil)
    }

    @objc func checkMobileNo(){
        if txtMobileNo.text!.count > 10{
            lblInformation.text = "Invalid Mobile NO."
            lblInformation.isHidden = false
        } else {
            lblInformation.isHidden = true
        }
    }
    
    @objc func checkExtensionNo(){
        if txtExtenNo.text!.count > 4{
            lblInformation.text = "Invalid Extension NO."
            lblInformation.isHidden = false
        } else {
            lblInformation.isHidden = true
        }
    }
    
    @objc func refreshView(){
        if selCountry != "" {
             GeneralClass.instance.dislayCountryFlag(oImg: oImgCountryFlag, countryId: selCountry )
             txtCountry.text = selCountry
             selCountry = ""
        }
        if selCity != ""{
            txtCity.text = selCity
            selCity = ""
        }
    }
    
    func setDisplayEmployee(){
        txtCity.text = "\(SAPServices.instance.getCityName(con_id: displayEmp.conid, cityid: displayEmp.cityid))-\(displayEmp.cityid)"
        txtCountry.text = displayEmp.conid
        txtFName.text = displayEmp.fName
        txtFName.isEnabled = false
        txtMName.text = displayEmp.mName
        txtMName.isEnabled = false
        txtLName.text = displayEmp.lName
        txtLName.isEnabled = false
        txtMailID.text = displayEmp.mail
        txtMailID.isEnabled = false
        txtExtenNo.text = displayEmp.exten
        txtExtenNo.isEnabled = false
        txtMobileNo.text = displayEmp.mobile
        txtMobileNo.isEnabled = false
        bttnSaveUpdate.isHidden = true
        bttnContSearch.isHidden = true
        bttnCitySearch.isHidden = true
        GeneralClass.instance.dislayCountryFlag(oImg: oImgCountryFlag, countryId: displayEmp.conid )
    }

    func setUpdateEmployee(){
        txtCity.text = "\(SAPServices.instance.getCityName(con_id: updateEmp.conid, cityid: updateEmp.cityid))-\(updateEmp.cityid)"
        txtCountry.text = updateEmp.conid
        txtFName.text = updateEmp.fName
        txtMName.text = updateEmp.mName
        txtLName.text = updateEmp.lName
        txtMailID.text = updateEmp.mail
        txtExtenNo.text = updateEmp.exten
        txtMobileNo.text = updateEmp.mobile
        bttnSaveUpdate.setTitle("Update", for: .normal)
        GeneralClass.instance.dislayCountryFlag(oImg: oImgCountryFlag, countryId: updateEmp.conid )
    }
}
