//
//  PlaceOrderPaymentMethodsViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class PlaceOrderPaymentMethodsViewModel {
  
  private var hostVC: PlaceOrderPaymentMethodsViewController
  var paymentMethods: [PaymentMethodForPlaceOrder] = [PaymentMethodForPlaceOrder(paymentMethodImage: "paymentMethods", paymentMethodTitle: "Pay by KNET", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "applePay", paymentMethodTitle: "Apple Pay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "vispay", paymentMethodTitle: "Visapay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "samsungPay", paymentMethodTitle: "Samsung Pay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "inAppWallet", paymentMethodTitle: "Credit/ Debit Card", showDescription: true, description: "Set as default payment method"),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "inAppWallet", paymentMethodTitle: "In -App Wallet", showDescription: false, description: "Available Balance : 349 KD"),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "cashOnDeliveryMethod", paymentMethodTitle: "Cash On Delivery", showDescription: true, description: "")]
  
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
    guard let selectedMethod = hostVC.selectedPaymentMethod else { return }
    let param: [String: Any] = ["order_id": orderID,
                                "payment_status": 1,
                                "Payment_method": selectedMethod.apiValue]
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

enum PaymentMethodType: String {
    case payByKNET = "Pay by KNET"
    case applePay = "Apple Pay"
    case visapay = "Visapay"
    case samsungPay = "Samsung Pay"
    case creditDebitCard = "Credit/ Debit Card"
    case inAppWallet = "In -App Wallet"
    case cashOnDelivery = "Cash On Delivery"
    
    // Map to API integer value
    var apiValue: Int {
        switch self {
        case .payByKNET, .applePay, .visapay, .samsungPay, .creditDebitCard:
            return 1
        case .inAppWallet:
            return 2
        case .cashOnDelivery:
            return 3
        }
    }
}
