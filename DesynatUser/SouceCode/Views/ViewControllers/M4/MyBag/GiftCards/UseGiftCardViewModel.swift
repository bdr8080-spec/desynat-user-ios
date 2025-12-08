//
//  UseGiftCardViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class UseGiftCardViewModel {
  
  private var hostVC: UseGiftCardsViewController
  
  init(hostVC: UseGiftCardsViewController) {
    self.hostVC = hostVC
  }
  
  func addGiftCardApi(cardNumber: String, giftCardPin: String) {
    let param: [String: Any] = ["giftCardNo": cardNumber,
                                "giftCardPin": giftCardPin]
      WebService.sharedInstance.addGiftCardApi(param: param) { response in
          DispatchQueue.main.async { [weak self] in
              guard let self else { return }
            self.hostVC.onRedeem?(cardNumber, giftCardPin, response)
            self.hostVC.navigationController?.popViewController(animated: true)
          }
      }
  }
}
