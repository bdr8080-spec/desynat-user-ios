//
//  AddCardViewModel.swift
//  DesynatUser
//
//  Created by  shailendra singh on 22/04/26.
//

import Foundation
class AddCardViewModel{
    var hostVc: AddCardViewController?
    
    init(hostVc: AddCardViewController? = nil) {
        self.hostVc = hostVc
    }
    
    func addNewcardApi(){
        let params: [String: Any] = [
            "card_holder_name": hostVc?.cardHolderNameTF.text ?? "",
            "card_number": hostVc?.cardNumberTF.text?.replacingOccurrences(of: " ", with: "") ?? "",
            "expiry_date": hostVc?.expiryDateTF.text ?? "",
            "cvv": hostVc?.cvvNumber.text ?? "",
            "is_future": "1"
        ]
        WebService.sharedInstance.AddNewCardsService(param: params) { data in
            self.hostVc?.navigationController?.popViewController(animated: true)
        }
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        let cardNumber = String.getString(hostVc?.cardNumberTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cardHolderName = String.getString(hostVc?.cardHolderNameTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let expiryDate = String.getString(hostVc?.expiryDateTF.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cvv = String.getString(hostVc?.cvvNumber.text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // MARK: - Validation Checks
        
        if cardHolderName.isEmpty {
            errorMessage = .enterCardHolderName
        }else if cardNumber.isEmpty {
            errorMessage = .enterCardNumber
        } else if !cardNumber.isValidCardNumber() {
            errorMessage = .validCardNumber
            
        } else if expiryDate.isEmpty {
            errorMessage = .enterExpiryDate
            
        } else if !isValidExpiryDate(expiryDate) {
            errorMessage = .validExpiryDate
            
        } else if cvv.isEmpty {
            errorMessage = .enterCVV
            
        } else if cvv.count < 3 {
            errorMessage = .validCVV
        } else if Int(cvv) == 0 {
            errorMessage = .validCVV
        } else if hostVc?.isSavedCardForFutureSelected == false {
            errorMessage = .selectSaveCardOption
        }
        
        // MARK: - Show Alert
        if errorMessage != .none {
            hostVc?.showAlert(msg: errorMessage.rawValue)
        }
        hostVc?.view.endEditing(true)
        return errorMessage == .none
    }
    
    private func isValidExpiryDate(_ date: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let expiryDate = formatter.date(from: date) else {
            return false
        }
        return expiryDate >= Date()
    }
}
