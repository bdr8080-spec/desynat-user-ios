//
//  AddAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class AddAddressViewController: UIViewController {

    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var countryNameTF: UITextField!
    
    @IBOutlet weak var mobileTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var landMarkTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var houseNoTF: UITextField!
    
    @IBOutlet weak var postalCodeTF: UITextField!
    
    @IBOutlet weak var streetTF: UITextField!
    
    
    @IBOutlet weak var countryCodeTF: UITextField!
    
    
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homeMainView: CustomView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeIconImageView: UIImageView!
    @IBOutlet weak var officeMainView: CustomView!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var officeIconImageView: UIImageView!
    
    var lat: Double = 0.0
    var long: Double = 0.0
    var comingReason: comingReasonAtAddAddress = .forAddNewAddress
    var editAddressID: Int?
    var addressData: SavedAddressList?
    private lazy var viewModel = AddaddressViewModel(hostVC: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUserSetup()
        viewModel.countryListApi()
    }
    
    private func initialUserSetup() {
        switch comingReason {
        case .forAddNewAddress:
            titleLabel.text = "ADD NEW ADDRESS"
            buttonLabel.text = "Add Address"
        case .forEditAddress:
            titleLabel.text = "Edit ADDRESS"
            buttonLabel.text = "Update"
            prefillData()
        }
    }
    
    @IBAction func officeDidTapped(_ sender: Any) {
        officeLabel.textColor = UIColor.darkBrown
        officeIconImageView.image = UIImage(named: "office")?.withRenderingMode(.alwaysTemplate)
        officeIconImageView.tintColor = UIColor.darkBrown
        officeMainView.backgroundColor = UIColor(hexString: "#FFF7EA")
        homeLabel.textColor = UIColor.black
        homeMainView.backgroundColor = UIColor(hexString: "#FFFFFF")
        homeIconImageView.image = UIImage(named: "homeAddress")?.withRenderingMode(.alwaysTemplate)
        homeIconImageView.tintColor = UIColor.black

    }
    
    @IBAction func homeDidTapped(_ sender: Any) {
        homeLabel.textColor = UIColor.darkBrown
        homeIconImageView.image = UIImage(named: "homeAddress")?.withRenderingMode(.alwaysTemplate)
        homeIconImageView.tintColor = UIColor.darkBrown
        homeMainView.backgroundColor = UIColor(hexString: "#FFF7EA")
        officeLabel.textColor = UIColor.black
        officeIconImageView.image = UIImage(named: "office")?.withRenderingMode(.alwaysTemplate)
        officeIconImageView.tintColor = UIColor.black
        officeMainView.backgroundColor = UIColor(hexString: "#FFFFFF")
    }
    
    @IBAction func addressDidTapped(_ sender: Any) {
//        let vc = LocationViewController.instantiate(fromAppStoryboard: .Main)
        let vc = LocationViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .fromAddAddress
           vc.locationCallBack = { [weak self] address, locality, city, state, country, pincode, lat, long in
               guard let self = self else { return }
               
               // ✅ Safely unwrap each value with fallbacks
               let safeAddress = address.isEmpty ? "" : address
               let safeLocality = locality.isEmpty ? "" : locality
               let safeCity = city.isEmpty ? "" : city
               let safeState = state.isEmpty ? "" : state
               let safeCountry = country.isEmpty ? "" : country
               let safePincode = pincode.isEmpty ? "" : pincode
               
               // ✅ Assign values properly to all fields
//               self.storeAddressTextField.text = safeAddress
//               self.addressLineOneTextField.text = safeLocality
//               self.addressLineTwoTextField.text = "\(safeCity), \(safeState) - \(safePincode)"
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

//               self.addressLineTwoTextField.text = address

//               self.txtCountry.text = safeCountry
               
               self.lat = lat
               self.long = long
           }
           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func countyrCodeDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryList.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }

        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryList[index]
            let code = selectedCountry.dialCode ?? "+965"
            self.countryCodeTF.text = code
        }
    }
    
    
    @IBAction func countyDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.countryList.map { country -> String in
            let name = country.name ?? ""
            return "\(name)"
        }

        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryList[index]
            let name = selectedCountry.name ?? ""
            self.countryNameTF.text = name
        }
    }
    
    @IBAction func addDidTapped(_ sender: Any) {
        viewModel.addOrUpdateAddressApi()
    }
    
    private func prefillData() {
        guard let data = addressData else { return }

        nameTF.text = data.name
        countryCodeTF.text = data.countryCode
        mobileTF.text = data.mobile
        addressTF.text = data.address
        landMarkTF.text = data.landmark
        cityTF.text = data.city
        stateTF.text = data.state
        houseNoTF.text = data.houseNo
        postalCodeTF.text = data.postalCode
        streetTF.text = data.streetNo
        
        // Update Lat Long
        lat = Double(data.latitude ?? "0") ?? 0.0
        long = Double(data.longitude ?? "0") ?? 0.0

        // Home = 1, Office = 0
        if data.saveAddressAs == 1 {
            homeDidTapped(UIView())
        } else {
            officeDidTapped(UIView())
        }
    }

    
}

enum comingReasonAtAddAddress {
    case forEditAddress
    case forAddNewAddress
}
