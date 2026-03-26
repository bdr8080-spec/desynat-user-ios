//
//  CreateAffiliateUserAccountViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import Foundation

class CreateAffiliateUserAccountViewModel: NSObject {
    
    private var hostVC: CreateAffiliateUserAccountViewController
    var countryList:[CountryModel] = []
    
    init(hostVC: CreateAffiliateUserAccountViewController) {
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
        
        if errorMessage == .none {
            if hostVC.selectedImageDoc1 == nil {
                errorMessage = .UplaodDoc1
            }
        }
        
        if errorMessage == .none {
            if hostVC.selectedImageDoc2 == nil {
                errorMessage = .UplaodDoc2
            }
        }
        
        let password = String.getString(hostVC.txtCreatePassword.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }else if !password.isValidPassword() {
                errorMessage = .InvalidPasswordFormat
            }
        }
        
        let confirmPassword = String.getString(hostVC.txtConfirmPassword.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if confirmPassword.isEmpty {
                errorMessage = .confirmPasswordForAffiliate
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

    //Mark:->SignUpAPi
    func signUpApi(){
        let params:[String:Any] = [
            "profile_image": hostVC.profileImage,
            "full_name": hostVC.fullNameTextField.text ?? "",
            "country_code": hostVC.countryCode,
            "mobile": hostVC.mobileTextField.text ?? "",
            "email": hostVC.emailTextField.text ?? "",
            "password": hostVC.txtCreatePassword.text ?? "",
            "confirm_password": hostVC.txtConfirmPassword.text ?? "",
            "document1": hostVC.uplaodDocuOneImage,
            "document2": hostVC.uploadDocTwoImage,
            "accept": 1,
            "device_type": 1,
            "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? ""]
        
        WebService.sharedInstance.createAffiliatedAccountService(param:params) { response in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .accountCreateAffiliateUser
            vc.phoneNumber = self.hostVC.mobileTextField.text?.trimmed() ?? ""
            vc.countryCode = self.hostVC.countryCode
            vc.isEnteredPhoneNumber = true
            vc.userId = "\(response.id ?? 0)"
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func documentReupload(){
        let params:[String:Any] = [
            "profile_image": hostVC.profileImage,
            "full_name": hostVC.fullNameTextField.text ?? "",
//            "country_code": hostVC.countryCode,
//            "mobile": hostVC.mobileTextField.text ?? "",
//            "email": hostVC.emailTextField.text ?? "",
            "password": hostVC.txtCreatePassword.text ?? "",
            "confirm_password": hostVC.txtConfirmPassword.text ?? "",
            "document1": hostVC.uplaodDocuOneImage,
            "document2": hostVC.uploadDocTwoImage,
            "accept": 1,
            "device_type": 1,
            "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? ""]
        
        WebService.sharedInstance.reuploadDocumnetsAffiliatedAccountService(param:params) { response in
            let nextVC = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryList = list
        }
    }
    
}
