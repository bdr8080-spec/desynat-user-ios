//
//  PaymentMethodViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PaymentMethodViewController: UIViewController, PlaceOrderPaymentMethodsCellDelegate {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var buttontitleLabel: UILabel!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewPayment: MFPaymentCardView!
    @IBOutlet weak var cardSelectionImageView: UIImageView!
    @IBOutlet weak var paymnetTableviewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardsTableiew: UITableView! {
        didSet {
            cardsTableiew.registerCellFromNib(cellID: "CreditCardTableViewCell")
        }
    }
    @IBOutlet weak var paymentMethodsTableView: UITableView! {
        didSet {
            paymentMethodsTableView.registerCellFromNib(cellID: "PaymentMethodsTableViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private var currentAlert: UIAlertController?
    var getToastMessage: String = ""
    var paymentTransactionDetails: (transactionID: String, invoiceId: String, paymentGateway: String)?
    var paymentCompleted: Bool = false
    var payAmount: Double = 0.0
    var orderId: String = ""
    var isCardIsSlecteed: Bool = false
    var selectedPaymentMethodID: Int? = nil
    var comingFrom: ComingReason = .fromCardDetails
    var displayPaymentMethods: [PaymentMethod] {
        if comingFrom == .fromWalletMeonyAdd {
            return viewModel.paymentMethods.filter {
                $0.paymentMethodTitle != "In - App Wallet"
            }
        }
        return viewModel.paymentMethods
    }
    private lazy var viewModel = PaymentMethodViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCreditCard.isHidden = true
        initaislUISetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let alert = currentAlert {
            alert.dismiss(animated: false)
            currentAlert = nil
        }
        viewModel.getWalletAmountApi()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardsTableViewHeightConstraint.constant = cardsTableiew.contentSize.height
        paymnetTableviewHieghtConstraint.constant = paymentMethodsTableView.contentSize.height
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedDidTapped(_ sender: Any) {
        guard selectedPaymentMethodID != nil || isCardIsSlecteed else {
            showAlertAtPayment(msg: "Please select a payment option".localiz())
            return
        }
        
        if comingFrom == .fromWalletMeonyAdd, isCardIsSlecteed {
            startVisaPayPayment()
            return
        }
        
        // Saved Card flow
        if isCardIsSlecteed {
            guard paymentCompleted, let details = paymentTransactionDetails else {
                showAlertAtPayment(msg: "Please complete card payment".localiz())
                return
            }
            viewModel.payNowRequest(transactionId: details.transactionID, paymentId: 1)
            return
        }
        
        guard let index = selectedPaymentMethodID else { return }
        let selectedMethod = displayPaymentMethods[index]
        
        // In-App Wallet (ONLY fromCardDetails)
        if selectedMethod.paymentMethodTitle == "In -App Wallet" {
            let walletBalance = viewModel.walletAmount ?? 0
            if walletBalance < payAmount {
                showToast(msg: "Insufficient wallet balance".localiz())
                return
            }
            viewModel.payNowRequest(transactionId: "WALLET_TXN", paymentId: 2)
            return
        }
        
        // Wallet Add Money → start SDK ONLY here
        if comingFrom == .fromWalletMeonyAdd {
            switch selectedMethod.paymentMethodTitle {
                
            case "Pay by KNET":
                startKNETPayment()
                
            case "Visapay":
                startVisaPayPayment()
                
            case "Apple Pay":
                startApplePay()
                
            default:
                break
            }
            return
        }
        
        // Normal cardDetails flow (already paid)
        if paymentCompleted, let details = paymentTransactionDetails {
            viewModel.payNowRequest(transactionId: details.transactionID, paymentId: 1)
        } else {
            showAlertAtPayment(msg: "Payment not completed".localiz())
        }
    }
    
    @IBAction func cardButtonAction(_ sender: Any) {
        cardSelectionImageView.image = UIImage(named: "radioSelected")
        isCardIsSlecteed = true
        selectedPaymentMethodID = nil
        
        // Reload payment methods table to unselect any previously selected method
        paymentMethodsTableView.reloadData()
        if comingFrom == .fromWalletMeonyAdd {
            return
        }
        startVisaPayPayment()
    }
    
    //MARK: Function's declaration
    func initaislUISetup() {
        switch comingFrom {
        case .fromCardDetails:
            buttontitleLabel.text = "Proceed".localiz()
        case .fromWalletMeonyAdd:
            buttontitleLabel.text = "Confirm & Add Money".localiz()
        }
    }
    
    private func showAlertAtPayment(msg: String) {
        // Dismiss any existing alert first
        if let alert = currentAlert {
            alert.dismiss(animated: false)
            currentAlert = nil
        }
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))
        
        currentAlert = alert
        present(alert, animated: true)
    }
    
    func paymentDoneWithCard() {
        let invoiceValue = Decimal(payAmount)
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        request.customerReference = self.orderId
//        let supplierId = Int.random(in: 1000...9999)
//        let supplier = MFSupplier(
//            supplierCode: supplierId, invoiceShare: invoiceValue
//        )
//        request.suppliers = [supplier]
        
        viewPayment.pay(request, .english) { [weak self] response, invoiceId in
            guard let self = self else { return }
            
            switch response {
            case .success(let paymentStatus):
//                print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "card"
                paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
                paymentCompleted = true
                self.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: paymentGateway)
                
                //        viewModel.payForAddingCard(transactionId: transactionID)
            case .failure(let error):
//                print("Payment Error: \(error.errorDescription)")
                self.showAlertAtPayment(msg: "\("Payment Failed:".localiz()) \(error.errorDescription)")
            }
        }
    }
    
    func didReceivePaymentError(_ message: String) {
        showAlertAtPayment(msg: message)
    }
    
    func handlePaymentCompletion(transactionID: String, invoiceId: String, gateway: String) {
        // Kill any alert immediately
        if let alert = currentAlert {
            alert.dismiss(animated: false)
            currentAlert = nil
        }
        
        paymentTransactionDetails = (transactionID, invoiceId, gateway)
        paymentCompleted = true
        
        // Automatically call API for all non-wallet payments
        if selectedPaymentMethodID != 3 { // 3 = Wallet
            viewModel.payNowRequest(transactionId: transactionID, paymentId: 1)
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cardsTableiew {
            return 2
        }
        return displayPaymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cardsTableiew {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsTableViewCell", for: indexPath) as! PaymentMethodsTableViewCell
        let data = displayPaymentMethods[indexPath.row]
        cell.delegate = self
        cell.configData(data: data)
        cell.viewApple.isHidden = true
        
        // Just update radio button – NO payment call here!
        cell.radioButonOutlet.setImage(
            (indexPath.row == selectedPaymentMethodID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
            for: .normal
        )
        
        if indexPath.row == 1 { // Apple Pay row
            if selectedPaymentMethodID == 1 {
                cell.viewApple.isHidden = false
                cell.setupApplePay()
                cell.startApplePaySession()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cardsTableiew { return }
        
        // Reset card selection
        isCardIsSlecteed = false
        cardSelectionImageView.image = UIImage(named: "radioUnselected")
        viewCreditCard.isHidden = true
        
        selectedPaymentMethodID = indexPath.row
        paymentMethodsTableView.reloadData()
        
        let selectedMethod = displayPaymentMethods[indexPath.row]
        
        // 🚨 Wallet Add Money → NEVER start SDK here
        if comingFrom == .fromWalletMeonyAdd {
            return
        }
        
        // ✅ fromCardDetails → auto start EXCEPT wallet
        switch selectedMethod.paymentMethodTitle {
            
        case "Pay by KNET":
            startKNETPayment()
            
        case "Visapay":
            startVisaPayPayment()
            
        case "Apple Pay":
            startApplePay()
            
        case "In -App Wallet":
            // Wallet must wait for Proceed button
            break
            
        default:
            break
        }
    }
}

extension PaymentMethodViewController {
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
    
    func startVisaPayPayment() {
//        let supplierId = Int.random(in: 1000...9999)
        let amountDecimal = Decimal(string: String(format: "%.3f", payAmount)) ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: amountDecimal, paymentMethod: 2)
        
        request.customerReference = orderId
        request.displayCurrencyIso = .kuwait_KWD
        
//        let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: Decimal(payAmount))
//        request.suppliers = [supplier]
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] result, invoiceId in
            guard let self = self else { return }
            switch result {
            case .success(let paymentStatus):
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let gateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay"
                
                self.paymentTransactionDetails = (transactionID, invoiceId ?? "", gateway)
                self.paymentCompleted = true
                
                // Automatically complete backend registration
                self.viewModel.payNowRequest(transactionId: transactionID, paymentId: 1)
            case .failure(_):
                showAlertAtPayment(msg: "Payment not completed".localiz())
            }
        }
    }
    
    func startKNETPayment() {
//        let supplierId = Int.random(in: 1000...9999)
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(payAmount), paymentMethod: 1)
        request.customerReference = orderId
        request.displayCurrencyIso = .kuwait_KWD
        
//        let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: Decimal(payAmount))
//        request.suppliers = [supplier]
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] result, invoiceId in
            guard let self = self else { return }
            switch result {
            case .success(let paymentStatus):
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let gateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "KNET"
                
                self.paymentTransactionDetails = (transactionID, invoiceId ?? "", gateway)
                self.paymentCompleted = true
                self.viewModel.payNowRequest(transactionId: transactionID, paymentId: 1)
                //              self.presentSuccessScreen()
            case .failure(_):
                showAlertAtPayment(msg: "Payment not completed".localiz())
            }
        }
    }
    
    func startApplePay() {
        // Show loading indicator
        
        // Find the Apple Pay cell (row 1)
        guard let indexPath = IndexPath(row: 1, section: 0) as? IndexPath,
              let cell = paymentMethodsTableView.cellForRow(at: indexPath) as? PaymentMethodsTableViewCell else {
            showToast(msg: "Apple Pay not available".localiz())
            return
        }
        
        // Show Apple Pay button container
        cell.viewApple.isHidden = false
        cell.setupApplePay() // Add button to view
        
        // Force layout update so button appears immediately
        cell.layoutIfNeeded()
        paymentMethodsTableView.layoutIfNeeded()
        
        let invoiceValue = Decimal(payAmount)
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        request.displayCurrencyIso = .kuwait_KWD
        request.customerName = "Customer"
        request.customerReference = orderId
        request.userDefinedField = "ORDER-\(orderId)"
        
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response {
                case .success(let session):
                    print("Apple Pay session initiated successfully")
                    // Load the button with session
                    cell.applePayButton.load(session, request, .english,
                                             startLoading: {
                        print("Apple Pay button loading...")
                    },
                                             completion: { result, invoiceId in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let executeResponse):
//                                print("Apple Pay payment successful")
                                let transactionID = executeResponse.invoiceTransactions?.first?.transactionID ?? ""
                                let gateway = executeResponse.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
                                
                                self.paymentTransactionDetails = (transactionID, invoiceId ?? "", gateway)
                                self.paymentCompleted = true
                                
                                // Complete backend registration & show success
                                self.viewModel.payNowRequest(transactionId: transactionID, paymentId: 1)
                                
                            case .failure(let error):
//                                print("Apple Pay payment failed: \(error.errorDescription)")
                                self.showToast(msg: "Apple Pay failed: \(error.errorDescription)")
                            }
                        }
                    })
                    
                case .failure(let error):
                    self.showToast(msg: "\("Unable to start Apple Pay:".localiz()) \(error.localizedDescription)")
                    cell.viewApple.isHidden = true // Hide button on failure
                }
            }
        }
    }
    
}

enum ComingReason {
    case fromCardDetails
    case fromWalletMeonyAdd
}
