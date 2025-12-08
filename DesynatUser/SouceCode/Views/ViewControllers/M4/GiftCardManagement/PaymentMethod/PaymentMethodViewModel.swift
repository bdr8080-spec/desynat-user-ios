//
//  PaymentMethodViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class PaymentMethodViewModel {
  
  private var hostVC: PaymentMethodViewController
  
  init(hostVC: PaymentMethodViewController) {
    self.hostVC = hostVC
  }
    
    func payForAddingCard() {
      let params: [String: Any] = [
        "order_id": hostVC.orderId,
        "payment_status": "1", // 1 paid, 2 cancel
        "transaction_id": "Trabs23456789"]
      WebService.sharedInstance.paymentForGiftCardsApi(param: params) { (response) in
        DispatchQueue.main.async { [weak self] in
          guard let self else { return }
          let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
          vc.comingReason = .giftCardPurchased
          vc.callBackDismiss = { [weak self] in
            self?.hostVC.navigationController?.popToViewController(ofType: GiftCardsListViewController.self)
          }
          self.hostVC.navigationController?.present(vc, animated: true)
        }
      }
    }
  }
