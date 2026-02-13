//
//  AddAccountViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var confirmAccountNumberTF: UITextField!
    @IBOutlet weak var accountNumberTF: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var swiftTextField: UITextField!
    @IBOutlet weak var ibanTextField: UITextField!
    @IBOutlet weak var accountHolderTextField: UITextField!
    
    private lazy var viewModel = AddAccountViewModel(hostVC: self)
    var comingForEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibanTextField.delegate = self
        swiftTextField.delegate = self
        bankNameTextField.delegate = self
        accountHolderTextField.delegate = self
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.addAccountApi()
        }
    }
    
}

extension AddAccountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true
        }
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == bankNameTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }
        
        if textField == accountHolderTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }
        
        if textField == ibanTextField {
            if string == " " {
                return false
            }
            if newText.count > 20 {
                return false
            }
            return true
        }
        
        if textField == swiftTextField {
            if string == " " {
                return false
            }
            return true
        }
        
        if newText.trimmingCharacters(in: .whitespaces).isEmpty && !newText.isEmpty {
            return false
        }
        
        return true
    }
}
