//
//  AddAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class AddAddressViewController: UIViewController {
    
    // MARK: - IBOutlet's
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
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AddaddressViewModel(hostVC: self)
    private var dropdown: CustomDropdown?
    private var overlayView: UIView?
    var lat: Double = 0.0
    var long: Double = 0.0
    var comingReason: comingReasonAtAddAddress = .forAddNewAddress
    var editAddressID: Int?
    var addressData: SavedAddressList?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUserSetup()
        viewModel.getALlUserCountryListApi()
        [nameTF, countryNameTF, mobileTF, addressTF, landMarkTF,
         cityTF, stateTF, houseNoTF, postalCodeTF, streetTF, countryCodeTF]
            .forEach { $0?.delegate = self }
    }
    
    // MARK: - Button's Action
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
        let vc = LocationViewController.instantiate(fromAppStoryboard: .Profile)
        vc.preSelectedLat = lat
        vc.preSelectedLng = long
        vc.locationCallBack = { [weak self] address, localityName, locality, city, state, country, pincode, lat, long in
            guard let self = self else { return }
            
            // Split the address into components
            var components = address.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            
            // Remove any component that matches city, state, country, or postal code
            components.removeAll { comp in
                comp == city || comp == state || comp == country || comp == pincode
            }
            
            // Determine addressTF and houseNoTF
            if components.count >= 2 {
                // addressTF = all except last component
                let addressPart = components.dropLast().joined(separator: ", ")
                self.addressTF.text = !addressPart.isEmpty ? addressPart : components.first
                // houseNoTF = last component
                self.houseNoTF.text = components.last
            } else if components.count == 1 {
                self.addressTF.text = components[0]
                self.houseNoTF.text = components[0]
            } else {
                // fallback if empty
                let fallback = !locality.isEmpty ? locality : !city.isEmpty ? city : !state.isEmpty ? state : "N/A"
                self.addressTF.text = fallback
                self.houseNoTF.text = fallback
            }
            
            // Fallback-safe values for other fields
            self.cityTF.text = !city.isEmpty ? city : (!locality.isEmpty ? locality : self.addressTF.text)
            self.stateTF.text = !state.isEmpty ? state : (!city.isEmpty ? city : (!locality.isEmpty ? locality : self.addressTF.text))
            self.countryNameTF.text = !country.isEmpty ? country : "Country"
            self.postalCodeTF.text = pincode
            
            // Coordinates
            self.lat = lat
            self.long = long
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func countyrCodeDidTapped(_ sender: UIButton) {
//        let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
//            let name = country.name ?? ""
//            let dialCode = country.dialCode ?? ""
//            let flag = country.flag1 ?? "🇰🇼"
//            return "\(flag)  \(name) (\(dialCode))"
//        }
        let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
                    let isArabic = AppLanguageManager.shared.currentLanguage == .ar
                    let name = isArabic ? (country.nameAr ?? country.name ?? "") : (country.name ?? "")
                    let dialCode = country.dialCode ?? ""
                    let flag = country.flag1 ?? "🇰🇼"
                    return "\(flag)  \(name) (\(dialCode))"
                }
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.getAllUSerCountryList[index]
            let code = selectedCountry.dialCode ?? "+965"
            self.countryCodeTF.text = code
        }
    }
    
    @IBAction func addDidTapped(_ sender: Any) {
        viewModel.addOrUpdateAddressApi()
    }
    
    //MARK: Function's declaration
    private func initialUserSetup() {
        switch comingReason {
        case .forAddNewAddress:
            titleLabel.text = "ADD NEW ADDRESS".localiz()
            buttonLabel.text = "Add Address".localiz()
        case .forEditAddress:
            titleLabel.text = "EDIT ADDRESS".localiz()
            buttonLabel.text = "Update".localiz()
            prefillData()
        }
    }
    
    private func prefillData() {
        guard let data = addressData else { return }
        
        nameTF.text = data.name
        countryCodeTF.text = data.countryCode
        mobileTF.text = data.mobile
        addressTF.text = data.address
        landMarkTF.text = data.landmark
        countryNameTF.text = data.countryName
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
    
    @objc private func dismissDropdown() {
        guard let dropdown = dropdown, let overlay = overlayView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            overlay.alpha = 0
            dropdown.alpha = 0
            dropdown.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            dropdown.removeFromSuperview()
            overlay.removeFromSuperview()
            self.dropdown = nil
            self.overlayView = nil
        }
    }
}

//MARK: UITextFieldDelegate Methods
extension AddAddressViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if currentText.hasPrefix(" ") { return false }
        var validation: StringValidation?
        
        if textField == nameTF {
            
            // Allowed: letters + space (inside, not at start)
            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
            
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false  // block numbers, symbols
            }
            
            return true
        }
        if textField == self.mobileTF {
            if currentText.hasPrefix(" ") {
                return false
            }
            
            validation = StringValidation(string: currentText, characterCount: 15, validation: .mobileNo)
            
            if let data = validation {
                return data.validate()
            } else {
                return true
            }
        }
        
        let noSpaceFields = [houseNoTF, postalCodeTF]
        
        if noSpaceFields.contains(where: { $0 == textField }) {
            if string == " " { return false }
        }
        return true
    }
}

struct DropDownItem {
    let title: String
    let imageUrl: String?
}

extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom)
        ])
    }
}
