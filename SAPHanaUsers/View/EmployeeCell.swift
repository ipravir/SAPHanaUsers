//
//  EmployeeCell.swift
//  sapuserdetails
//
//  Created by Praveer on 13/07/20.
//  Copyright © 2020 Praveer. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var lblEmployeeMail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ActionEmployeeInfo(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else { return }
        guard let otab = cell.superview as? UITableView else { return }
        guard let indexPath = otab.indexPath(for: cell) else { return }
        
        guard let oDetails = getTopMostViewController()?.storyboard?.instantiateViewController(identifier: C_NEWUPDATE_EMP_VC) as? NewUpdateEmployeeVC else {return}
        displayEmp = iEmployes[indexPath.row]
        oDetails.modalPresentationStyle = .fullScreen
        oDetails.viewDidAppear(true)
        getTopMostViewController()?.present(oDetails, animated: true, completion: nil)
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    func AddEmployee(index: IndexPath){
        lblEmployeeName.text = iEmployes[index.row].Name
        lblEmployeeMail.text = iEmployes[index.row].mail
    }
}
