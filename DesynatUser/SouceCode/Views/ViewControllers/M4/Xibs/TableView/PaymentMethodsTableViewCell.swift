//
//  PaymentMethodsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PaymentMethodsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var viewApple: UIView!
  @IBOutlet weak var paymentButtonView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var radioButonOutlet: UIButton!
  @IBOutlet weak var paymentMethodImageView: UIImageView!
  @IBOutlet weak var descriptionLable: UILabel!
  
  var totalAmountToPay: Int = 0
  let applePayButton = MFApplePayButton()
  weak var delegate: PlaceOrderPaymentMethodsCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configData(data: PaymentMethod) {
    titleLabel.text = data.paymentMethodTitle.localiz()
    paymentMethodImageView.image = UIImage(named: data.paymentMethodImage)
    descriptionLable.isHidden = data.showDescription
    descriptionLable.text = data.description
  }
  
}

extension PaymentMethodsTableViewCell{
  
  func setupApplePay() {
    paymentButtonView.addSubview(applePayButton)
    applePayButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      applePayButton.leadingAnchor.constraint(equalTo: paymentButtonView.leadingAnchor),
      applePayButton.trailingAnchor.constraint(equalTo: paymentButtonView.trailingAnchor),
      applePayButton.topAnchor.constraint(equalTo: paymentButtonView.topAnchor),
      applePayButton.bottomAnchor.constraint(equalTo: paymentButtonView.bottomAnchor),
      applePayButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  func startApplePaySession() {
    let invoiceValue = Decimal(totalAmountToPay)
    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
    request.displayCurrencyIso = .uAE_AED
    request.customerName = "Customer"
    request.userDefinedField = "ORDER-45794947574tr"
    MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
      guard let self = self else { return }
      switch response {
      case .success(let session):
        print("Session initiated for Apple Pay")
        self.applePayButton.load(session, request, .english,
                                 startLoading: {
          print("Starting Apple Pay...")
        },
                                 completion: { response, invoiceId in
          switch response {
          case .success(let executeResponse):
            print("Apple Pay success: Invoice \(invoiceId ?? "N/A")")
            let transactionID = executeResponse.invoiceTransactions?.first?.transactionID ?? ""
            let gateway = executeResponse.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
            self.delegate?.paymentTransactionDetails = (transactionID, invoiceId ?? "", gateway)
            self.delegate?.paymentCompleted = true
            self.delegate?.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: gateway)
          case .failure(let error):
            print("Apple Pay failed: \(error.errorDescription)")
            self.delegate?.didReceivePaymentError("Apple Pay failed: \(error.errorDescription)")
          }
        })
      case .failure(let error):
        print("Failed to initiate session: \(error.localizedDescription)")
        self.delegate?.didReceivePaymentError("Failed to start Apple Pay session")
      }
    }
  }
  
  func payByKNET(invoiceValue: Decimal,
                 orderId: String,
                 supplierId: Int,
                 completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 1)
    request.customerReference = orderId
    request.displayCurrencyIso = .kuwait_KWD
    let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: invoiceValue)
    request.suppliers = [supplier]
    
    MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
      switch result {
      case .success(let paymentStatus):
        completion(paymentStatus, invoiceId, nil)
        
        let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
        let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "KNET"
        
        self.delegate?.paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
        self.delegate?.paymentCompleted = true
        self.delegate?.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: paymentGateway)
      case .failure(let error):
        completion(nil, invoiceId,
                   NSError(domain: "", code: 0,
                           userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
      }
    }
  }
  
  func payByVisaPay(invoiceValue: Decimal,
                    orderId: String,
                    supplierId: Int,
                    completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
    
    // Payment method ID 2 for VisaPay
    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 2)
    request.customerReference = orderId
    
    let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: invoiceValue)
    request.suppliers = [supplier]
    request.displayCurrencyIso = .uAE_AED // Or your currency
    
    MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
      switch result {
      case .success(let paymentStatus):
        completion(paymentStatus, invoiceId, nil)
        
        let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
        let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay"
        
        self.delegate?.paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
        self.delegate?.paymentCompleted = true
        self.delegate?.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: paymentGateway)
      case .failure(let error):
        completion(nil, invoiceId,
                   NSError(domain: "", code: 0,
                           userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
      }
    }
  }
  
}
