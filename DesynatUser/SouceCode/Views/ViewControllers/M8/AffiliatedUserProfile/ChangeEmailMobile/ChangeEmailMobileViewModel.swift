//
//  ChangeEmailMobileViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import Foundation

class ChangeEmailMobileViewModel {
    
    private var hostVC: ChangeEmailMobileViewController!
    var countryList:[CountryModel] = []
    
    init(hostVC: ChangeEmailMobileViewController!) {
        self.hostVC = hostVC
    }
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryList = list
        }
    }
    
    // MARK: changeMobileNumberApi
    func changeMobileNumberAndEmailApi(){
        var param:[String:Any] = [:]
        
        if hostVC.comingToUpdateMobile == true{
            param = [
                "for": "mobile",
                "country_code": self.hostVC.countryCode,
                "mobile": self.hostVC.txtMobileNumber.text ?? "",
                "type": "1"]
        } else {
            param = [
                "for": "email",
                "email": self.hostVC.txtEmail.text ?? "",
                "type": "1"]
        }
           
        WebService.sharedInstance.changeMobileNumberForAffiliateUserService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.id = "\(user.id ?? 0)"
            if self.hostVC.comingToUpdateMobile {
                vc.comingReason = .setNewMobileNumberForAffiliatedUser
                vc.isEnteredPhoneNumber = true
                vc.phoneNumber = self.hostVC.txtMobileNumber.text?.trimmed() ?? ""
                vc.countryCode = self.hostVC.countryCode
            } else {
                vc.comingReason = .setNewEmailForAffiliatedUser
                vc.isEnteredPhoneNumber = false
                vc.phoneNumber = self.hostVC.txtEmail.text?.trimmed() ?? ""
            }
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        if hostVC.comingToUpdateMobile {
            let input = String.getString(hostVC.txtMobileNumber.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .changeNewMobile
            } else if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else{
            let input = String.getString(hostVC.txtEmail.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .chnageNewEmail
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
}
