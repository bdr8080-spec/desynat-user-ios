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
    
//    func updateAffiliatedUserEmailService(){
//        let param: [String: Any] = ["email": hostVC.txtEmail.text?.trimmed() ?? "",
//                                    "profile_image": hostVC.affiliatedUserProfile?.profileImage ?? "",
//                                    "full_name": hostVC.affiliatedUserProfile?.fullName ?? "",
//                                    "country_code": hostVC.affiliatedUserProfile?.countryCode ?? "",
//                                    "mobile": hostVC.affiliatedUserProfile?.mobile ?? "",
//                                    "document1": hostVC.affiliatedUserProfile?.document1 ?? "",
//                                    "document2": hostVC.affiliatedUserProfile?.document2 ?? ""]
//        WebService.sharedInstance.updateAffiliatedProfileService(param: param) { response in
//            self.hostVC.changesAreDone?()
//            CommonUtils.showToast(message: "Email updated successfully")
//            self.hostVC.navigationController?.popViewController(animated: true)
//        }
//    }
    
//    func updateAffiliatedUserMobileService() {
//        let param: [String: Any] = ["country_code": hostVC.txtCountryCode.text?.trimmed() ?? "",
//                                    "mobile": hostVC.txtMobileNumber.text?.trimmed() ?? "",
//                                    "email": hostVC.affiliatedUserProfile?.email ?? "",
//                                    "profile_image": hostVC.affiliatedUserProfile?.profileImage ?? "",
//                                    "full_name": hostVC.affiliatedUserProfile?.fullName ?? "",
//                                    "document1": hostVC.affiliatedUserProfile?.document1 ?? "",
//                                    "document2": hostVC.affiliatedUserProfile?.document2 ?? ""]
//        WebService.sharedInstance.updateAffiliatedProfileService(param: param) { response in
//            self.hostVC.changesAreDone?()
//            CommonUtils.showToast(message: "Mobile number updated successfully")
//            self.hostVC.navigationController?.popViewController(animated: true)
//        }
//    }
    
    //Mark->:changeMobileNumberApi
    func changeMobileNumberAndEmailApi(){
        var param:[String:Any] = [:]
        
        if hostVC.comingToUpdateMobile == true{
            param = [
                "for":"mobile",
                "country_code":self.hostVC.countryCode,
                "mobile":self.hostVC.txtMobileNumber.text ?? "",
                "type":"1"
                
            ]
        }else{
            param = [
                "for":"email",
                "email":self.hostVC.txtEmail.text ?? "",
                "type":"1"
                
            ]
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
