//
//  AddAccountViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import Foundation
import UIKit

class AddAccountViewModel {
    
    private var hostVC: AddAccountViewController
    
    init(hostVC: AddAccountViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        let iban = String.getString(hostVC.ibanTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let swiftCode = String.getString(hostVC.swiftTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let bankName = String.getString(hostVC.bankNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let accountHolder = String.getString(hostVC.accountHolderTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let accountNumber = String.getString(hostVC.accountNumberTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmAccountNumber = String.getString(hostVC.confirmAccountNumberTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        // MARK: - Validate Image Uploads
        if bankName.isEmpty {
            errorMessage = .EnterBankName
        } else if accountHolder.isEmpty {
            errorMessage = .EnterAccountHolder
        } else if accountNumber.isEmpty {
            errorMessage = .EnterAccountNumber
        } else if confirmAccountNumber.isEmpty {
            errorMessage = .EnterConfirmAccountNumber
        } else if confirmAccountNumber != accountNumber {
            errorMessage = .AccountNumberNotMatch
        } else if iban.isEmpty {
            errorMessage = .EnterIBAN
        } else if swiftCode.isEmpty {
            errorMessage = .EnterSWIFT
        }
        // MARK: - Show Alert if Needed
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func populateData() {
        if hostVC.comingForEdit {
            hostVC.titleLabel.text = "Edit Account Details"
            hostVC.buttonTitleLabel.text = "Save Changes"
            hostVC.bankNameTextField.text = hostVC.bankDetail?.bankName
            hostVC.accountHolderTextField.text = hostVC.bankDetail?.accountHolderName
            hostVC.accountNumberTF.text = hostVC.bankDetail?.accountNo
            hostVC.confirmAccountNumberTF.text = hostVC.bankDetail?.accountNo
            hostVC.ibanTextField.text = hostVC.bankDetail?.iban
            hostVC.swiftTextField.text = hostVC.bankDetail?.swift
        }
    }
    
    //MARK: UploadDocumentApi
    func addAccountApi(){
        let param:[String:Any] = [
            "bank_name": hostVC.bankNameTextField.text ?? "",
            "account_holder_name": hostVC.accountHolderTextField.text ?? "",
            "account_no": hostVC.accountNumberTF.text ?? "",
            "confirm_account_no": hostVC.confirmAccountNumberTF.text ?? "",
            "iban": hostVC.ibanTextField.text ?? "",
            "swift": hostVC.swiftTextField.text ?? ""]
        WebService.sharedInstance.addAffiliatedBankDetailsService(param:param) { user in
            self.hostVC.changesAreDone?()
            CommonUtils.showToast(message: "Account added successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateAccountApi(){
        let param:[String:Any] = [
            "bank_details_id": hostVC.bankDetail?.id ?? 0,
            "bank_name": hostVC.bankNameTextField.text ?? "",
            "account_holder_name": hostVC.accountHolderTextField.text ?? "",
            "account_no": hostVC.accountNumberTF.text ?? "",
            "confirm_account_no": hostVC.confirmAccountNumberTF.text ?? "",
            "iban": hostVC.ibanTextField.text ?? "",
            "swift": hostVC.swiftTextField.text ?? ""]
        WebService.sharedInstance.updateAffiliatedBankDetailsService(param:param) { user in
            self.hostVC.changesAreDone?()
            CommonUtils.showToast(message: "Bank details updated successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: UITextFieldDelegate Methods
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
