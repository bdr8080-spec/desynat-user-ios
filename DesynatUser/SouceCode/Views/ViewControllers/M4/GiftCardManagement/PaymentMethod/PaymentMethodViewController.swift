//
//  PaymentMethodViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import MFSDK

class PaymentMethodViewController: UIViewController, PlaceOrderPaymentMethodsCellDelegate {
  
  func didReceivePaymentError(_ message: String) {
    showAlert(msg: message)
  }
  
  @IBOutlet weak var viewCreditCard: UIView!
  @IBOutlet weak var viewPayment: MFPaymentCardView!
  @IBOutlet weak var cardButtonOutlet: UIButton!
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
  var getToastMessage: String = ""
  var paymentTransactionDetails: (transactionID: String, invoiceId: String, paymentGateway: String)?
  var paymentCompleted: Bool = false
  var supplierId: String? = "34897305"
  var payAmount: Double = 0.0
  var orderId: String = ""
  //  var selectedCardID: Int? = 0
  var isCardIsSlecteed: Bool = false
  var selectedPaymentMethodID: Int? = nil
  var paymentMethods: [PaymentMethod] = [PaymentMethod(paymentMethodImage: "paymentMethods", paymentMethodTitle: "Pay by KNET", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "applePay", paymentMethodTitle: "Apple Pay", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "vispay", paymentMethodTitle: "Visapay", showDescription: true),
                                        // PaymentMethod(paymentMethodImage: "samsungPay", paymentMethodTitle: "Samsung Pay", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "inAppWallet", paymentMethodTitle: "In -App Wallet", showDescription: false)]
  private lazy var viewModel = PaymentMethodViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewCreditCard.isHidden = true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    cardsTableViewHeightConstraint.constant = cardsTableiew.contentSize.height
    paymnetTableviewHieghtConstraint.constant = paymentMethodsTableView.contentSize.height
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func proceedDidTapped(_ sender: Any) {
    if isCardIsSlecteed == false && selectedPaymentMethodID == nil {
      showAlert(msg: "Please select a payment option")
      return
    }
    
    if isCardIsSlecteed {
            guard paymentCompleted, let details = paymentTransactionDetails else {
                showAlert(msg: "Please fill the card details for payment")
                return
            }
            // Use the completed payment
            viewModel.payForAddingCard(transactionId: details.transactionID)
    } else if selectedPaymentMethodID == 1 {
      guard paymentCompleted, let details = paymentTransactionDetails else {
        if !getToastMessage.isEmpty {
          showToast(msg: getToastMessage)
        } else {
          showAlert(msg: "Please complete the payment")
        }
        return
      }
      print("details, \(details)")
      viewModel.payForAddingCard(transactionId: details.transactionID)
    } else if selectedPaymentMethodID == 0 {
      guard paymentCompleted, let details = paymentTransactionDetails else {
        if !getToastMessage.isEmpty {
          showToast(msg: getToastMessage)
        } else {
          showAlert(msg: "Please complete the payment")
        }
        return
      }
      print("details, \(details)")
      viewModel.payForAddingCard(transactionId: details.transactionID)
    } else if selectedPaymentMethodID == 2 {
      guard paymentCompleted, let details = paymentTransactionDetails else {
        if !getToastMessage.isEmpty {
          showToast(msg: getToastMessage)
        } else {
          showAlert(msg: "Please complete the payment")
        }
        return
      }
      print("details, \(details)")
      viewModel.payForAddingCard(transactionId: details.transactionID)
    }
  }
  
  @IBAction func cardButtonAction(_ sender: Any) {
    cardButtonOutlet.setImage(UIImage(named: "radioSelected"), for: .normal)
    isCardIsSlecteed = true
//    viewCreditCard.isHidden = false
    
//    cardPay()
    creditDebitCardPayment(
      invoiceValue: Decimal(payAmount),
      orderId: orderId,
      supplierId: "4897397403" // Or param["supplier_id"]
  ) { [weak self] response, invoiceId, error in
      guard let self = self else { return }
      if let err = error {
          self.showAlert(msg: err.localizedDescription)
          return
      }
      // Optionally handle successful payment here
  }
  }
  
  func creditDebitCardPayment(invoiceValue: Decimal,
                              orderId: String,
                              supplierId: String?,
                              completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
                
                guard let supplierIDString = supplierId,
                      let supplierCode = Int(supplierIDString) else {
                    completion(nil, nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid supplier ID."]))
                    return
                }
                
                // Payment method ID 2 for VisaPay
                let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 2)
                request.customerReference = orderId
                
                let supplier = MFSupplier(supplierCode: 4, invoiceShare: invoiceValue)
                request.suppliers = [supplier]
                request.displayCurrencyIso = .uAE_AED // Or your currency

                MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
                    switch result {
                    case .success(let paymentStatus):
                        completion(paymentStatus, invoiceId, nil)
                        
                        let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                        let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay"
                        
                      DispatchQueue.main.async {
                          self.paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
                          self.paymentCompleted = true
                      }

                        
                    case .failure(let error):
                        completion(nil, invoiceId,
                                   NSError(domain: "", code: 0,
                                           userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
                    }
                }
            }
  
  func paymentDoneWithCard() {
    let invoiceValue = Decimal(payAmount)
    
    let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
    
    request.customerReference = self.orderId
    
    guard let supplierIDString = self.supplierId,
          let supplierCode = Int(supplierIDString) else {
      self.showAlert(msg: "Invalid supplier ID.")
      return
    }
    
    let supplier = MFSupplier(
      supplierCode: supplierCode, invoiceShare: invoiceValue
    )
    request.suppliers = [supplier]
    
    viewPayment.pay(request, .english) { [weak self] response, invoiceId in
      guard let self = self else { return }
      
      switch response {
      case .success(let paymentStatus):
        print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")
        
        let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
        let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "card"
        paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
        paymentCompleted = true
        viewModel.payForAddingCard(transactionId: transactionID)
        // customerrefence - orderif  or supplier id
        //            self.checkOutOrder(transactionId: transactionID, paymentMethod: paymentGateway)
        //            self.orderPlaced(with: paymentStatus)
        
      case .failure(let error):
        print("Payment Error: \(error.errorDescription)")
        self.showAlert(msg: "Payment Failed: \(error.errorDescription)")
      }
    }
  }
  
}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == cardsTableiew {
      return 2
    }
    return paymentMethods.count
  }
  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    
//    if tableView == cardsTableiew {
//      let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
//      //        cell.selectedRadioImageView.image =
//      //            (indexPath.row == selectedCardID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
//      return cell
//    }
//    
//    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsTableViewCell", for: indexPath) as! PaymentMethodsTableViewCell
//    
//    let data = paymentMethods[indexPath.row]
//    cell.delegate = self
//    cell.configData(data: data)
//    cell.viewApple.isHidden = true
//    // Radio button
//    cell.radioButonOutlet.setImage(
//      (indexPath.row == selectedPaymentMethodID)
//      ? UIImage(named: "radioSelected")
//      : UIImage(named: "radioUnselected"),
//      for: .normal
//    )
//    if indexPath.row == 0 {
//      if selectedPaymentMethodID == 0 {
//        cell.payByKNET(
//          invoiceValue: Decimal(payAmount),
//          orderId: orderId,
//          supplierId: "4897397403"
//        ) { [weak self] response, invoiceId, error in
//          
//          guard let self = self else { return }
//          
//          if let err = error {
//            self.showAlert(msg: err.localizedDescription)
//            return
//          }
//        }
//      }
//    }else if indexPath.row == 1 {
//      if selectedPaymentMethodID == 1 {
//        cell.viewApple.isHidden = false
//        cell.setupApplePay()
//        cell.startApplePaySession()
//      } else {
//        cell.viewApple.isHidden = true
//      }
//    } else if indexPath.row == 2 {
//      if selectedPaymentMethodID == 2 {
//        cell.payByVisaPay(
//          invoiceValue: Decimal(payAmount),
//          orderId: orderId,
//          supplierId: "4897397403" // Or param["supplier_id"]
//        ) { [weak self] response, invoiceId, error in
//          guard let self = self else { return }
//          if let err = error {
//            self.showAlert(msg: err.localizedDescription)
//            return
//          }
//        }
//      }
//    }
//    return cell
//  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if tableView == cardsTableiew {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
          // Configure card cell if needed
          return cell
      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsTableViewCell", for: indexPath) as! PaymentMethodsTableViewCell
      
      let data = paymentMethods[indexPath.row]
      cell.delegate = self
      cell.configData(data: data)
      
      // Reset Apple Pay view by default
      cell.viewApple.isHidden = true
      
      // Radio button selection
      cell.radioButonOutlet.setImage(
          (indexPath.row == selectedPaymentMethodID)
          ? UIImage(named: "radioSelected")
          : UIImage(named: "radioUnselected"),
          for: .normal
      )
      
      // Handle each payment method
      switch indexPath.row {
      case 0: // KNET
          if selectedPaymentMethodID == 0 {
              cell.payByKNET(
                  invoiceValue: Decimal(payAmount),
                  orderId: orderId,
                  supplierId: supplierId ?? ""
              ) { [weak self] response, invoiceId, error in
                  guard let self = self else { return }
                  if let err = error {
                      self.showAlert(msg: err.localizedDescription)
                  }
              }
          }
          
      case 1: // Apple Pay
          if selectedPaymentMethodID == 1 {
              cell.viewApple.isHidden = false
              cell.setupApplePay()
              cell.startApplePaySession()
          }
          
      case 2: // VisaPay
          if selectedPaymentMethodID == 2 {
              cell.payByVisaPay(
                  invoiceValue: Decimal(payAmount),
                  orderId: orderId,
                  supplierId: supplierId ?? ""
              ) { [weak self] response, invoiceId, error in
                  guard let self = self else { return }
                  if let err = error {
                      self.showAlert(msg: err.localizedDescription)
                  }
              }
          }
          
      case 3: // Samsung Pay (if implemented)
          if selectedPaymentMethodID == 3 {
              // You can implement Samsung Pay session here
          }
          
      case 4: // In-App Wallet
          if selectedPaymentMethodID == 4 {
              // Handle In-App Wallet UI or logic
          }
          
      default:
          break
      }
      
      return cell
  }

  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == cardsTableiew {
      //          selectedCardID = indexPath.row
      //          selectedPaymentMethodID = nil
      //          cardButtonOutlet.setImage(UIImage(named: "radioSelected"), for: .normal)
      //          paymentMethodsTableView.reloadData()
      //          cardsTableiew.reloadData()
    }else {
      selectedPaymentMethodID = indexPath.row
      //          selectedCardID = nil
      viewCreditCard.isHidden = true
      isCardIsSlecteed = false
      cardButtonOutlet.setImage(UIImage(named: "radioUnselected"), for: .normal)
      cardsTableiew.reloadData()
      paymentMethodsTableView.reloadData()
    }
  }
  
}

struct PaymentMethod {
  let paymentMethodImage: String
  let paymentMethodTitle: String
  let showDescription: Bool
}

extension PaymentMethodViewController {
  func cardPay() {
    var configure = MFCardConfigureBuilder.default
    // but you can create yours
    // set placeholders
    configure.setPlaceholder(MFCardPlaceholder(cardHolderNamePlaceholder: "Name", cardNumberPlaceholder: "Number", expiryDatePlaceholder: "MM / YY", cvvPlaceholder: "CVV"))
    // set labels
    configure.setLabel(MFCardLabel(cardHolderNameLabel: "Card holder name", cardNumberLabel: "Card number", expiryDateLabel: "MM / YY", cvvLabel: "CVV", showLabels: true, fontWeight: .normal))
    // set theme
    let theme = MFCardTheme(inputColor: .black, labelColor: .black, errorColor: .red, borderColor: .black)
    theme.language = .english // select .arabic for rtl vie
    configure.setTheme(theme)
    // set height and margin of card inputs
    configure.setCardInput(MFCardInput(inputHeight: 32, inputMargin: 15))
    
    // set labels and texts font size
    configure.setFontSize(15)
    // set border width
    configure.setBorderWidth(1)
    // set border radius for input fields
    configure.setBorderRadius(8)
    // set the display of card icons
    configure.setHideCardIcon(false)
    // set Font Family
    configure.setFontFamily(.timesNewRoman)
    // set box shadow
    configure.setBoxShadow(MFBoxShadow(hOffset: 0, vOffset: 0, blur: 0, spread: 0, color: .gray))
    
    // create the new configure and assigned to payment card view
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
        //self?.showToast(error)
      }
    }
  }
  
  
}
