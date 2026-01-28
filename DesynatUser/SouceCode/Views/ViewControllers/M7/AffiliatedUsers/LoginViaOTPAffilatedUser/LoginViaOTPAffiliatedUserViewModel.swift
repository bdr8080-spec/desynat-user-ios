//
//  LoginViaOTPAffiliatedUserViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import Foundation
import UIKit

class LoginViaOTPAffiliatedUserViewModel: NSObject {
    
    private var loginHostVC: LoginViaOTPAffilatedUserViewController
    private var isEnterPhoneNumber: Bool = false
    var getAllUSerCountryList: [CountryModel] = []
    
    init(loginHostVC: LoginViaOTPAffilatedUserViewController) {
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
        let input = loginHostVC.phoneTextField.text?.trimmed() ?? ""
        var params: [String:Any] = [:]
        if input.isEmail() {
            isEnterPhoneNumber = false
            params["type"] = "1"
            params["email"] = loginHostVC.phoneTextField.text?.trimmed() ?? ""
        }else if input.isPhoneNumber() {
            isEnterPhoneNumber = true
            params["country_code"] = loginHostVC.countryCode
            params["mobile"] = loginHostVC.phoneTextField.text?.trimmed() ?? ""
            params["type"] = "0"
        }
        
        WebService.sharedInstance.affiliatedLoginWithOTPService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .loginViaOTPForAffiliatedUser
            vc.phoneNumber = self.loginHostVC.phoneTextField.text?.trimmed() ?? ""
            vc.userId = "\(response.id ?? 0)"
            vc.countryCode = self.loginHostVC.countryCode
            vc.isEnteredPhoneNumber = self.isEnterPhoneNumber
            self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getALlUserCountryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.getAllUSerCountryList = list
        }
    }
}

