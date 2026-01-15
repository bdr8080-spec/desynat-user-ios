//
//  PlaceOrderPaymentMethodsViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class PlaceOrderPaymentMethodsViewModel {
  
  var walletAmount: Double?
  private var hostVC: PlaceOrderPaymentMethodsViewController
  var paymentMethods: [PaymentMethodForPlaceOrder] = [PaymentMethodForPlaceOrder(paymentMethodImage: "paymentMethods", paymentMethodTitle: "Pay by KNET", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "applePay", paymentMethodTitle: "Apple Pay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "vispay", paymentMethodTitle: "Visapay", showDescription: true, description: ""),
                                                      //PaymentMethodForPlaceOrder(paymentMethodImage: "samsungPay", paymentMethodTitle: "Samsung Pay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "inAppWallet", paymentMethodTitle: "Credit/ Debit Card", showDescription: true, description: "Set as default payment method"),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "inAppWallet", paymentMethodTitle: "In -App Wallet", showDescription: false, description: "Available Balance : 0 KD"),
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
  
  func placeCustomOrderApi(param: [String: Any]) {
    WebService.sharedInstance.createCustomOrderRequest(param: param) { response in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        completeOrderApi(orderID: response.orderID ?? "")
      }
    }
  }
  
  func getWalletAmountApi() {
    WebService.sharedInstance.getWalletAmount() { response in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.walletAmount = response.balance
        self.updateWalletDescription(amount: response.balance ?? 0)
        self.hostVC.paymnetTableView.reloadData()
      }
    }
  }
  
  func updateWalletDescription(amount: Double) {
      let formatted = formatAmount(amount)
      if let index = paymentMethods.firstIndex(where: { $0.paymentMethodTitle == PaymentMethodType.inAppWallet.rawValue }) {
          paymentMethods[index].description = "Available Balance : \(formatted) KD"
      }
  }
  
  func completeOrderApi(orderID: String) {
    guard let selectedMethod = hostVC.selectedPaymentMethod else { return }
    let param: [String: Any] = ["order_id": orderID,
                                "payment_status": 1]
//                                "Payment_method": selectedMethod.apiValue]
    WebService.sharedInstance.completeOrderApi(param: param) { response in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        let nextVC = OrderPlacedViewController.instantiate(fromAppStoryboard: .MyBag)
        nextVC.orderId = response.orderID
          nextVC.selectedMethod = selectedMethod.apiValue
          nextVC.isCustomOrderSeleced = hostVC.comingForCustomeOrderPlace
        self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
      }
    }
  }

  
  private func formatAmount(_ amount: Double) -> String {
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = false   // 🚫 No commas
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 2
      formatter.numberStyle = .decimal
      return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
  }

}

enum PaymentMethodType: String {
  case payByKNET = "Pay by KNET"
  case applePay = "Apple Pay"
  case visapay = "Visapay"
  //    case samsungPay = "Samsung Pay"
  case creditDebitCard = "Credit/ Debit Card"
  case inAppWallet = "In -App Wallet"
  case cashOnDelivery = "Cash On Delivery"
  
  // Map to API integer value
  var apiValue: Int {
    switch self {
    case .payByKNET, .applePay, .visapay, .creditDebitCard://, samsungPay:
      return 1
    case .inAppWallet:
      return 2
    case .cashOnDelivery:
      return 3
    }
  }
}
