//
//  AddAccountViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import Foundation

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
    
    //Mark:->UploadDocumentApi
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
