//
//  ConstantOrVariables.swift
//  sapuserdetails
//
//  Created by Praveer on 13/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import Foundation

//Local storage variables
let userDefault = UserDefaults.standard

let C_PASSWORD_KEY: String = "PWD"
let C_USERID_KEY: String = "UID"

var gUserid: String!{
    get{
        return userDefault.string(forKey: C_USERID_KEY)
    }
    set{
        userDefault.set(newValue, forKey: C_USERID_KEY)
    }
}

var gPassword: String!{
    get{
        return userDefault.string(forKey: C_PASSWORD_KEY)
    }
    set{
        userDefault.set(newValue, forKey: C_PASSWORD_KEY)
    }
}

//country Flag Link
let C_FLAG_URL: String = "https://www.countryflags.io/CNT/flat/48.png"
let C_COUNTRY_URL: String = "https://restcountries.eu/rest/v2/alpha/"

//URL and Entity information
let MAIN_URL: String = "https://hdbprvp901189trial.hanatrial.ondemand.com/users/employee.xsodata"
let EMPLOYEE_ENTITY: String = "employee"
let COUNTRY_ENTITY: String = "country"
let CITY_ENTITY: String = "city"


//Fields name to oData Service
let FLD_CODE: String = "CODE"
let FLD_CODE3: String = "CODE3"
let FLD_FLAG: String = "FLAG"
let FLD_REGION: String = "REGION"
let FLD_GEOLAT: String = "GEOLAT"
let FLD_GEOLANG: String = "GEOLANG"
let FLD_GEOLONG: String = "GEOLONG"
let FLD_NAME: String = "NAME"
let FLD_NATIVENAME: String = "NATIVENAME"
let FLD_CAPITAL: String = "CAPITAL"


let FLD_CON_ID: String = "CON_ID"

let FLD_ID: String = "ID"
let FLD_FNAME: String = "FNAME"
let FLD_MNAME: String = "MNAME"
let FLD_LNAME: String = "LNAME"
let FLD_MAIL: String = "MAIL"
let FLD_EXTEN: String = "EXTEN"
let FLD_MOBILE: String = "MOBILE"
let FLD_COUNTRY: String = "COUNTRY"
let FLD_CITY: String = "CITY"

//Structure information to display in different pages

struct employee {
    var id: Int
    var Name: String
    var fName: String
    var mName: String
    var lName: String
    var mail: String
    var exten:String
    var mobile:String
    var contact: String
    var country: String
    var conid: String
    var city: String
    var cityid: String
}
var updateEmp: employee!
var displayEmp: employee!
var iEmployes: [employee] = []

struct country {
    var code: String
    var flagurl: String
    var region: String
    var name: String
    var native: String
    var capital: String
    var lat: Float
    var long: Float
}
var iCountry:[country] = []
var iSearchCountry = [country]()

struct city {
    var concode: String
    var id: String
    var name: String
    var lat: Float
    var long: Float
}
var iCity:[city] = []
var iSearchCity = [city]()

var isSearching: Bool = false
var selCountry: String!
var selCity: String!

typealias ComplitionHandler = (_ Success: Bool) ->()

let C_EMPLOYEE_DETAILS: String = "EmployeeDetails"
let C_EMPLOYEE_CELL: String = "EmployeeCell"
let C_NEWUPDATE_EMP_VC: String = "NewUpdateEmployeeVC"
let C_COUNTRY_CELL: String = "CountryCell"
let C_COUNTRY_SEARCH_VC: String = "CountrySearchVC"
let C_CITYSERACH_VC: String = "CitySearchVC"
let C_CITY_CELL: String = "CityCell"

var calcArea: Double! = 100000
