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
        request.displayCurrencyIso = .kuwait_KWD
        request.customerName = "Customer"
        request.userDefinedField = "ORDER-45794947574tr"
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let session):
                self.applePayButton.load(session, request, .english,
                                         startLoading: {
                    print("Starting Apple Pay...")
                },
                                         completion: { response, invoiceId in
                    switch response {
                    case .success(let executeResponse):
                        let transactionID = executeResponse.invoiceTransactions?.first?.transactionID ?? ""
                        let paymentID = executeResponse.invoiceTransactions?.first?.paymentID ?? ""
                        let gateway = executeResponse.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
                        self.delegate?.paymentTransactionDetails = (transactionID, paymentID, invoiceId ?? "", gateway)
                        self.delegate?.paymentCompleted = true
                        self.delegate?.handlePaymentCompletion(transactionID: transactionID, paymentId: paymentID, invoiceId: invoiceId ?? "", gateway: gateway)
                    case .failure(let error):
                        self.delegate?.didReceivePaymentError("Apple Pay failed: \(error.errorDescription)")
                    }
                })
            case .failure(let error):
                self.delegate?.didReceivePaymentError("Failed to start Apple Pay session")
            }
        }
    }
}
