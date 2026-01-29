//
//  AffiliatedUserLoginViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import Foundation
import UIKit

class AffiliatedUserLoginViewModel {
    
    private var loginHostVC: AffiliatedUserLoginViewController
    var getAllUSerCountryList:[CountryModel] = []
    
    init(loginHostVC: AffiliatedUserLoginViewController) {
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
            "password": password,
            "lang":"en",
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
        WebService.sharedInstance.loginWithPasswordForAffiliatedUser(withParams: params) { (response) in
            kSharedUserDefaults.saveStringFor(Key: .affiliatedAccessToken, value: String.getString(response.affiliatedAccessToken))
            if response.addressUpdateStatus == "0" {
                let nextVC = AffiliatedUserAddressAdditionViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.loginHostVC.navigationController?.pushViewController(nextVC, animated: true)
            } else if response.bankUpdateStatus == "0" {
                let nextVC = AddBankDetailsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.loginHostVC.navigationController?.pushViewController(nextVC, animated: true)
            } else if response.adminVerify == "2" {
                kSharedUserDefaults.saveModelFor(key: .affiliatedUserDeatils, value: response)
                UserDefaults.standard.setValue("true", forKey: "affiliatedAccountIsLoggedIn")
                kSharedSceneDelegate.navigateToAffiliatedUserHomeVc()
            } else if response.adminVerify == "4" {
                self.loginHostVC.showAlert(msg: "Document Rejected. Please Reupload it.")
                let nextVC = AffiliatedUserAddressAdditionViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.loginHostVC.navigationController?.pushViewController(nextVC, animated: true)
            }else {
                let nextVC = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.loginHostVC.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
//    
//    func getALlUserCountryListApi(){
//        WebService.sharedInstance.getAllUserscountryList { list in
//            self.getAllUSerCountryList = list
//        }
//    }
    
        func countryListApi(){
            WebService.sharedInstance.countryListService { list in
                self.getAllUSerCountryList = list
            }
        }
}

extension AffiliatedUserLoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if currentText.hasPrefix(" ") {
            return false
        }
        
        var validation: StringValidation?
        
        if textField == self.emailTextField {
            if currentText.hasPrefix(" ") {
                return false
            }
            
            if !currentText.isNumber() {
                self.viewCountryCode.isHidden = true
                emailMobileImageView.image = UIImage(named: "email")
                self.txtFieldLeading.constant = -65
                validation = StringValidation(string: currentText, characterCount: 65, validation: .emailId)
            } else {
                self.viewCountryCode.isHidden = false
                emailMobileImageView.image = UIImage(named: "phone")
                self.txtFieldLeading.constant = 12
                validation = StringValidation(string: currentText, characterCount: 15, validation: .mobileNo)
            }
    
            if let data = validation {
                return data.validate()
            } else {
                return true
            }
        }else if textField == passwordTextField{
            validation = StringValidation(string: currentText, characterCount:30, validation: .password)
        }
        return true
    }
}

