//
//  AddBankDetailsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import Foundation

class AddBankDetailsViewModel: NSObject {
    private var hostVC: AddBankDetailsViewController
    
    init(hostVC: AddBankDetailsViewController) {
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
        } //else if hostVC.uploadedProofDoc == nil {
          //  errorMessage = .UploadAccountHolderImage
//        }

        // MARK: - Show Alert if Needed
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    //Mark:->UploadDocumentApi
    func uploadDocumentApi(){
        let param:[String:Any] = [
            "bank_name": hostVC.bankNameTextField.text ?? "",
            "account_holder_name": hostVC.accountHolderTextField.text ?? "",
            "account_no": hostVC.accountNumberTF.text ?? "",
            "confirm_account_no": hostVC.confirmAccountNumberTF.text ?? "",
            "iban": hostVC.ibanTextField.text ?? "",
            "swift": hostVC.swiftTextField.text ?? ""]
        WebService.sharedInstance.addBankDetailsAffiliatedUserService(param:param) { user in
        let nextVC = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

