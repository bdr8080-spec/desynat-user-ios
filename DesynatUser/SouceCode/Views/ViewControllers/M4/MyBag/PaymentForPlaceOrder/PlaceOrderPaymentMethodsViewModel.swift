//
//  PlaceOrderPaymentMethodsViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class PlaceOrderPaymentMethodsViewModel {
  
  private var hostVC: PlaceOrderPaymentMethodsViewController
  
  init(hostVC: PlaceOrderPaymentMethodsViewController) {
    self.hostVC = hostVC
  }
  
  
  func placeOrderApi(param: [String: Any]) {
    WebService.sharedInstance.placeOrderApi(param: param) { response in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        completeOrderApi(orderID: response.orderID ?? "")
      }
    }
  }
  
  //  {
  //    "order_id": "Order47908981722743273",
  //  //   "Payment_method":"2"  //1 myfatoorah 2 wallet 3 Cod
  //    "payment_status":"1" // 0 pending 1 paid 2 cancel or reject 3 refund
  //  }
  
  func completeOrderApi(orderID: String) {
    var param: [String: Any] = ["order_id": orderID,
                                "payment_status": 1]
    
    guard let slecetedPaymentId = hostVC.slecetedPaymentId else { return }
    if slecetedPaymentId < 5 {
      param["Payment_method"] = 1
    } else if slecetedPaymentId == 5 {
      param["Payment_method"] = 2
    } else if slecetedPaymentId == 6{
      param["Payment_method"] = 3
    }
    WebService.sharedInstance.completeOrderApi(param: param) { response in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        let nextVC = OrderPlacedViewController.instantiate(fromAppStoryboard: .MyBag)
        nextVC.orderId = response.orderID
        self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
      }
    }
  }
}
