//
//  LoginViaOTPViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class LoginViaOTPViewModel: NSObject {
    
    private var loginHostVC: LoginViaOTPViewController
    
    init(loginHostVC: LoginViaOTPViewController) {
        self.loginHostVC = loginHostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        let input = String.getString(loginHostVC.phoneTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if input.isEmpty {
            errorMessage = .EnterMobileNumber
        } else if input.isPhoneNumber() {
            if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        }
        
        if errorMessage != .none {
            loginHostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        loginHostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func loginViaOTPApi() {
        let params: [String:Any] = ["email_mobile": loginHostVC.phoneTextField.text?.trimmed() ?? ""]
        WebService.sharedInstance.loginUserViaOTPService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .loginViaOTP
//            let phoneNumber = "\(self.hostVC.countryCode)\(self.loginHostVC.phoneTextField.text?.trimmed() ?? "")"
            vc.phoneNumber = self.loginHostVC.phoneTextField.text?.trimmed() ?? ""
            vc.userId = "\(response.id ?? 0)"
            self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

