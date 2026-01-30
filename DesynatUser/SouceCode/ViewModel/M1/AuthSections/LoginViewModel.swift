//
//  LoginViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 28/10/25.
//


import Foundation
import UIKit

class LoginViewModel: NSObject {
    
    private var loginHostVC: LoginViewController
    var getAllUSerCountryList:[GetAllUserCountryModel] = []
    
    init(loginHostVC: LoginViewController) {
        self.loginHostVC = loginHostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        let input = String.getString(loginHostVC.emailTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if input.isEmpty {
            errorMessage = .EnterEmailOrMobileNumber
        } else if input.isEmail() {
            if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        } else if input.isPhoneNumber() {
            if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else {
            errorMessage = .EnterValidEmailorMobile
        }
        
        let password = String.getString(loginHostVC.passwordTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }
            //            else if !password.isValidPassword() {
            //                errorMessage = .InvalidPasswordFormat
            //            }
        }
        
        if errorMessage != .none {
            loginHostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        loginHostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func loginApi() {
        let input = loginHostVC.emailTextField.text?.trimmed() ?? ""
        let password = loginHostVC.passwordTextField.text?.trimmed() ?? ""
        
        var params: [String: Any] = [
            "lang": LanguageManager.currentLanguageCode,
            "password": password,
            "email_mobile": input]
        if input.isEmail() {
            params["type"] = "1"
        } else if input.isPhoneNumber() {
            params["country_code"] = loginHostVC.countryCode
            params["type"] = "0"
        } else {
            loginHostVC.showAlert(msg: AlertConstant.EnterValidEmailorMobile.rawValue)
            return
        }
        WebService.sharedInstance.loginUserService(withParams: params) { (response) in
            UserDefaults.standard.setValue("Yes", forKey:"isLogin")
            UserDefaults.standard.setValue("false", forKey:"isGuestLogin")
            kSharedSceneDelegate.navigateToUserHomeVc()
        }
    }
    
    
    func getALlUserCountryListApi(){
        WebService.sharedInstance.getAllUserscountryList { list in
            self.getAllUSerCountryList = list
        }
    }
    
//        func countryListApi(){
//            WebService.sharedInstance.countryListService { list in
//                self.countryList = list
//            }
//        }
}

