//
//  AddaddressViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//

import Foundation
import UIKit

class AddaddressViewModel: NSObject {
    
    private var hostVC: AddAddressViewController
//    var countryList:[CountryModel] = []
    var getAllUSerCountryList:[GetAllUserCountryModel] = []
    
    init(hostVC: AddAddressViewController) {
        self.hostVC = hostVC
    }
    

    
    // MARK: - VALIDATION
        func validFields() -> Bool {
            
            var errorMessage: AlertConstant = .none

            if String.getString(hostVC.nameTF.text).isEmpty {
                errorMessage = .EnterName
            }
            
            else if String.getString(hostVC.mobileTF.text).isEmpty {
                errorMessage = .EnterMobileNumber
            }
            else if !String.getString(hostVC.mobileTF.text).isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
            else if String.getString(hostVC.addressTF.text).isEmpty {
                errorMessage = .EnterAddress
            }
            else if String.getString(hostVC.houseNoTF.text).isEmpty {
                errorMessage = .EnterHouseNumber
            }
//            else if String.getString(hostVC.streetTF.text).isEmpty {
//                errorMessage = .EnterStreetNumber
//            }
//            else if String.getString(hostVC.postalCodeTF.text).isEmpty {
//                errorMessage = .EnterPostalCode
//            }
            else if String.getString(hostVC.cityTF.text).isEmpty {
                errorMessage = .EnterCity
            }
            else if String.getString(hostVC.stateTF.text).isEmpty {
                errorMessage = .EnterState
            } else if String.getString(hostVC.countryCodeTF.text).isEmpty {
              errorMessage = .EnterCountryCode
          }
//          else if String.getString(hostVC.landMarkTF.text).isEmpty {
//            errorMessage = .EnterL
//        }

            if errorMessage != .none {
                hostVC.showAlert(msg: errorMessage.rawValue)
                hostVC.view.endEditing(true)
                return false
            }

            hostVC.view.endEditing(true)
            return true
        }
        
        // MARK: - ADD or EDIT API CALL
        func addOrUpdateAddressApi() {
            
            if !validFields() { return }

            let saveAs = hostVC.homeMainView.backgroundColor == UIColor(hexString: "#FFF7EA") ? 1 : 0

            var params: [String: Any] = [
                "name": String.getString(hostVC.nameTF.text),
                "country_code": String.getString(hostVC.countryCodeTF.text),
                "mobile": String.getString(hostVC.mobileTF.text),
                "address": String.getString(hostVC.addressTF.text),
                "house_no": String.getString(hostVC.houseNoTF.text),
                "street_no": String.getString(hostVC.streetTF.text),
                "postal_code": String.getString(hostVC.postalCodeTF.text),
                "city": String.getString(hostVC.cityTF.text),
                "state": String.getString(hostVC.stateTF.text),
                "landmark": String.getString(hostVC.landMarkTF.text),
                "save_address_as": saveAs,
                "latitude": "\(hostVC.lat)",
                "longitude": "\(hostVC.long)",
                "country_name": String.getString(hostVC.countryNameTF.text),
            ]

            // Editing Mode
            if hostVC.comingReason == .forEditAddress {
                params["id"] = hostVC.editAddressID ?? 0
            }

            let service: (Any) -> Void = { response in
              if self.hostVC.comingReason == .forEditAddress {
                CommonUtils.showToast(message: "Address updated successfully")
                      } else {
                        CommonUtils.showToast(message: "Address added successfully")
                      }

                      // ⏳ Delay navigation to allow toast to show clearly
                      DispatchQueue.main.async {
                          self.hostVC.navigationController?.popViewController(animated: true)
                      }
            }

            // API Call
            if hostVC.comingReason == .forEditAddress {
                WebService.sharedInstance.editAddressAPi(param: params, completion: service)
            } else {
                WebService.sharedInstance.addAddressAPi(param: params, completion: service)
            }
        }
    
//    func countryListApi(){
//        WebService.sharedInstance.countryListService { list in
//            self.countryList = list
//        }
//    }
  
  func getALlUserCountryListApi(){
        WebService.sharedInstance.getAllUserscountryList { list in
            self.getAllUSerCountryList = list
        }
    }
}

