//
//  PlaceOrderPaymentMethodsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PlaceOrderPaymentMethodsTableViewCell: UITableViewCell, MFPaymentDelegate {
    
    func didInvoiceCreated(invoiceId: String) {
        print("")
    }
    
    @IBOutlet weak var viewApple: UIView!
    @IBOutlet weak var paymentButtonView: UIView!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewPayment: MFPaymentCardView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var paymentMethdImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardTableViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var addNewCardView: CustomView!
    @IBOutlet weak var checkboxStackView: UIStackView!
    @IBOutlet weak var selecetdPaymentMethodButtonOutlet: UIButton!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionCheckbox: UIButton!
    @IBOutlet weak var cardsTableView: UITableView! {
        didSet {
            cardsTableView.registerCellFromNib(cellID: "CreditCardTableViewCell")
            cardsTableView.rowHeight = 60
            cardsTableView.separatorStyle = .none
        }
    }
    var totalAmountToPay: Int = 0
    let applePayButton = MFApplePayButton()
    var selectedCardID: Int = 0
    var isDefaultSelected: Bool = false
    var cardsCount: Int = 0 {
        didSet { updateCardsTableViewHeight() }
    }
    var addCardDidTapped:(() -> Void)?
    var onSetAsDefaultTapped: (() -> Void)?
    var onPaymentCompletion: ((MFPaymentStatusResponse?, String?, Error?) -> Void)?
    weak var delegate: PlaceOrderPaymentMethodsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        MFSettings.shared.delegate = self
    }
    
    // MARK: - Update nested table height
    func updateCardsTableViewHeight() {
        DispatchQueue.main.async {
            self.cardsTableView.layoutIfNeeded()
            self.cardTableViewHeightConstarint.constant = self.cardsTableView.contentSize.height
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func addCardDidTapped(_ sender: Any) {
        addCardDidTapped?()
    }
    
    @IBAction func setAsDefaultDidTapped(_ sender: Any) {
        isDefaultSelected.toggle()
        let imageName = isDefaultSelected ? "selectedFilterCheckBox" : "unslectedCheckbox"
        descriptionCheckbox.setImage(UIImage(named: imageName), for: .normal)
        onSetAsDefaultTapped?()
    }
    
    // MARK: Fix stackView layout
    func fixStackViewLayout() {
        descriptionStackView.layoutIfNeeded()
        checkboxStackView.layoutIfNeeded()
        addNewCardView.layoutIfNeeded()
        cardsTableView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
}

// MARK: - TABLE VIEW METHODS
extension PlaceOrderPaymentMethodsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
        cell.selectedRadioImageView.image = (indexPath.row == selectedCardID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCardID = indexPath.row
        cardsTableView.reloadData()
    }
}

extension PlaceOrderPaymentMethodsTableViewCell {
    func cardPay() {
        let configure = MFCardConfigureBuilder.default
        configure.setPlaceholder(MFCardPlaceholder(cardHolderNamePlaceholder: "Name", cardNumberPlaceholder: "Number", expiryDatePlaceholder: "MM / YY", cvvPlaceholder: "CVV"))
        configure.setLabel(MFCardLabel(cardHolderNameLabel: "Card holder name", cardNumberLabel: "Card number", expiryDateLabel: "MM / YY", cvvLabel: "CVV", showLabels: true, fontWeight: .normal))
        let theme = MFCardTheme(inputColor: .black, labelColor: .black, errorColor: .red, borderColor: .black)
        theme.language = .english
        configure.setTheme(theme)
        configure.setCardInput(MFCardInput(inputHeight: 32, inputMargin: 15))
        configure.setFontSize(15)
        configure.setBorderWidth(1)
        configure.setBorderRadius(8)
        configure.setHideCardIcon(false)
        configure.setFontFamily(.timesNewRoman)
        configure.setBoxShadow(MFBoxShadow(hOffset: 0, vOffset: 0, blur: 0, spread: 0, color: .gray))
        viewPayment.configure = configure.build()
        cardPayInitiation()
    }
    
    func cardPayInitiation() {
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
            switch response {
            case .success(let session):
                self?.viewPayment.load(initiateSession: session) { bin in
                    print("bin", bin)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func payWithSelectedCard(invoiceValue: Decimal,
                             orderId: String,
                             //                           supplierId: String?,
                             completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
        //    guard let supplierIDString = supplierId,
        //          let supplierCode = Int(supplierIDString) else {
        //      completion(nil, nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid supplier ID."]))
        //      return
        //    }
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        request.customerReference = orderId
        //    let supplier = MFSupplier(supplierCode: supplierCode, invoiceShare: invoiceValue)
        //    request.suppliers = [supplier]
        viewPayment.pay(request, .english) { [self] result, invoiceId in
            switch result {
            case .success(let paymentStatus):
                completion(paymentStatus, invoiceId, nil)
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentID = paymentStatus.invoiceTransactions?.first?.paymentID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "Card"
                self.delegate?.paymentTransactionDetails = (transactionID, paymentID, invoiceId ?? "", paymentGateway)
                delegate?.paymentCompleted = true
            case .failure(let error):
                completion(nil, invoiceId, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
            }
        }
    }
    
    
}

extension PlaceOrderPaymentMethodsTableViewCell{
    
    func setupApplePayButton() {
        paymentButtonView.subviews.forEach { $0.removeFromSuperview() }
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
    
    func startApplePayOnButtonTap(
        invoiceValue: Decimal,
        orderID: String,
        completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void
    ) {
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        request.customerName = "Customer Name"
        request.customerReference = orderID
        request.userDefinedField = "iOS-Order-\(orderID)"
        request.displayCurrencyIso = .kuwait_KWD // or .uAE_AED etc.
        
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let session):
                self.applePayButton.load(
                    session,
                    request,
                    .english,
                    startLoading: {
                        print("Apple Pay: Starting...")
                    },
                    completion: { [weak self] (response: Result<MFPaymentStatusResponse, MFFailResponse>, invoiceId: String?) in
                        
                        switch response {
                        case .success(let paymentStatusResponse):
                            // Success: Payment completed
                            let transactionID = paymentStatusResponse.invoiceTransactions?.first?.transactionID ?? ""
                            let paymentID = paymentStatusResponse.invoiceTransactions?.first?.paymentID ?? ""
                            let gateway = paymentStatusResponse.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
                            
                            // Notify delegate (VC)
                            self?.delegate?.handlePaymentCompletion(
                                transactionID: transactionID,
                                paymentId: paymentID,
                                invoiceId: invoiceId ?? "",
                                gateway: gateway
                            )
                            
                            completion(paymentStatusResponse, invoiceId, nil)
                            
                        case .failure(let failResponse):
                            let errorMessage = failResponse.errorDescription
                            print("Apple Pay Failed: \(errorMessage)")
                            self?.delegate?.didReceivePaymentError(errorMessage)
                            completion(nil, invoiceId, NSError(domain: "ApplePay", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                        }
                    }
                )
                
            case .failure(let error):
                let message = error.localizedDescription
                self.delegate?.didReceivePaymentError("Failed to start Apple Pay: \(message)")
                completion(nil, nil, error)
            }
        }
    }
    
    func creditDebitCardPayment(invoiceValue: Decimal,
                                orderId: String,
                                completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 8)
        request.customerReference = orderId
        request.displayCurrencyIso = .uAE_AED
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
            switch result {
            case .success(let paymentStatus):
                completion(paymentStatus, invoiceId, nil)
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentID = paymentStatus.invoiceTransactions?.first?.paymentID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay"
                self.delegate?.paymentTransactionDetails = (transactionID, paymentID, invoiceId ?? "", paymentGateway)
                self.delegate?.paymentCompleted = true
            case .failure(let error):
                completion(nil, invoiceId,
                           NSError(domain: "", code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
            }
        }
    }
    
    func payByKNET(invoiceValue: Decimal,
                   orderId: String,
                   completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 1)
        request.customerReference = orderId
        request.displayCurrencyIso = .kuwait_KWD
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
            switch result {
            case .success(let paymentStatus):
                completion(paymentStatus, invoiceId, nil)
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentID = paymentStatus.invoiceTransactions?.first?.paymentID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "KNET"
                self.delegate?.paymentTransactionDetails = (transactionID, paymentID, invoiceId ?? "", paymentGateway)
                self.delegate?.paymentCompleted = true
            case .failure(let error):
                completion(nil, invoiceId,
                           NSError(domain: "", code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
            }
        }
    }
    
    func payByVisaPay(invoiceValue: Decimal,
                      orderId: String,
                      completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
        // Payment method ID 2 for VisaPay
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 2)
        request.customerReference = orderId
        request.displayCurrencyIso = .uAE_AED
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
            switch result {
            case .success(let paymentStatus):
                completion(paymentStatus, invoiceId, nil)
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay"
                self.delegate?.paymentTransactionDetails = (transactionID, paymentID, invoiceId ?? "", paymentGateway)
                self.delegate?.paymentCompleted = true
            case .failure(let error):
                completion(nil, invoiceId,
                           NSError(domain: "", code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
            }
        }
    }
    
}

protocol PlaceOrderPaymentMethodsCellDelegate: AnyObject {
    var paymentTransactionDetails: (transactionID: String, paymentId: String, invoiceId: String, paymentGateway: String)? { get set }
    var paymentCompleted: Bool { get set }
    func didReceivePaymentError(_ message: String)
    func handlePaymentCompletion(transactionID: String, paymentId: String, invoiceId: String, gateway: String)
}

