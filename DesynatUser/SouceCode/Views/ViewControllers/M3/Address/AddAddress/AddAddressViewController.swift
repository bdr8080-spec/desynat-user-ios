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
//    viewModel.countryListApi()
    viewModel.getALlUserCountryListApi()
    [nameTF, countryNameTF, mobileTF, addressTF, landMarkTF,
     cityTF, stateTF, houseNoTF, postalCodeTF, streetTF, countryCodeTF]
      .forEach { $0?.delegate = self }
  }
  
  private func initialUserSetup() {
    switch comingReason {
    case .forAddNewAddress:
      titleLabel.text = "ADD NEW ADDRESS"
      buttonLabel.text = "Add Address"
    case .forEditAddress:
      titleLabel.text = "EDIT ADDRESS"
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
      
      self.addressTF.text = address
      self.streetTF.text = safeLocality
      self.postalCodeTF.text = safePincode
      self.cityTF.text = safeCity
      self.stateTF.text = safeState
      self.lat = lat
      self.long = long
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func countyrCodeDidTapped(_ sender: UIButton) {
//    let items: [DropDownItem] = viewModel.getAllUSerCountryList.map { country in
//        let title = "\(country.name ?? "") (\(country.dialCode ?? ""))"
//        return DropDownItem(title: title, imageUrl: country.flag)
//    }
//
//    kSharedAppDelegate.dropDownWithImage(
//        items: items,
//        anchorView: sender
//    ) { index, selectedItem in
//        let selectedCountry = self.viewModel.getAllUSerCountryList[index]
//        self.countryCodeTF.text = selectedCountry.dialCode
//    }
    
    let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
      let name = country.name ?? ""
      let code = country.dialCode ?? ""
      return "\(name) \(code)"
    }
    
    kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
      let selectedCountry = self.viewModel.getAllUSerCountryList[index]
      let code = selectedCountry.code ?? ""
      self.countryCodeTF.text = code
    }

  }
  
  
  @IBAction func countyDidTapped(_ sender: UIButton) {
//    let countryNames = viewModel.countryList.map { country -> String in
//      let name = country.name ?? ""
//      return "\(name)"
//    }
//    
//    kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
//      let selectedCountry = self.viewModel.countryList[index]
//      let name = selectedCountry.name ?? ""
//      self.countryNameTF.text = name
//    }
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
