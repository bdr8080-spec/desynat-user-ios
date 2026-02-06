//
//  PlaceOrderPaymentMethodsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PlaceOrderPaymentMethodsViewController: UIViewController, PlaceOrderPaymentMethodsCellDelegate {
    
    func handlePaymentCompletion(transactionID: String, invoiceId: String, gateway: String) {
        self.paymentTransactionDetails = (transactionID, invoiceId, gateway)
        self.paymentCompleted = true
        proceedToPay()
    }
    
    @IBOutlet weak var giftCardAmountLabel: UILabel!
    @IBOutlet weak var giftCardLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var paymnetTableView: UITableView! {
        didSet {
            paymnetTableView.registerCellFromNib(cellID: "PlaceOrderPaymentMethodsTableViewCell")
        }
    }
    @IBOutlet weak var paymentTableHeightConstraint: NSLayoutConstraint!
    
    private lazy var viewModel = PlaceOrderPaymentMethodsViewModel(hostVC: self)
    var selectedPaymentMethod: PaymentMethodType?
    var giftCardDetails: UseGiftCardDataModel?
    var giftIsChecked: Bool = false
    var param: [String: Any] = [:]
    let applePayButton = MFApplePayButton()
    var paymentTransactionDetails: (transactionID: String, invoiceId: String, paymentGateway: String)?
    var paymentCompleted: Bool = false
    var getToastMessage: String = ""
    var totalAmountToPay: Double = 0.0
    var orderID: String = ""
    var customChatUniqueId: String = ""
    var comingForCustomeOrderPlace: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymnetTableView.rowHeight = UITableView.automaticDimension
        paymnetTableView.estimatedRowHeight = 150
        paymnetTableView.delegate = self
        paymnetTableView.dataSource = self
        DispatchQueue.main.async {
            self.updatePaymentTableHeight()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWalletAmountApi()
    }
    
    @IBAction func placeOrderDidTapped(_ sender: Any) {
        guard let method = selectedPaymentMethod else {
            viewModel.showAlertAtPayment(msg: "Please select a payment method")
            return
        }
        switch method {
        case .payByKNET:
            initiateKNETPayment()
        case .visapay:
            initiateVisaPayPayment()
        case .creditDebitCard:
            initiateVisaPayPayment()
        case .inAppWallet:
            let walletBalance = viewModel.walletAmount ?? 0.0
            let amountToPay = totalAmountToPay
            if walletBalance < amountToPay {
                viewModel.showAlertAtPayment(msg: "Insufficient wallet balance. Available: \(walletBalance) KD")
                return
            }
            proceedToPay()
        case .cashOnDelivery:
            proceedToPay()
        default:
            if paymentCompleted, paymentTransactionDetails != nil {
                proceedToPay()
            } else {
                viewModel.showAlertAtPayment(msg: "Payment is being processed or not completed yet.")
            }
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func giftcheckmarkAction(_ sender: Any) {
        let nextVC = UseGiftCardsViewController.instantiate(fromAppStoryboard: .MyBag)
        nextVC.onRedeem = { [weak self] cardNumber, pin, cardDetails in
            guard let self = self else { return }
            giftCardDetails = cardDetails
            giftCardLabel.text = cardNumber
            giftCardAmountLabel.isHidden = false
            giftCardAmountLabel.text = "\(cardDetails.giftCardAmount ?? "0") KD Gift Card Amount Redeemed"
            totalAmountToPay = totalAmountToPay - (Double(cardDetails.giftCardAmount ?? "0.0") ?? 0.0)
            checkMarkImageView.isHidden = false
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func proceedToPay() {
        guard let selectedMethod = selectedPaymentMethod else { return }
        if comingForCustomeOrderPlace {
            let customOrderParam: [String :Any] = ["unique_id": customChatUniqueId,
                                                   "giftcard_id": giftCardDetails?.id ?? "",
                                                   "giftcard_amount": giftCardDetails?.giftCardAmount ?? "",
                                                   "Payment_method": selectedMethod.apiValue]
            viewModel.placeCustomOrderApi(param: customOrderParam)
        } else {
            param["Payment_method"] = selectedMethod.apiValue
            param["giftcard_amount"] = giftCardDetails?.giftCardAmount
            param["giftcard_id"] = giftCardDetails?.id
            viewModel.placeOrderApi(param: param)
        }
    }
    
    func handlePaymentMethodSelection(for method: PaymentMethodType) {
        guard paymentCompleted, let details = paymentTransactionDetails else {
            if !getToastMessage.isEmpty {
                viewModel.showAlertAtPayment(msg: getToastMessage)
            } else {
                viewModel.showAlertAtPayment(msg: "Please complete the payment")
            }
            return
        }
        print("Payment completed with details: \(details)")
        proceedToPay()
    }
    
    func updatePaymentTableHeight() {
        self.paymnetTableView.layoutIfNeeded()
        self.paymentTableHeightConstraint.constant = self.paymnetTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    func didReceivePaymentError(_ message: String) {
        viewModel.showAlertAtPayment(msg: message)
    }
}

extension PlaceOrderPaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceOrderPaymentMethodsTableViewCell", for: indexPath) as! PlaceOrderPaymentMethodsTableViewCell
        
        let data = viewModel.paymentMethods[indexPath.row]
        cell.titleLabel.text = data.paymentMethodTitle
        cell.paymentMethdImageView.image = UIImage(named: data.paymentMethodImage)
        cell.descriptionLabel.text = data.description
        cell.delegate = self
        
        let isSelected = (selectedPaymentMethod?.rawValue == data.paymentMethodTitle)
        cell.selecetdPaymentMethodButtonOutlet.setImage(
            isSelected ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
            for: .normal
        )
        
        // Reset cell UI
        cell.viewApple.isHidden = true
        cell.descriptionStackView.isHidden = true
        cell.checkboxStackView.isHidden = true
        
        if isSelected {
            if selectedPaymentMethod == .applePay {
                cell.viewApple.isHidden = false
                cell.descriptionStackView.isHidden = false
                cell.setupApplePayButton()
                
                cell.startApplePayOnButtonTap(
                    invoiceValue: Decimal(totalAmountToPay),
                    orderID: orderID
                ) { [weak self] paymentStatusResponse, invoiceId, error in
                    guard let self = self else { return }
                    if let paymentStatus = paymentStatusResponse {
                        let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                        let gateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
                        
                        self.handlePaymentCompletion(
                            transactionID: transactionID,
                            invoiceId: invoiceId ?? "",
                            gateway: gateway
                        )
                    } else if let error = error {
                        self.didReceivePaymentError(error.localizedDescription)
                    } else {
                        self.didReceivePaymentError("Apple Pay was cancelled or failed")
                    }
                }
            } else if selectedPaymentMethod == .inAppWallet {
                cell.descriptionStackView.isHidden = false
                cell.checkboxStackView.isHidden = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let methodName = viewModel.paymentMethods[indexPath.row].paymentMethodTitle
        guard let method = PaymentMethodType(rawValue: methodName),
              selectedPaymentMethod != method else { return }
        selectedPaymentMethod = method
        paymnetTableView.reloadData()
        updatePaymentTableHeight()
        paymentCompleted = false
        paymentTransactionDetails = nil
        switch method {
        case .payByKNET:
            break
            //initiateKNETPayment()
        case .applePay:
            break
        case .creditDebitCard:
            break
            //initiateVisaPayPayment()
        case .visapay:
            //initiateVisaPayPayment()
            break
        case .inAppWallet, .cashOnDelivery:
            break
        }
    }
    
}

extension PlaceOrderPaymentMethodsViewController {
    
    private func initiateKNETPayment() {
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(totalAmountToPay), paymentMethod: 1)
        request.customerReference = orderID
        request.displayCurrencyIso = .kuwait_KWD
        
        let supplierId = Int.random(in: 1000...9999)
        let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: Decimal(totalAmountToPay))
        request.suppliers = [supplier]
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] response, invoiceId in
            guard let self = self else { return }
            switch response {
            case .success(let paymentStatus):
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let gateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "KNET"
                self.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: gateway)
            case .failure(let error):
                self.didReceivePaymentError(error.errorDescription)
            }
        }
    }
    
    private func initiateVisaPayPayment() {
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(totalAmountToPay), paymentMethod: 2)
        request.customerReference = orderID
        request.displayCurrencyIso = .kuwait_KWD
        let supplierId = Int.random(in: 1000...9999)
        let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: Decimal(totalAmountToPay))
        request.suppliers = [supplier]
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] response, invoiceId in
            guard let self = self else { return }
            switch response {
            case .success(let paymentStatus):
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let gateway = "VisaPay"
                self.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: gateway)
            case .failure(let error):
                self.didReceivePaymentError(error.errorDescription)
            }
        }
    }
}
