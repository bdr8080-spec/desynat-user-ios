//
//  AddAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class AddAddressViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUserSetup()
    }
    
    private func initialUserSetup() {
        switch comingReason {
        case .forAddNewAddress:
            titleLabel.text = "ADD NEW ADDRESS"
            buttonLabel.text = "Add Address"
        case .forEditAddress:
            titleLabel.text = "Edit ADDRESS"
            buttonLabel.text = "Update"
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

}

enum comingReasonAtAddAddress {
    case forEditAddress
    case forAddNewAddress
}
