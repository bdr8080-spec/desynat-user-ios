//
//  AddCardViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class AddCardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardHolderNameTF: UITextField!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var expiryDateTF: UITextField!
    @IBOutlet weak var cvvNumber: UITextField!
    @IBOutlet weak var savedCardForFutureButton: UIButton!
    
    var comingReason: ComingReasonAtAddCard = .savedCard
    var isSavedCardForFutureSelected: Bool = true
    private lazy var viewModel = AddCardViewModel(hostVc: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cardHolderNameTF.delegate = self
        cardNumberTF.delegate = self
        expiryDateTF.delegate = self
        cvvNumber.delegate = self
    }
    
    @IBAction func saveCardDidTapped(_ sender: UIButton) {
        isSavedCardForFutureSelected.toggle()
        let imageName = isSavedCardForFutureSelected ? "selectedFilterCheckBox" : "unslectedCheckbox"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewCardDidtapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.addNewcardApi()
        }
    }
}
extension AddCardViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardHolderNameTF {
            let currentText = textField.text ?? ""
            if currentText.hasPrefix(" ") { return false }
            // Block space as first character
            if currentText.isEmpty && string == " " {
                return false
            }
        }
       //  CARD NUMBER FORMAT
        if textField == cardNumberTF {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            // Allow only numbers
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && !string.isEmpty {
                return false
            }
            
            // Limit to 16 digits
            return updatedText.count <= 16
        }
        
        //  EXPIRY DATE FORMAT (MM/YY)
        if textField == expiryDateTF {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Remove slash
            let cleanText = updatedText.replacingOccurrences(of: "/", with: "")
            
            // Allow only numbers
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && !string.isEmpty {
                return false
            }
            
            // Max 4 digits (MMYY)
            if cleanText.count > 4 { return false }
            
            var result = ""
            
            for (index, char) in cleanText.enumerated() {
                if index == 2 {
                    result.append("/") // auto add slash
                }
                result.append(char)
            }
            
            textField.text = result
            return false
        }
        
        //  CVV (max 3 digit)
        if textField == cvvNumber {
            let current = textField.text ?? ""
            guard let stringRange = Range(range, in: current) else { return false }
            let updated = current.replacingCharacters(in: stringRange, with: string)
            return updated.count <= 3
        }
        return true
    }
    
}
enum ComingReasonAtAddCard {
    case savedCard
}
