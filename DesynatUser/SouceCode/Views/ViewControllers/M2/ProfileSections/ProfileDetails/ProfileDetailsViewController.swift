//
//  ProfileDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ProfileDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changeMobileNumberAction(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .changeOldMobileNumber
//        vc.phoneNumber = self.hostVC.mobileTextField.text?.trimmed() ?? ""
//        vc.countryCode = self.hostVC.countryCode
//        vc.isEnteredPhoneNumber = true
//        vc.userId = "\(response.id ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        let vc = ChangePassowrdViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func changeEmailBtnAction(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .changeOldEmail
//        vc.phoneNumber = self.hostVC.emailAddressTextField.text?.trimmed() ?? ""
//        vc.isEnteredPhoneNumber = false
//        vc.userId = "\(response.id ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
