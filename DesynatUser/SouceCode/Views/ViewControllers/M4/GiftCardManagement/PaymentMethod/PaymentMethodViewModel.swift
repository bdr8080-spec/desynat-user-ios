//
//  PaymentMethodViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class PaymentMethodViewModel {
    
    var walletAmount: Double?
    private var hostVC: PaymentMethodViewController
    var paymentMethods: [PaymentMethod] = [PaymentMethod(paymentMethodImage: "paymentMethods", paymentMethodTitle: "Pay by KNET", showDescription: true, description: ""),
                                           PaymentMethod(paymentMethodImage: "applePay", paymentMethodTitle: "Apple Pay", showDescription: true, description: ""),
                                           PaymentMethod(paymentMethodImage: "vispay", paymentMethodTitle: "Visapay", showDescription: true, description: ""),
                                           // PaymentMethod(paymentMethodImage: "samsungPay", paymentMethodTitle: "Samsung Pay", showDescription: true),
                                           PaymentMethod(paymentMethodImage: "inAppWallet", paymentMethodTitle: "In -App Wallet", showDescription: false, description: "")]
    
    init(hostVC: PaymentMethodViewController) {
        self.hostVC = hostVC
    }
    
    func payNowRequest(transactionId: String, paymentId: Int) {
        switch hostVC.comingFrom {
        case .fromCardDetails:
            payForAddingCard(transactionId: transactionId, paymentId: paymentId)
        case .fromWalletMeonyAdd:
            payForAddingMoneyToWallet(transactionId: transactionId, paymentId: paymentId)
        }
    }
    
    private func payForAddingCard(transactionId: String, paymentId: Int) {
        let params: [String: Any] = [
            "order_id": hostVC.orderId,
            "payment_status": "1",
            "Payment_method": paymentId,
            "transaction_id": transactionId
        ]
        
        WebService.sharedInstance.paymentForGiftCardsApi(param: params) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let successVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                successVC.comingReason = .giftCardPurchased
                
                successVC.callBackDismiss = { [weak self] in
                    successVC.dismiss(animated: true) {
                        self?.hostVC.navigationController?.popToViewController(ofType: GiftCardsListViewController.self)
                    }
                }
                
                // Present success VC modally, no return to PaymentMethodViewController
                self.hostVC.present(successVC, animated: true)
            }
        }
    }
    
    private func payForAddingMoneyToWallet(transactionId: String, paymentId: Int) {
        let params: [String: Any] = [
            "amount": hostVC.payAmount,
            "payment_method": "1"]
        
        WebService.sharedInstance.paymentForAddMoneyInWalletApi(param: params) { [weak self] response in
            self?.completePaymentForAddingMoneyToWallet(transactionId: transactionId, uniqueID: response.uniqueID ?? "")
        }
    }
    
    private func completePaymentForAddingMoneyToWallet(transactionId: String, uniqueID: String) {
        let params: [String: Any] = [
            "unique_id": uniqueID,
            "transaction_id": transactionId,
            "payment_status": "1"]
        
        WebService.sharedInstance.completePaymentForAddMoneyInWalletApi(param: params) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let successVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                successVC.comingReason = .amountAddeddToWallet
                
                successVC.callBackDismiss = { [weak self] in
                    successVC.dismiss(animated: true) {
                        self?.hostVC.navigationController?.popToViewController(ofType: WalletMoneyListViewController.self)
                    }
                }
                
                // Present success VC modally, no return to PaymentMethodViewController
                self.hostVC.present(successVC, animated: true)
            }
        }
    }
    
    func getWalletAmountApi() {
        WebService.sharedInstance.getWalletAmount() { response in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.walletAmount = response.balance
                self.updateWalletDescription(amount: response.balance ?? 0)
                self.hostVC.paymentMethodsTableView.reloadData()
            }
        }
    }
    
    func updateWalletDescription(amount: Double) {
        let formatted = formatAmount(amount)
        if let index = paymentMethods.firstIndex(where: { $0.paymentMethodTitle == PaymentMethodType.inAppWallet.rawValue }) {
            paymentMethods[index].description = "\("Available Balance :".localiz()) \(CommonUtils.formatPriceStringInput(formatted))"
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
