//
//  AddNewAddressViewController.swift
//  DesynatUser
//
//  Created by fluper on 13/01/26.
//

import UIKit

class AddNewAddressForCustomViewController: UIViewController {
  
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var mobileTF: UITextField!
  @IBOutlet weak var addressTF: UITextField!
  @IBOutlet weak var landMarkTF: UITextField!
  @IBOutlet weak var cityTF: UITextField!
  @IBOutlet weak var stateTF: UITextField!
  @IBOutlet weak var postalCodeTF: UITextField!
  
  var lat: Double = 0.0
  var long: Double = 0.0
  private lazy var viewModel = AddNewAddressForCustomViewModel(hostVC: self)
  private var dropdown: CustomDropdown?
  private var overlayView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    [nameTF, mobileTF, addressTF, landMarkTF,
     cityTF, stateTF, postalCodeTF]
      .forEach { $0?.delegate = self }
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func addDidTapped(_ sender: Any) {
    viewModel.addOrUpdateAddressApi()
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


extension AddNewAddressForCustomViewController: UITextFieldDelegate {
  
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
    
    let noSpaceFields = [postalCodeTF]
    
    if noSpaceFields.contains(where: { $0 == textField }) {
      if string == " " { return false }
    }
    return true
  }
}
