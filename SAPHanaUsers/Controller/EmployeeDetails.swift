//
//  EmployeeDetails.swift
//  sapuserdetails
//
//  Created by Praveer on 13/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class EmployeeDetails: UIViewController {

    @IBOutlet weak var otTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        otTable.dataSource = self
        otTable.delegate = self
        otTable.rowHeight = 60
        otTable.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    @IBAction func ActionBackToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ActionNewEmployee(_ sender: Any) {
        guard let oEmployee = self.storyboard?.instantiateViewController(identifier: C_NEWUPDATE_EMP_VC) else {return}
        oEmployee.modalPresentationStyle = .fullScreen
        self.present(oEmployee, animated: true, completion: nil)
    }
    
    @objc func refreshView(){
        otTable.reloadData()
    }
}

extension EmployeeDetails: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iEmployes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = otTable.dequeueReusableCell(withIdentifier: C_EMPLOYEE_CELL, for: indexPath) as? EmployeeCell else { return UITableViewCell() }
        cell.AddEmployee(index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete") { (rowaction, indexpath) in
                SAPServices.instance.deleteEmployee(empId: iEmployes[indexPath.row].id) { (response) in
                    if response == true{
                        iEmployes.remove(at: indexPath.row)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
            }
            deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1419887841, blue: 0.1185588911, alpha: 1)

//        let updateAction = UITableViewRowAction(style: .normal, title: "Update") { (rowaction, indexpath) in
////                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
//                self.dismiss(animated: true, completion: nil)
//            }
//            deleteAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title: "Update", handler: { (action, view, completionHandler) in
            guard let oDetails = self.storyboard?.instantiateViewController(identifier: C_NEWUPDATE_EMP_VC) else {return}
            updateEmp = iEmployes[indexPath.row]
            oDetails.modalPresentationStyle = .fullScreen
            oDetails.viewDidAppear(true)
            self.present(oDetails, animated: true, completion: nil)
            completionHandler(true)
        })
        updateAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [updateAction])
        return configuration
    }
    
}
