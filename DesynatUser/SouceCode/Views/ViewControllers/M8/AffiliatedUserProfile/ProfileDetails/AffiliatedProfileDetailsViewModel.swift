//
//  AffiliatedProfileDetailsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation
import SDWebImage

class AffiliatedProfileDetailsViewModel {
    
    private var hostVC: AffiliatedProfileDetailsViewController
    var countryList:[CountryModel] = []
    var affiliatedUserProfile: AffiliateCreateAccountDataModel?
    var isCountryListLoaded = false
    
    init(hostVC: AffiliatedProfileDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryList = list
            self.isCountryListLoaded = true
                    self.setCountryIfPossible()
        }
    }
    
    func getUserProfileApi(){
        WebService.sharedInstance.getAffiliatedProfileService() { response in
            kSharedUserDefaults.saveModelFor(key: .affiliatedUserDeatils, value: response)
            kSharedUserDefaults.saveStringFor(Key: .savedUserCurrency, value: String.getString(response.userCurrency?.currencyCode))
            kSharedUserDefaults.saveStringFor(Key: .exchangeRateOfCurrency, value: String.getString(response.userCurrency?.exchangeRate))
            self.affiliatedUserProfile = response
            self.populateData(data: response)
            self.setCountryIfPossible()
        }
    }
    
    func populateData(data: AffiliateCreateAccountDataModel?) {
        if let imageUrlString = data?.profileImage,
           let url = URL(string: imageUrlString) {
            hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
            hostVC.selectedProfileImageUrl = imageUrlString
        }
        hostVC.fullNameTF.text = data?.fullName
        hostVC.countryCodeTF.text = data?.countryCode
        hostVC.mobileTF.text = data?.mobile
        hostVC.emailTF.text = data?.email
        if let imageUrlString = data?.document1,
           let url = URL(string: imageUrlString) {
            hostVC.documentOneImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            hostVC.documentOneImageView.sd_imageIndicator?.startAnimatingIndicator()
            hostVC.documentOneImageView.sd_setImage(with: url, placeholderImage: .dashedBorder)
            hostVC.documentOneImageView.enableFullscreenZoom()
            hostVC.uplaodDocuOneImage = imageUrlString
        }
        if let imageUrlString = data?.document2,
           let url = URL(string: imageUrlString) {
            hostVC.documentTwoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            hostVC.documentTwoImageView.sd_imageIndicator?.startAnimatingIndicator()
            hostVC.documentTwoImageView.sd_setImage(with: url, placeholderImage: .dashedBorder)
            hostVC.documentTwoImageView.enableFullscreenZoom()
            hostVC.uploadDocTwoImage = imageUrlString
        }
        self.hostVC.selectedAddressCountryCode = data?.addressDetails?.country
        hostVC.locationTF.text = data?.addressDetails?.locations
        hostVC.addressLineOneTF.text = data?.addressDetails?.address1
        hostVC.addressLineTwoTF.text = data?.addressDetails?.address2
        hostVC.latitude = convertToDouble(data?.addressDetails?.addressDetailsLet ?? "0.0")
        hostVC.longitude = convertToDouble(data?.addressDetails?.long ?? "0.0")
        hostVC.bankAccountTableView.reloadData()
    }
    
    func setCountryIfPossible() {
        guard isCountryListLoaded,
              let code = hostVC.selectedAddressCountryCode,
              !countryList.isEmpty else { return }
        
        if let matchedCountry = countryList.first(where: { $0.id?.description == code }) {
            DispatchQueue.main.async {
                self.hostVC.countryTF.text = matchedCountry.name
            }
        }
    }
    
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
    func validateAddressFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        let countryName = String.getString(hostVC.countryTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let location = String.getString(hostVC.locationTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let addressLineOne = String.getString(hostVC.addressLineOneTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let addressLineTwo = String.getString(hostVC.addressLineTwoTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        // MARK: - Validate Image Uploads
        if countryName.isEmpty {
            errorMessage = .chooseCountry
        } else if location.isEmpty {
            errorMessage = .chooseLocation
        } else if addressLineOne.isEmpty {
            errorMessage = .addressLine1
        } else if addressLineTwo.isEmpty {
            errorMessage = .addressLine2
        }
        
        // MARK: - Show Alert if Needed
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func updateAffiliatedAddressService(){
        let param:[String:Any] = [
            "country": hostVC.selectedAddressCountryCode ?? 0,//hostVC.countryTF.text ?? "Kuwait",
            "locations": hostVC.locationTF.text ?? "",
            "address1": hostVC.addressLineOneTF.text ?? "",
            "address2": hostVC.addressLineTwoTF.text ?? "",
            "let": hostVC.latitude ?? 0.0,
            "long": hostVC.longitude ?? 0.0]
        WebService.sharedInstance.updateAffiliatedAddressService(param: param) { response in
            CommonUtils.showToast(message: "Address updated successfully".localiz())
            //            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func validatePersonalInfoFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedProfileImageUrl == "" {
            errorMessage = .SelectProfileImage
        }
        
        let fullName = String.getString(hostVC.fullNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullName.isEmpty {
                errorMessage = .EnterFullName
            }
        }
        
        let mobile = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if mobile.isEmpty {
                errorMessage = .EnterMobileNumber
            } else if !mobile.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        }
        
        let email = String.getString(hostVC.emailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if email.isEmpty {
                errorMessage = .EnterEmail
            } else if !email.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        }
        
        if errorMessage == .none {
            if hostVC.uplaodDocuOneImage == "" {
                errorMessage = .UplaodDoc1
            }
        }
        
        if errorMessage == .none {
            if hostVC.uploadDocTwoImage == "" {
                errorMessage = .UplaodDoc2
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func updateAffiliatedProfileService(){
        let param: [String: Any] = ["profile_image": hostVC.selectedProfileImageUrl,
                                    "full_name": hostVC.fullNameTF.text?.trimmed() ?? "",
                                    "country_code": hostVC.countryCodeTF.text?.trimmed() ?? "",
                                    "mobile": hostVC.mobileTF.text?.trimmed() ?? "",
                                    "email": hostVC.emailTF.text?.trimmed() ?? "",
                                    "document1": hostVC.uplaodDocuOneImage,
                                    "document2": hostVC.uploadDocTwoImage]
        WebService.sharedInstance.updateAffiliatedProfileService(param: param) { response in
            kSharedUserDefaults.saveModelFor(key: .affiliatedUserDeatils, value: response)
            CommonUtils.showToast(message: "Profile updated successfully".localiz())
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func deleteBankAccountAffilaitedUserApi(id: Int){
        let param: [String: Any] = ["bank_details_id": id]
        WebService.sharedInstance.deleteBankAccountAffilaitedUserService(param: param) { response in
            self.getUserProfileApi()
        }
    }
    
    func makeDefaultBankAccountAffilaitedUserApi(id: Int){
        let param: [String: Any] = ["id": id]
        WebService.sharedInstance.makeDefaultBankAccountAffilaitedUserService(param: param) { response in
            CommonUtils.showToast(message: "Bank Account changed succesfully".localiz())
            self.getUserProfileApi()
        }
    }
    
    //Mark->:changeMobileNumberApi
    func changeMobileNumberApi(){
        let param:[String:Any] = [
            "for":"mobile", //mobile,email
            "country_code":self.hostVC.countryCodeTF.text ?? "",
            "mobile":self.hostVC.mobileTF.text ?? "",
            "type":"0"] //0-old,1-new
        
        WebService.sharedInstance.changeMobileNumberForAffiliateUserService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .changeOldMobileNumberForAffiliatedUser
            vc.id = "\(user.id ?? 0)"
            vc.isEnteredPhoneNumber = true
            vc.phoneNumber = self.hostVC.mobileTF.text?.trimmed() ?? ""
            vc.countryCode = self.hostVC.countryCodeTF.text?.trimmed() ?? ""
            vc.callBackForProfileDetails = { mobile,countryCode,_ in
                self.hostVC.mobileTF.text = mobile
                self.hostVC.countryCodeTF.text = countryCode
            }
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    //Mark->:changeEmailApi
    func changeEmailApi(){
        let param:[String:Any] = [
            "for":"email", //mobile,email
            "email":self.hostVC.emailTF.text ?? "",
            "type":"0"] //0-old,1-new
        WebService.sharedInstance.changeMobileNumberForAffiliateUserService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .changeOldEmailNumberForAffiliatedUser
            vc.id = "\(user.id ?? 0)"
            vc.isEnteredPhoneNumber = false
            vc.phoneNumber = self.hostVC.emailTF.text?.trimmed() ?? ""
            vc.callBackForProfileDetails = { _, _, email in
                self.hostVC.emailTF.text = email
            }
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func convertToDouble(_ string: String) -> Double? {
        guard let value = Double(string) else {
            return nil
        }
        return value
    }
}
