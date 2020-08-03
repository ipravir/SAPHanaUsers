//
//  ViewController.swift
//  SAPHanaUsers
//
//  Created by Praveer on 15/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class Main: UIViewController {
    @IBOutlet weak var txtUserID: TextDesign!
    @IBOutlet weak var txtPassword: TextDesign!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtUserID.text = gUserid
        txtPassword.text = gPassword
    }

    @IBAction func ActionLogin(_ sender: Any) {
        guard let userId = txtUserID.text else {return}
        guard let password = txtPassword.text else {return}
        gUserid = userId
        gPassword = password
        SAPServices.instance.getEmployees { (response) in
            if response == true{
                guard let oDetailVieww = self.storyboard?.instantiateViewController(identifier: C_EMPLOYEE_DETAILS) else {return}
                oDetailVieww.modalPresentationStyle = .fullScreen
                self.present(oDetailVieww, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func ActionCloseApp(_ sender: Any) {
        
    }    
}



