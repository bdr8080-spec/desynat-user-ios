//
//  ChangeMobileViewModel.swift
//  DesynatUser
//
//  Created by Mohd Faizan on 07/11/25.
//

import Foundation
import UIKit

class ChangeMobileViewModel:NSObject{
    
    private var hostVC:ChangeMobileViewController
    var getAllUSerCountryList:[GetAllUserCountryModel] = []
    
    init(hostVC: ChangeMobileViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.comingToUpdateMobile == true{
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
        
        WebService.sharedInstance.changeMobileNumberService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.id = "\(user.id ?? 0)"
            if self.hostVC.comingToUpdateMobile {
                vc.comingReason = .setNewMobileNumber
                vc.isEnteredPhoneNumber = true
                vc.phoneNumber = self.hostVC.txtMobileNumber.text?.trimmed() ?? ""
                vc.countryCode = self.hostVC.countryCode
            } else {
                vc.comingReason = .setNewEmail
                vc.isEnteredPhoneNumber = false
                vc.phoneNumber = self.hostVC.txtEmail.text?.trimmed() ?? ""
            }
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getALlUserCountryListApi(){
        WebService.sharedInstance.getAllUserscountryList { list in
            self.getAllUSerCountryList = list
        }
    }
}
