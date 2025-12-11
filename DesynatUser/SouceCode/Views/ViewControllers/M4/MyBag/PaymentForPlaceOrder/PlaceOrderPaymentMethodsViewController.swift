//
//  PlaceOrderPaymentMethodsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PlaceOrderPaymentMethodsViewController: UIViewController, PlaceOrderPaymentMethodsCellDelegate {
  func didReceivePaymentError(_ message: String) {
    showAlert(msg: message)
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
//    if let amountString = param["total_amount"] as? String,
//       let amount = Int(amountString) {
//      totalAmountToPay = amount
//    }
  }
  
  @IBAction func placeOrderDidTapped(_ sender: Any) {
    guard let method = selectedPaymentMethod else {
      showAlert(msg: "Please select a payment method")
      return
    }
    switch method {
    case .payByKNET:
      guard paymentCompleted, let details = paymentTransactionDetails else {
        if !getToastMessage.isEmpty {
          showToast(msg: getToastMessage)
        } else {
          showAlert(msg: "Please complete the payment")
        }
        return
      }
      print("details, \(details)")
      proceedToPay()
    case .applePay, .creditDebitCard:
      guard paymentCompleted, let details = paymentTransactionDetails else {
        if !getToastMessage.isEmpty {
          showToast(msg: getToastMessage)
        } else {
          showAlert(msg: "Please complete the payment")
        }
        return
      }
      print("details, \(details)")
      proceedToPay()
    case .visapay:
      guard paymentCompleted, let details = paymentTransactionDetails else {
        if !getToastMessage.isEmpty {
          showToast(msg: getToastMessage)
        } else {
          showAlert(msg: "Please complete the payment")
        }
        return
      }
      print("details, \(details)")
      proceedToPay()
//    case .samsungPay:
//      showAlert(msg: "Please implement standard Fatoorah execute for \(method)")
    case .inAppWallet:
      showAlert(msg: "In App Wallet")
      proceedToPay()
    case .cashOnDelivery:
      proceedToPay()
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
  
  
  func updatePaymentTableHeight() {
    self.paymnetTableView.layoutIfNeeded()
    self.paymentTableHeightConstraint.constant = self.paymnetTableView.contentSize.height
    self.view.layoutIfNeeded()
  }
}

extension PlaceOrderPaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.paymentMethods.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "PlaceOrderPaymentMethodsTableViewCell",
      for: indexPath
    ) as! PlaceOrderPaymentMethodsTableViewCell
    let data = viewModel.paymentMethods[indexPath.row]
    cell.titleLabel.text = data.paymentMethodTitle
    cell.paymentMethdImageView.image = UIImage(named: data.paymentMethodImage)
    cell.descriptionLabel.text = data.description
    cell.delegate = self
    cell.addCardDidTapped = { [weak self] in
      guard let self = self else { return }
      let nextVC = AddCardViewController.instantiate(fromAppStoryboard: .MyBag)
      self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    cell.onSetAsDefaultTapped = { [weak self] in
      guard let self = self else { return }
      // Call your API here
    }
    cell.viewApple.isHidden = true
    cell.viewCreditCard.isHidden = true
    cell.descriptionStackView.isHidden = true
    cell.checkboxStackView.isHidden = true
    cell.descriptionCheckbox.isHidden = true
    cell.cardsTableView.isHidden = true
    cell.addNewCardView.isHidden = true
    cell.cardsCount = 0

    let isSelected = (selectedPaymentMethod?.rawValue == data.paymentMethodTitle)

    cell.selecetdPaymentMethodButtonOutlet.setImage(
        isSelected ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
        for: .normal
    )

    if isSelected {
        switch selectedPaymentMethod {
        case .payByKNET:
//          cell.descriptionStackView.isHidden = false
          cell.payByKNET(
            invoiceValue: Decimal(totalAmountToPay),//Decimal(Double(totalAmountToPay)),
              orderId: orderID,
              supplierId: "4897397403"//param["supplier_id"] as? String ?? ""
          ) { [weak self] response, invoiceId, error in
            
            guard let self = self else { return }
            
            if let err = error {
              self.showAlert(msg: err.localizedDescription)
              return
            }
          }
        case .applePay:
            cell.descriptionStackView.isHidden = false
            cell.viewApple.isHidden = false
            cell.setupApplePay()
            cell.startApplePaySession()

        case .visapay:
//          cell.descriptionStackView.isHidden = false
          cell.payByVisaPay(
                      invoiceValue: Decimal(totalAmountToPay),
                      orderId: orderID,
                      supplierId: "4897397403" // Or param["supplier_id"]
                  ) { [weak self] response, invoiceId, error in
                      guard let self = self else { return }
                      if let err = error {
                          self.showAlert(msg: err.localizedDescription)
                          return
                      }
                      // Optionally handle successful payment here
                  }
//        case .samsungPay:
//            break

        case .creditDebitCard:
//            cell.descriptionStackView.isHidden = false
//            cell.viewCreditCard.isHidden = false
//            cell.cardPay()
          cell.creditDebitCardPayment(
            invoiceValue: Decimal(totalAmountToPay),
            orderId: orderID,
            supplierId: "4897397403" // Or param["supplier_id"]
        ) { [weak self] response, invoiceId, error in
            guard let self = self else { return }
            if let err = error {
                self.showAlert(msg: err.localizedDescription)
                return
            }
            // Optionally handle successful payment here
        }

        case .inAppWallet:
            cell.descriptionStackView.isHidden = false
            cell.checkboxStackView.isHidden = false
            cell.fixStackViewLayout()

        case .cashOnDelivery:
            break

        default:
            break
        }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMethodName = viewModel.paymentMethods[indexPath.row].paymentMethodTitle
    guard let method = PaymentMethodType(rawValue: selectedMethodName) else { return }
    if selectedPaymentMethod == method { return }
    selectedPaymentMethod = method
    paymnetTableView.reloadData()
    DispatchQueue.main.async {
      self.updatePaymentTableHeight()
    }
  }
}


extension PlaceOrderPaymentMethodsViewController {
  
  //  func startSamsungPaySession() {
  //    let invoiceValue = Decimal(totalAmountToPay)
  //    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
  //    request.displayCurrencyIso = .uAE_AED
  //    request.customerName = "Customer"
  //    request.userDefinedField = "ORDER-4837frberr"
  //    MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
  //      guard let self = self else { return }
  //      switch response {
  //      case .success(let session):
  //        self.applePayButton.load(session, request, .english,
  //                                 startLoading: {
  //        },
  //                                 completion: { response, invoiceId in
  //          switch response {
  //          case .success(let executeResponse):
  //            print("Apple Pay success: Invoice \(invoiceId ?? "N/A")")
  //            let transactionID = executeResponse.invoiceTransactions?.first?.transactionID ?? ""
  //            let gateway = executeResponse.invoiceTransactions?.first?.paymentGateway ?? "ApplePay"
  //            self.applePayTransactionDetails = (transactionID, invoiceId ?? "", gateway)
  //            self.paymentCompleted = true
  //            //                            self.checkOutOrder(transactionId: transactionID, paymentMethod: gateway)
  //            //                            self.orderPlaced(with: executeResponse)
  //          case .failure(let error):
  //            print("Apple Pay failed: \(error.errorDescription)")
  //            self.showAlert(msg: "Apple Pay failed: \(error.errorDescription)")
  //          }
  //        })
  //      case .failure(let error):
  //        print("Failed to initiate session: \(error.localizedDescription)")
  //        self.showAlert(msg: "Failed to start Apple Pay session")
  //      }
  //    }
  //  }
  
  func startSamsungPaySession() {
    let invoiceValue = Decimal(totalAmountToPay)
    //      let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
    request.displayCurrencyIso = .uAE_AED
    request.customerName = "Customer"
    request.userDefinedField = "ORDER-4837frberr"
    
    //      MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
    MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
      guard let self = self else { return }
      switch response {
      case .success(let session):
        print("Session initiated for Samsung Pay")
        //
        //              self.samsungPayButton.loadSamsungPay(session, request, .english,
        //                                                   startLoading: {
        //                  print("Starting Samsung Pay...")
        //              }, completion: { response, invoiceId in
        //                  switch response {
        //                  case .success(let executeResponse):
        //                      let transactionID = executeResponse.invoiceTransactions?.first?.transactionID ?? ""
        //                      let gateway = executeResponse.invoiceTransactions?.first?.paymentGateway ?? "SamsungPay"
        //                      self.samsungPayTransactionDetails = (transactionID, invoiceId ?? "", gateway)
        //                      self.paymentCompleted = true
        //                      self.proceedToPay()
        //                  case .failure(let error):
        //                      self.showAlert(msg: "Samsung Pay failed: \(error.errorDescription)")
        //                  }
        //              })
        
      case .failure(let error):
        self.showAlert(msg: "Failed to start Samsung Pay session")
      }
    }
  }
  
  
  
}

