//
//  SAPService.swift
//  sapuserdetails
//
//  Created by Praveer on 13/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import Foundation
import SAPFoundation
import SAPCommon
import SAPOData

class SAPServices{
    
    static let instance = SAPServices()
    let mainUrl: URL = URL(string: MAIN_URL)!
    
    func getCountryArea(id: String)->Int{
        var area: Int!
        
        return area
    }

    func LoadOData(serviceName: String, complition: @escaping ComplitionHandler)->OnlineDataService{
        let oDataProvider = OnlineODataProvider(serviceName: serviceName, serviceRoot: mainUrl)
        oDataProvider.login(username: gUserid, password: gPassword)
        oDataProvider.serviceOptions.checkVersion = false
        let oData = OnlineDataService(provider: oDataProvider)
        if oData.hasMetadata == false{
            do {
                try oData.loadMetadata()
            } catch {
                complition(false)
                return oData
            }
        }
        return oData
    }
    
    func getEmployees(complition: @escaping ComplitionHandler){
        iEmployes = []
        let oData = self.LoadOData(serviceName: EMPLOYEE_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        let employeeEntitySet = oData.entitySet(withName: EMPLOYEE_ENTITY)
        let employeeEntityType = employeeEntitySet.entityType
        let query = DataQuery().selectAll().from(employeeEntitySet)
        do {
            //define variable to read field value
            let id = employeeEntityType.keyProperty(name: FLD_ID)
            let fname = employeeEntityType.property(withName: FLD_FNAME)
            let mname = employeeEntityType.property(withName: FLD_MNAME)
            let lname = employeeEntityType.property(withName: FLD_LNAME)
            let mail = employeeEntityType.property(withName: FLD_MAIL)
            let exten = employeeEntityType.property(withName: FLD_EXTEN)
            let mobile = employeeEntityType.property(withName: FLD_MOBILE)
            let conid = employeeEntityType.property(withName: FLD_COUNTRY)
            let cityid = employeeEntityType.property(withName: FLD_CITY)
            
            let result = try oData.executeQuery(query).entityList()
            
            for item in result.toArray() {
                let emp = employee(id: id.intValue(from: item),
                                   Name: "\(fname.stringValue(from: item)) \(mname.stringValue(from: item)) \(lname.stringValue(from: item))",
                                   fName: (fname.stringValue(from: item)),
                                   mName: (mname.stringValue(from: item)),
                                   lName: (lname.stringValue(from: item)),
                                   mail: mail.stringValue(from: item),
                                   exten: (exten.stringValue(from: item)),
                                   mobile: (mobile.stringValue(from: item)),
                                   contact: "\(exten.stringValue(from: item))-\(mobile.stringValue(from: item))",
                                   country: "",
                                   conid: conid.stringValue(from: item),
                                   city: "",
                                   cityid: cityid.stringValue(from: item))
                iEmployes.append(emp)
            }
            complition(true)
        } catch {
            complition(false)
            return
        }
    }
    
    func newEmployeeID() -> Int {
        var newid: Int! = 0
        let oData = self.LoadOData(serviceName: EMPLOYEE_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        
        let employeeEntitySet = oData.entitySet(withName: EMPLOYEE_ENTITY)
        let employeeEntityType = employeeEntitySet.entityType
        
        //define variable to read field value
        let id = employeeEntityType.keyProperty(name: FLD_ID)
        
        let query = DataQuery().select(id).from(employeeEntitySet)
        do {
            let result = try oData.executeQuery(query).entityList()
            let item = result.toArray()[result.toArray().count - 1]
            newid = id.intValue(from: item) + 1
            return newid
        } catch  {
            return newid
        }
    }
    
    func addNewEmployee(employeeId: Int, fMame: String, mName: String, lName: String, mailid: String, extenNo: String, mobileNo: String, conId: String, cityId: String, complition :@escaping ComplitionHandler) {
        let oData = self.LoadOData(serviceName: EMPLOYEE_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        
        let employeeEntitySet = oData.entitySet(withName: EMPLOYEE_ENTITY)
        let employeeEntityType = employeeEntitySet.entityType
        
        //define variable to read field value
        let id = employeeEntityType.property(withName:  FLD_ID)
        let fname = employeeEntityType.property(withName:  FLD_FNAME)
        let mname = employeeEntityType.property(withName:  FLD_MNAME)
        let lname = employeeEntityType.property(withName:  FLD_LNAME)
        let mail = employeeEntityType.property(withName:  FLD_MAIL)
        let exten = employeeEntityType.property(withName:  FLD_EXTEN)
        let mobile = employeeEntityType.property(withName:  FLD_MOBILE)
        let conid = employeeEntityType.property(withName:  FLD_COUNTRY)
        let cityid = employeeEntityType.property(withName:  FLD_CITY)
        
        let newEmployee = EntityValue.ofType(employeeEntityType)
        id.setIntValue(in: newEmployee, to: employeeId)
        fname.setStringValue(in: newEmployee, to: fMame)
        lname.setStringValue(in: newEmployee, to: lName)
        mname.setStringValue(in: newEmployee, to: mName)
        mail.setStringValue(in: newEmployee, to: mailid)
        exten.setStringValue(in: newEmployee, to: extenNo)
        mobile.setStringValue(in: newEmployee, to: mobileNo)
        conid.setStringValue(in: newEmployee, to: conId)
        cityid.setStringValue(in: newEmployee, to: cityId)
        do {
            try oData.createEntity(newEmployee)
            let emp = employee( id: employeeId,
                                Name: "\(fMame) \(mName) \(lName)",
                                fName: fMame,
                                mName: mName,
                                lName: lName,
                                mail: mailid,
                                exten: extenNo,
                                mobile: mobileNo,
                                contact: "\(extenNo)-\(mobileNo)",
                                country: "",
                                conid: conId,
                                city: "",
                                cityid: cityId)
            iEmployes.append(emp)
            complition(true)
        } catch {
            complition(false)
            return
        }
    }
    
    func updateEmployeeDetails(employeeId: Int, fMame: String, mName: String, lName: String, mailid: String, extenNo: String, mobileNo: String, conId: String, cityId: String, complition :@escaping ComplitionHandler){
        let oData = self.LoadOData(serviceName: EMPLOYEE_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        
        let employeeEntitySet = oData.entitySet(withName: EMPLOYEE_ENTITY)
        let employeeEntityType = employeeEntitySet.entityType
        
        //define variable to read field value
        let id = employeeEntityType.property(withName:  FLD_ID)
        let fname = employeeEntityType.property(withName:  FLD_FNAME)
        let mname = employeeEntityType.property(withName:  FLD_MNAME)
        let lname = employeeEntityType.property(withName:  FLD_LNAME)
        let mail = employeeEntityType.property(withName:  FLD_MAIL)
        let exten = employeeEntityType.property(withName:  FLD_EXTEN)
        let mobile = employeeEntityType.property(withName:  FLD_MOBILE)
        let conid = employeeEntityType.property(withName:  FLD_COUNTRY)
        let cityid = employeeEntityType.property(withName:  FLD_CITY)
        
        let query = DataQuery().top(1).from(employeeEntitySet).filter(id.equal(employeeId))
        
        do {
            let getEmployee = try oData.executeQuery(query).requiredEntity()
            fname.setStringValue(in: getEmployee, to: fMame)
            lname.setStringValue(in: getEmployee, to: lName)
            mname.setStringValue(in: getEmployee, to: mName)
            mail.setStringValue(in: getEmployee, to: mailid)
            exten.setStringValue(in: getEmployee, to: extenNo)
            mobile.setStringValue(in: getEmployee, to: mobileNo)
            conid.setStringValue(in: getEmployee, to: conId)
            cityid.setStringValue(in: getEmployee, to: cityId)
            try oData.updateEntity(getEmployee)
            
            complition(true)
        } catch {
            complition(false)
            return
        }
    }
    
    func deleteEmployee(empId: Int, complition: @escaping ComplitionHandler){
        let oData = self.LoadOData(serviceName: EMPLOYEE_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        
        let employeeEntitySet = oData.entitySet(withName: EMPLOYEE_ENTITY)
        let employeeEntityType = employeeEntitySet.entityType
        
        //define variable to read field value
        let id = employeeEntityType.property(withName:  FLD_ID)
        let query = DataQuery().top(1).from(employeeEntitySet).filter(id.equal(empId))
        do {
            let getEmployee = try oData.executeQuery(query).requiredEntity()
            try oData.deleteEntity(getEmployee)
            complition(true)
        } catch {
            complition(false)
            return
        }
    }
    
    func getCountyries(complition: @escaping ComplitionHandler){
        iCountry = []
        let oData = self.LoadOData(serviceName: COUNTRY_ENTITY) { (response) in
            if response == false{
                complition(false)
                return
            }
        }
        let countrySet = oData.entitySet(withName: COUNTRY_ENTITY)
        let countryType = countrySet.entityType
        
        let code = countryType.property(withName:  FLD_CODE)
        let flag = countryType.property(withName:  FLD_FLAG)
        let region = countryType.property(withName:  FLD_REGION)
        let name = countryType.property(withName:  FLD_NAME)
        let nativeName = countryType.property(withName:  FLD_NATIVENAME)
        let capital = countryType.property(withName:  FLD_CAPITAL)
        let lat = countryType.property(withName:  FLD_GEOLAT)
        let long = countryType.property(withName:  FLD_GEOLANG)
        
        do {
            let query = DataQuery().selectAll().from(countrySet)
            let result = try oData.executeQuery(query).entityList()
            
            for item in result.toArray() {
                let cont = country(code: code.stringValue(from: item),
                                   flagurl: flag.stringValue(from: item),
                                   region: region.stringValue(from: item),
                                   name: name.stringValue(from: item),
                                   native: nativeName.stringValue(from: item),
                                   capital: capital.stringValue(from: item),
                                   lat: lat.floatValue(from: item),
                                   long: long.floatValue(from: item))
                iCountry.append(cont)
            }
            complition(true)
        } catch {
            complition(false)
            return
        }
    }
    
    func getCountry(conid: String)->country{
        var cont: country!
        cont?.code = conid
        let oData = self.LoadOData(serviceName: COUNTRY_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        let countryEntitySet = oData.entitySet(withName: COUNTRY_ENTITY)
        let countryType = countryEntitySet.entityType
        let name = countryType.property(withName: FLD_NAME)
        let code = countryType.property(withName:  FLD_CODE)
        let flag = countryType.property(withName:  FLD_FLAG)
        let region = countryType.property(withName:  FLD_REGION)
        let nativeName = countryType.property(withName:  FLD_NATIVENAME)
        let capital = countryType.property(withName:  FLD_CAPITAL)
        let lat = countryType.property(withName:  FLD_GEOLAT)
        let long = countryType.property(withName:  FLD_GEOLANG)
//        let query = DataQuery().select(name).from(countryEntitySet).where(code.equal(conid))
        let query = DataQuery().selectAll().from(countryEntitySet).where(code.equal(conid))
        do {
            let result = try oData.executeQuery(query).entityList()
            for item in result {
                let cont = country(code: conid,
                    flagurl: flag.stringValue(from: item),
                    region: region.stringValue(from: item),
                    name: name.stringValue(from: item),
                    native: nativeName.stringValue(from: item),
                    capital: capital.stringValue(from: item),
                    lat: lat.floatValue(from: item),
                    long: long.floatValue(from: item))
                return cont
            }
        } catch {
            return cont
        }
        return cont
    }
    
    func getCities(conID: String, complition: @escaping ComplitionHandler){
        if iCity.count != 0{
            if iCity[0].concode == conID{
                complition(true)
                return
            } else {
                iCity = []
            }
        }
        let oData = self.LoadOData(serviceName: CITY_ENTITY) { (response) in
            if response == false{
                complition(false)
                return
            }
        }
        let citySet = oData.entitySet(withName: CITY_ENTITY)
        let cityType = citySet.entityType
        
        let conId = cityType.property(withName:  FLD_CON_ID)
        let cityId = cityType.property(withName:  FLD_CODE)
        let name = cityType.property(withName:  FLD_NAME)
        let lat = cityType.property(withName:  FLD_GEOLAT)
        let long = cityType.property(withName:  FLD_GEOLONG)
        
        let query = DataQuery().selectAll().from(citySet).where(conId.equal(conID))
        do {
            let result = try oData.executeQuery(query).entityList()
            for item in result {
                let cit = city(concode: conId.stringValue(from: item),
                               id: cityId.stringValue(from: item),
                               name: name.stringValue(from: item),
                               lat: lat.floatValue(from: item),
                               long: long.floatValue(from: item))
                iCity.append(cit)
            }
            complition(true)
        } catch {
            complition(false)
        }
        
    }
    
    func getCityName(con_id: String, cityid: String)->String{
        var cityName: String
        cityName = ""
        let oData = self.LoadOData(serviceName: CITY_ENTITY) { (response) in
            if response == false{
                return
            }
        }
        let cityEntitySet = oData.entitySet(withName: CITY_ENTITY)
        let cityType = cityEntitySet.entityType
        
        let name = cityType.property(withName: FLD_NAME)
        let conid = cityType.property(withName: FLD_CON_ID)
        let id = cityType.property(withName: FLD_CODE)
        let query = DataQuery().select(name).from(cityEntitySet).where(conid.equal(conid).and(id.equal(cityid)))
        do {
            let result = try oData.executeQuery(query).entityList()
            for item in result {
                cityName = name.stringValue(from: item)
            }
        } catch {
            return cityName
        }
        return cityName
    }
}
