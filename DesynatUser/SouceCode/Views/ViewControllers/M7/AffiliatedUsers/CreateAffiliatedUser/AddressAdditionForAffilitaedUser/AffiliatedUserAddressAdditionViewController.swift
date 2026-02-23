//
//  AffiliatedUserAddressAdditionViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class AffiliatedUserAddressAdditionViewController: UIViewController {
    
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var addresSLineOneTF: UITextField!
    @IBOutlet weak var addressLineTwoTF: UITextField!
    @IBOutlet weak var pinCodeTF: UITextField!
    @IBOutlet weak var localityTownTD: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    private lazy var viewModel = AffiliatedUserAddressAdditionViewModel(hostVC: self)
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var selectedCountryCode: String? = "+965"
    var affiliatedUserToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.countryListApi()
    }
    
    @IBAction func locationdidTapped(_ sender: Any) {
        let vc = LocationViewController.instantiate(fromAppStoryboard: .Profile)
        vc.preSelectedLat = self.latitude   // your saved lat
        vc.preSelectedLng = self.longitude  // your saved long
        vc.comingReason = .affiliateUserAccountCreation
        vc.locationCallBack = { [weak self] address, localityName, locality, city, state, country, pincode, lat, long in
            guard let self = self else { return }
            let safeAddress = address.isEmpty ? "" : address
            let safeLocality = locality.isEmpty ? "" : locality
            let safeCity = city.isEmpty ? "" : city
            let safeState = state.isEmpty ? "" : state
            let safePincode = pincode.isEmpty ? "" : pincode
            self.locationTF.text = safeAddress
            var addressLineOne: [String] = []
            if !localityName.isEmpty {
                addressLineOne.append(localityName)
            }
            if !safeLocality.isEmpty {
                addressLineOne.append(safeLocality)
            }
            self.addresSLineOneTF.text = addressLineOne.joined(separator: ", ")
            
            var components: [String] = []

            if !safeCity.isEmpty {
                components.append(safeCity)
            }
            if !safeState.isEmpty {
                components.append(safeState)
            }

            var address = components.joined(separator: ", ")

            if !safePincode.isEmpty {
                address += " - \(safePincode)"
            }
            self.addressLineTwoTF.text = address
            self.latitude = lat
            self.longitude = long
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
            let name = country.name ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag) \(name)"
        }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.getAllUSerCountryList[index]
            let name = selectedCountry.name
            self.countryTF.text = name
            self.selectedCountryCode = selectedCountry.dialCode
        }
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continuedidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.addAddressApi()
        }
    }
    
}
