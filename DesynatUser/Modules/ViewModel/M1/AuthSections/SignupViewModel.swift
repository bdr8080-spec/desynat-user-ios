//
//  SignupViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 28/10/25.
//


import Foundation
import UIKit

class SignupViewModel: NSObject {
    private var hostVC: SignupViewController
    
    init(hostVC: SignupViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImage == nil {
            errorMessage = .SelectProfileImage
        }
        
        let fullName = String.getString(hostVC.fullNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullName.isEmpty {
                errorMessage = .EnterFullName
            }
        }
        
        
        let mobile = String.getString(hostVC.mobileTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if mobile.isEmpty {
                errorMessage = .EnterMobileNumber
            } else if !mobile.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        }
        
        
        let email = String.getString(hostVC.emailTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if email.isEmpty {
                errorMessage = .EnterEmail
            } else if !email.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        }
        
        
        let password = String.getString(hostVC.createPasswordTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            } else if !password.isValidPassword() {
                errorMessage = .InvalidPasswordFormat
            }
        }
        
        let confirmPassword = String.getString(hostVC.confirmPasswordTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if confirmPassword.isEmpty {
                errorMessage = .EnterConfirmPassword
            } else if confirmPassword != password {
                errorMessage = .PasswordNotMatched
            }
        }
        
        if errorMessage == .none {
            if !hostVC.isTermsAccepted {
                errorMessage = .AcceptTermsAndConditions
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func signupApi() {
        let params: [String:Any] = [
            "full_name": hostVC.fullNameTextField.text?.trimmed() ?? "",
            "country_code": hostVC.countryCodeTextField.text?.trimmed() ?? "",
            "mobile": hostVC.mobileTextField.text?.trimmed() ?? "",
            "email": hostVC.emailTextField.text?.trimmed() ?? "",
            "password": hostVC.createPasswordTextField.text?.trimmed() ?? "",
            "confirm_password": hostVC.confirmPasswordTextField.text?.trimmed() ?? ""]
        WebService.sharedInstance.registerUserService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .signup
            let phoneNumber = "\(self.hostVC.countryCode)\(self.hostVC.mobileTextField.text?.trimmed() ?? "")"
            vc.phoneNumber = phoneNumber
            vc.userId = "\(response.id ?? 0)"
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
