//
//  RedeemGiftCardViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation

class RedeemGiftCardViewModel {
  
  private var hostVC: RedeemGiftCardViewController
  
  init(hostVC: RedeemGiftCardViewController) {
    self.hostVC = hostVC
  }

  func addGiftCardApi(cardNumber: String, giftCardPin: String) {
    let param: [String: Any] = ["giftCardNo": cardNumber,
                                "giftCardPin": giftCardPin]
      WebService.sharedInstance.redeemGiftCardWallet(param: param) { response in
          DispatchQueue.main.async { [weak self] in
              guard let self else { return }
              let successVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
              successVC.comingReason = .giftCardRedeemed
              successVC.callBackDismiss = { [weak self] in
                  successVC.dismiss(animated: true) {
                      self?.hostVC.navigationController?.popViewController(animated: true)
                  }
              }
              self.hostVC.present(successVC, animated: true)
          }
      }
  }
}
