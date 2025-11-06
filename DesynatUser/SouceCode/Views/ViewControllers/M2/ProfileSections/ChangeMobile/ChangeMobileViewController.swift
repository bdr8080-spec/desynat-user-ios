//
//  ChangeMobileViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ChangeMobileViewController: UIViewController {

    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var comingToUpdateMobile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        if comingToUpdateMobile {
            vc.comingReason = .setNewMobileNumber
        } else {
            vc.comingReason = .setNewEmail
        }
        
//        vc.phoneNumber = self.hostVC.mobileTextField.text?.trimmed() ?? ""
//        vc.countryCode = self.hostVC.countryCode
//        vc.isEnteredPhoneNumber = true
//        vc.userId = "\(response.id ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initialSetup() {
        if comingToUpdateMobile {
            titleLabel.text = "Change Mobile Number"
            emailView.isHidden = true
            mobileView.isHidden = false
        } else {
            titleLabel.text = "Change Email"
            emailView.isHidden = false
            mobileView.isHidden = true
        }
    }
}
