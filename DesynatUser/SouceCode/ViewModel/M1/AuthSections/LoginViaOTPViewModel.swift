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
    private var isEnterPhoneNumber: Bool = false
    var getAllUSerCountryList:[GetAllUserCountryModel] = []
    
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
        let input = loginHostVC.phoneTextField.text?.trimmed() ?? ""
        var params: [String:Any] = ["email_mobile": loginHostVC.phoneTextField.text?.trimmed() ?? "",
                                    "lang": LanguageManager.currentLanguageCode]
        if input.isEmail() {
            isEnterPhoneNumber = false
            params["type"] = "1"
        }else if input.isPhoneNumber() {
            isEnterPhoneNumber = true
            params["country_code"] = loginHostVC.countryCode
            params["type"] = "0"
        }
        
        WebService.sharedInstance.loginUserViaOTPService(withParams: params) { (response) in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .loginViaOTP
            vc.phoneNumber = self.loginHostVC.phoneTextField.text?.trimmed() ?? ""
            vc.userId = "\(response.id ?? 0)"
            vc.countryCode = self.loginHostVC.countryCode
            vc.isEnteredPhoneNumber = self.isEnterPhoneNumber
            self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getALlUserCountryListApi(){
        WebService.sharedInstance.getAllUserscountryList { list in
            self.getAllUSerCountryList = list
        }
    }
}

