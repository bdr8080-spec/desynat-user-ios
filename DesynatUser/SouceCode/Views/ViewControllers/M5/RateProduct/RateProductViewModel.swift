//
//  RateProductViewModel.swift
//  DesynatUser
//
//  Created by fluper on 24/12/25.
//

import Foundation

class RateProductOrderViewModel {
  
  private var hostVC: RateProductOrderViewController?
  
  init(hostVC: RateProductOrderViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func addRatingToRequest(param: [String: Any]) {
      WebService.sharedInstance.addRatingToOrderSercie(param: param) { _ in
          DispatchQueue.main.async {
              self.hostVC?.showSuccess()
          }
      }
  }

  
  func validateInputs() -> Bool {

    if hostVC?.productRatingView.rating == 0 {
      hostVC?.showAlert(msg: "Please rate the product.")
              return false
          }

    if hostVC?.productReviewTF.text?.trimmed().isEmpty == true {
            hostVC?.showAlert(msg: "Please write a product review.")
              return false
          }

    if hostVC?.storeRatingView.rating == 0 {
            hostVC?.showAlert(msg: "Please rate the store.")
              return false
          }

    if hostVC?.storeReviewTF.text?.trimmed().isEmpty == true {
            hostVC?.showAlert(msg: "Please write a store review.")
              return false
          }

          return true
      }
  
}
