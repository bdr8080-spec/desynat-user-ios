//
//  ForgotPasswordViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 28/10/25.
//


import Foundation
import UIKit

class ForgotPasswordViewModel: NSObject {
    
    private var hostVC: ForgotPasswordViewController
    var getAllUSerCountryList:[CountryModel] = []
    var getSevenCountryList:[CountryModel] = []
    
    init(hostVC: ForgotPasswordViewController) {
        self.hostVC = hostVC
    }
    
    
    func validFields(mobileIsSelected: Bool) -> Bool {
        var errorMessage: AlertConstant = .none
        if mobileIsSelected {
            let input = String.getString(hostVC.mobileTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .EnterMobileNumber
            }else if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else {
            let input = String.getString(hostVC.emailAddressTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .EnterEmail
            } else if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func forgotPasswordApi(mobileIsSelected: Bool) {
        var params: [String: Any] = [:]
        
        if mobileIsSelected {
            params = [
                "type": "0", // 0 for mobile
                "country_code": hostVC.countryCode,
                "mobile": hostVC.mobileTextField.text?.trimmed() ?? ""
            ]
        } else {
            params = [
                "type": "1", // 1 for email
                "email": hostVC.emailAddressTextField.text?.trimmed() ?? ""
            ]
        }
        WebService.sharedInstance.forgotPasswordService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .forgotPassword
            if mobileIsSelected {
                vc.phoneNumber = self.hostVC.mobileTextField.text?.trimmed() ?? ""
                vc.countryCode = self.hostVC.countryCode
            } else{
                vc.phoneNumber = self.hostVC.emailAddressTextField.text?.trimmed() ?? ""
            }
            vc.isEnteredPhoneNumber = mobileIsSelected
            vc.userId = "\(response.id ?? 0)"
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func forgotPasswordApiForAffiliatedUser(mobileIsSelected: Bool) {
        var params: [String: Any] = [:]
        
        if mobileIsSelected {
            params = [
                "type": "0", // 0 for mobile
                "country_code": hostVC.countryCode,
                "mobile": hostVC.mobileTextField.text?.trimmed() ?? ""
            ]
        } else {
            params = [
                "type": "1", // 1 for email
                "email": hostVC.emailAddressTextField.text?.trimmed() ?? ""
            ]
        }
        WebService.sharedInstance.forgotPasswordForAffiliatedUserService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .forgotPasswordForAffiliatedUser
            if mobileIsSelected {
                vc.phoneNumber = self.hostVC.mobileTextField.text?.trimmed() ?? ""
                vc.countryCode = self.hostVC.countryCode
            } else{
                vc.phoneNumber = self.hostVC.emailAddressTextField.text?.trimmed() ?? ""
            }
            vc.isEnteredPhoneNumber = mobileIsSelected
            vc.userId = "\(response.id ?? 0)"
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getALlUserCountryListApi(){
        WebService.sharedInstance.getAllUserscountryList { list in
            self.getAllUSerCountryList = list
        }
    }
    
    func sevenCountryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.getSevenCountryList = list
        }
    }
    
}
