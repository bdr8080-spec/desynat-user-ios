//
//  EnterCardsDetailsViewModel.swift
//  DesynatUser
//
//  Created by fluper on 06/12/25.
//

import Foundation

class EnterCardsDetailsViewModel {
  
  private var hostVC: EnterCardsDetailsViewController
  
  init(hostVC: EnterCardsDetailsViewController) {
    self.hostVC = hostVC
  }
  
  func validFields() -> Bool {
    var errorMessage: AlertConstant = .none
    var enteredAmount: String = ""
    
    if hostVC.selectedIndex == 2 {
      enteredAmount = hostVC.enterAmountTF.text ?? ""
    } else {
      enteredAmount = hostVC.amountArray[hostVC.selectedIndex ?? 0]
    }
    
    if errorMessage == .none {
      if enteredAmount.isEmpty {
        if hostVC.selectedIndex == 2 {
          errorMessage = .EnterAmount
        } else {
          errorMessage = .ChooseAmount
        }
      }
    }
    
    let recepientName = String.getString(hostVC.nameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if recepientName.isEmpty {
        errorMessage = .EnterRecepientName
      }
    }
    
    let recepientEmail = hostVC.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if errorMessage == .none {
      if recepientEmail.isEmpty {
        errorMessage = .EnterRecepientEmail
      } else if !recepientEmail.isValidEmail() {
        errorMessage = .EnterValidEmailAddress
      }
    }
    
    let fromName = String.getString(hostVC.fromNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if fromName.isEmpty {
        errorMessage = .EnterFromName
      }
    }
    
    let wishMessage = String.getString(hostVC.wishMessageTextView.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if wishMessage.isEmpty {
        errorMessage = .EnterWishMessage
      }
    }
    
    let noteMessage = String.getString(hostVC.noteTextView.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if errorMessage == .none {
      if noteMessage.isEmpty {
        errorMessage = .EnterNote
      }
    }
    
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
    }
    
    hostVC.view.endEditing(true)
    return errorMessage == .none
  }
//  {
//      "gift_card_id":"3",
//      "amount":100,
//      "receiver_name":"manoj chauhan",
//      "receiver_email":"manojchauhan1328989@gmail.com",
//      "sender_name":"komal",
//      "sender_email":"komal123@gmail.com",
//      "wish_message":"This is Test Gift Card",
//      "notes":"This is Test gift card Note"
//
//
//  }
//  func payForAddingCard() {
//          var params: [String: Any] = [
//            "gift_card_id": hostVC.selectedOccassionId,
//            "receiver_name": hostVC.nameTextField.text ?? "",
//            "receiver_email": hostVC.emailTextField.text ?? ""
//          
//          ]
//    if hostVC.selectedIndex == 2 {
//      params["amount"] = hostVC.enterAmountTF.text ?? ""
//    } else {
//      params["amount"] = hostVC.amountArray[hostVC.selectedIndex ?? 0
//    }
////      WebService.sharedInstance.loginUserService(withParams: params) { (response) in
////          UserDefaults.standard.setValue("Yes", forKey:"isLogin")
////          UserDefaults.standard.setValue("false", forKey:"isGuestLogin")
////          kSharedSceneDelegate.navigateToUserHomeVc()
////      }
//  }
}
