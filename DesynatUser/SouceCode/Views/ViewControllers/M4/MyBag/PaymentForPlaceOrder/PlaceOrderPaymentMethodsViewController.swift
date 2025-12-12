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
        // Set the payment details after successful payment
        self.paymentTransactionDetails = (transactionID, invoiceId, gateway)
        self.paymentCompleted = true
        
        // Call placeOrderApi internally after payment completion
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
  var selectedPaymentMethod: PaymentMethodType?// = .payByKNET
  var giftCardDetails: UseGiftCardDataModel?
  var giftIsChecked: Bool = false
  var param: [String: Any] = [:]
  let applePayButton = MFApplePayButton()
  var paymentTransactionDetails: (transactionID: String, invoiceId: String, paymentGateway: String)?
  var paymentCompleted: Bool = false
  var getToastMessage: String = ""
  var totalAmountToPay: Double = 0.0
  var orderID: String = "46464646"
  let samsungPayButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Pay with Samsung Pay", for: .normal)
    button.backgroundColor = .black
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()
  
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
//    guard let method = selectedPaymentMethod else {
//      showAlert(msg: "Please select a payment method")
//      return
//    }
//    switch method {
//    case .payByKNET:
//      guard paymentCompleted, let details = paymentTransactionDetails else {
//        if !getToastMessage.isEmpty {
//          showAlert(msg: getToastMessage)
//        } else {
//          showAlert(msg: "Please complete the payment")
//        }
//        return
//      }
//      print("details, \(details)")
//      proceedToPay()
//    case .applePay, .creditDebitCard:
//      guard paymentCompleted, let details = paymentTransactionDetails else {
//        if !getToastMessage.isEmpty {
//          showAlert(msg: getToastMessage)
//        } else {
//          showAlert(msg: "Please complete the payment")
//        }
//        return
//      }
//      print("details, \(details)")
//      proceedToPay()
//    case .visapay:
//      guard paymentCompleted, let details = paymentTransactionDetails else {
//        if !getToastMessage.isEmpty {
//          showAlert(msg: getToastMessage)
//        } else {
//          showAlert(msg: "Please complete the payment")
//        }
//        return
//      }
//      print("details, \(details)")
//      proceedToPay()
//      //    case .samsungPay:
//      //      showAlert(msg: "Please implement standard Fatoorah execute for \(method)")
//    case .inAppWallet:
//      let walletBalance = viewModel.walletAmount ?? 0
//      if walletBalance < totalAmountToPay {
//        showAlert(msg: "Insufficient wallet balance")
//        return
//      }
//      proceedToPay()
//    case .cashOnDelivery:
//      proceedToPay()
//    }
    
    guard let method = selectedPaymentMethod else {
            showAlert(msg: "Please select a payment method")
            return
        }

        switch method {
        case .cashOnDelivery:
            // No payment needed → directly place order
            proceedToPay()

        case .inAppWallet:
            let walletBalance = viewModel.walletAmount ?? 0.0
            let amountToPay = totalAmountToPay
            
            if walletBalance < amountToPay {
                showAlert(msg: "Insufficient wallet balance. Available: \(walletBalance) KD")
                return
            }
            // Wallet has enough → place order directly
            proceedToPay()

        default:
            // All online payments (Apple Pay, KNET, Card, etc.)
            if paymentCompleted, paymentTransactionDetails != nil {
                // User somehow tapped again after success (rare) → allow
                proceedToPay()
            } else {
                // This should NEVER happen because payment auto-proceeds, but just in case
                showAlert(msg: "Payment is being processed or not completed yet.")
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
    //      giftIsChecked.toggle()
    //      checkMarkImageView.isHidden = !giftIsChecked
  }
  
  func proceedToPay() {
    guard let selectedMethod = selectedPaymentMethod else { return }
    param["Payment_method"] = selectedMethod.apiValue
    param["giftcard_amount"] = giftCardDetails?.giftCardAmount
    param["giftcard_id"] = giftCardDetails?.id
    viewModel.placeOrderApi(param: param)
  }
    
    func handlePaymentMethodSelection(for method: PaymentMethodType) {
        // Ensure payment is completed before proceeding
        guard paymentCompleted, let details = paymentTransactionDetails else {
            if !getToastMessage.isEmpty {
                showAlert(msg: getToastMessage)
            } else {
                showAlert(msg: "Please complete the payment")
            }
            return
        }

        // Call proceedToPay after successful payment
        print("Payment completed with details: \(details)")
        proceedToPay()
    }
  
  
  func updatePaymentTableHeight() {
    self.paymnetTableView.layoutIfNeeded()
    self.paymentTableHeightConstraint.constant = self.paymnetTableView.contentSize.height
    self.view.layoutIfNeeded()
  }
  
  func didReceivePaymentError(_ message: String) {
    showAlert(msg: message)
  }
}

extension PlaceOrderPaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.paymentMethods.count
  }
  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(
//      withIdentifier: "PlaceOrderPaymentMethodsTableViewCell",
//      for: indexPath
//    ) as! PlaceOrderPaymentMethodsTableViewCell
//    let data = viewModel.paymentMethods[indexPath.row]
//    cell.titleLabel.text = data.paymentMethodTitle
//    cell.paymentMethdImageView.image = UIImage(named: data.paymentMethodImage)
//    cell.descriptionLabel.text = data.description
//    cell.delegate = self
//    cell.addCardDidTapped = { [weak self] in
//      guard let self = self else { return }
//      let nextVC = AddCardViewController.instantiate(fromAppStoryboard: .MyBag)
//      self.navigationController?.pushViewController(nextVC, animated: true)
//    }
//    
//    cell.onSetAsDefaultTapped = { [weak self] in
//      guard let self = self else { return }
//      // Call your API here
//    }
//    cell.viewApple.isHidden = true
//    cell.viewCreditCard.isHidden = true
//    cell.descriptionStackView.isHidden = true
//    cell.checkboxStackView.isHidden = true
//    cell.descriptionCheckbox.isHidden = true
//    cell.cardsTableView.isHidden = true
//    cell.addNewCardView.isHidden = true
//    cell.cardsCount = 0
//    
//    let isSelected = (selectedPaymentMethod?.rawValue == data.paymentMethodTitle)
//    
//    cell.selecetdPaymentMethodButtonOutlet.setImage(
//      isSelected ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
//      for: .normal
//    )
//    
//    if isSelected {
//      switch selectedPaymentMethod {
//      case .payByKNET:
//        cell.payByKNET(
//          invoiceValue: Decimal(totalAmountToPay),
//          orderId: orderID,
//          supplierId: Int.random(in: 1000...9999)
//        ) { [weak self] response, invoiceId, error in
//          
//          guard let self = self else { return }
//          
//          if let err = error {
//            self.showAlert(msg: err.localizedDescription)
//            return
//          }
//        }
//      case .applePay:
//        cell.descriptionStackView.isHidden = false
//        cell.viewApple.isHidden = false
//        cell.setupApplePay()
//        cell.startApplePaySession()
//        
//      case .visapay:
//        cell.payByVisaPay(
//          invoiceValue: Decimal(totalAmountToPay),
//          orderId: orderID,
//          supplierId: Int.random(in: 1000...9999)
//        ) { [weak self] response, invoiceId, error in
//          guard let self = self else { return }
//          if let err = error {
//            self.showAlert(msg: err.localizedDescription)
//            return
//          }
//        }
//        //        case .samsungPay:
//        //            break
//        
//      case .creditDebitCard:
//        cell.creditDebitCardPayment(
//          invoiceValue: Decimal(totalAmountToPay),
//          orderId: orderID,
//          supplierId: Int.random(in: 1000...9999)
//        ) { [weak self] response, invoiceId, error in
//          guard let self = self else { return }
//          if let err = error {
//            self.showAlert(msg: err.localizedDescription)
//            return
//          }
//        }
//      case .inAppWallet:
//        cell.descriptionStackView.isHidden = false
//        cell.checkboxStackView.isHidden = false
//        cell.fixStackViewLayout()
//      case .cashOnDelivery:
//        break
//      default:
//        break
//      }
//    }
//    return cell
//  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let selectedMethodName = viewModel.paymentMethods[indexPath.row].paymentMethodTitle
//    guard let method = PaymentMethodType(rawValue: selectedMethodName) else { return }
//    if selectedPaymentMethod == method { return }
//    selectedPaymentMethod = method
//    paymnetTableView.reloadData()
//    DispatchQueue.main.async {
//      self.updatePaymentTableHeight()
//    }
//  }
  
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
                    // SUCCESS
                    let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                    let gateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
                    
                    self.handlePaymentCompletion(
                        transactionID: transactionID,
                        invoiceId: invoiceId ?? "",
                        gateway: gateway
                    )
                } else if let error = error {
                    // FAILURE from Apple Pay sheet
                    self.didReceivePaymentError(error.localizedDescription)
                } else {
                    // Cancelled or unknown
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
          
          // Reset previous payment state
          paymentCompleted = false
          paymentTransactionDetails = nil
          
          // Start payment immediately for online methods
          switch method {
          case .payByKNET:
              initiateKNETPayment()
          case .applePay:
              // Apple Pay button is visible, but we just reload cell (user taps button)
              break
          case .creditDebitCard:
              initiateCreditCardPayment()
          case .visapay:
              initiateVisaPayPayment()
          case .inAppWallet, .cashOnDelivery:
              break // Handled by Place Order button
          }
      }
  
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
                  self.didReceivePaymentError(error.errorDescription ?? "KNET payment failed")
              }
          }
      }
  
  private func initiateCreditCardPayment() {
          let request = MFExecutePaymentRequest(invoiceValue: Decimal(totalAmountToPay), paymentMethod: 8)
          request.customerReference = orderID
          request.displayCurrencyIso = .uAE_AED
//    Int.random(in: 1000...9999)
    let supplierId = Int.random(in: 1000...9999)
          let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: Decimal(totalAmountToPay))
          request.suppliers = [supplier]
          
          MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] response, invoiceId in
              guard let self = self else { return }
              switch response {
              case .success(let paymentStatus):
                  let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                  let gateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "Card"
                  self.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: gateway)
              case .failure(let error):
                  self.didReceivePaymentError(error.errorDescription ?? "Card payment failed")
              }
          }
      }
  
  private func initiateVisaPayPayment() {
          let request = MFExecutePaymentRequest(invoiceValue: Decimal(totalAmountToPay), paymentMethod: 2)
          request.customerReference = orderID
          request.displayCurrencyIso = .uAE_AED
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
                  self.didReceivePaymentError(error.errorDescription ?? "VisaPay failed")
              }
          }
      }
  
}
