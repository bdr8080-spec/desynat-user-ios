//
//  OrderPlacedViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class OrderPlacedViewModel {
  
  private var hostVC: OrderPlacedViewController
  
  init(hostVC: OrderPlacedViewController) {
    self.hostVC = hostVC
  }
  
  func getOrderSummary() {
    let param: [String: Any] = ["order_id": hostVC.orderId ?? ""]
      WebService.sharedInstance.getOrderSummary(param: param) { response in
          DispatchQueue.main.async { [weak self] in
              guard let self else { return }
            hostVC.configData(data: response)
          }
      }
  }
}
