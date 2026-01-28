//
//  AffiliatedUserAddressAdditionViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import Foundation

class AffiliatedUserAddressAdditionViewModel {
    
    private var hostVC: AffiliatedUserAddressAdditionViewController
    var getAllUSerCountryList: [CountryModel] = []
    
    init(hostVC: AffiliatedUserAddressAdditionViewController) {
        self.hostVC = hostVC
    }
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.getAllUSerCountryList = list
        }
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        let countryName = String.getString(hostVC.countryTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let location = String.getString(hostVC.locationTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let addressLineOne = String.getString(hostVC.addresSLineOneTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let addressLineTwo = String.getString(hostVC.addressLineTwoTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
//        let pincode = String.getString(hostVC.pinCodeTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
//        let locality = String.getString(hostVC.locationTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
//        let state = String.getString(hostVC.stateTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
//        let city = String.getString(hostVC.cityTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        // MARK: - Validate Image Uploads
        if countryName.isEmpty {
            errorMessage = .chooseCountry
        } else if location.isEmpty {
            errorMessage = .chooseLocation
        } else if addressLineOne.isEmpty {
            errorMessage = .addressLine1
        } else if addressLineTwo.isEmpty {
            errorMessage = .addressLine2
        } //else if pincode.isEmpty {
//            errorMessage = .enterPincode
//        } else if locality.isEmpty {
//            errorMessage = .enterlocalityTown
//        } else if state.isEmpty {
//            errorMessage = .EnterState
//        } else if city.isEmpty {
//            errorMessage = .EnterCity
//        }
        
        // MARK: - Show Alert if Needed
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    //Mark:->UploadDocumentApi
    func addAddressApi(){
        let param:[String:Any] = [
            "country": hostVC.selectedCountryCode ?? "+965",
            "locations": hostVC.locationTF.text ?? "",
            "address1": hostVC.addresSLineOneTF.text ?? "",
            "address2": hostVC.addressLineTwoTF.text ?? "",
//            "pincode": hostVC.pinCodeTF.text ?? "",
//            "town": hostVC.localityTownTD.text ?? "",
//            "state": hostVC.stateTF.text ?? "",
//            "city": hostVC.cityTF.text ?? "",
            "let": hostVC.latitude ?? 0.0,
            "long": hostVC.longitude ?? 0.0]
        WebService.sharedInstance.addAddressAffiliatedAccountService(param: param) { user in
            let nextVC = AddBankDetailsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}
