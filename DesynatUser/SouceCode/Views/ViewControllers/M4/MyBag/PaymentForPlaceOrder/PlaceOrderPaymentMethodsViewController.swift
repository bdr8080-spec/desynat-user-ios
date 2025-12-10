//
//  PlaceOrderPaymentMethodsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PlaceOrderPaymentMethodsViewController: UIViewController {
  
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
  
  @IBAction func placeOrderDidTapped(_ sender: Any) {
    guard let method = selectedPaymentMethod else {
      showAlert(msg: "Please select a payment method")
      return
    }
    switch method {
    case .payByKNET:
      showAlert(msg: "Please tap the Apple Pay button to continue.") // Adjust message if needed
    case .applePay:
      showAlert(msg: "Please tap the Apple Pay button to continue.")
    case .visapay:
      showAlert(msg: "Please implement standard Fatoorah execute for \(method)")
    case .samsungPay:
      showAlert(msg: "Please implement standard Fatoorah execute for \(method)")
    case .creditDebitCard:
      showAlert(msg: "Please implement standard Fatoorah execute for \(method)")
    case .inAppWallet:
      showAlert(msg: "In App Wallet")
      proceedToPay()
    case .cashOnDelivery:
      showAlert(msg: "Cash on Delivery")
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
    if let amountString = param["total_amount"] as? String,
       let amount = Int(amountString) {
      cell.totalAmountToPay = amount
    }
    cell.addCardDidTapped = { [weak self] in
      guard let self = self else { return }
      let nextVC = AddCardViewController.instantiate(fromAppStoryboard: .MyBag)
      self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    cell.onSetAsDefaultTapped = { [weak self] in
      guard let self = self else { return }
      // Call your API here
    }
    // Hide all by default
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
      case .creditDebitCard:
        cell.descriptionStackView.isHidden = false
        cell.checkboxStackView.isHidden = false
        cell.descriptionCheckbox.isHidden = false
        
        cell.cardsTableView.isHidden = false
        cell.addNewCardView.isHidden = false
        
        cell.cardsCount = 2
        cell.cardsTableView.reloadData()
        cell.updateCardsTableViewHeight()
        cell.fixStackViewLayout()
      case .inAppWallet:
        cell.descriptionStackView.isHidden = false
        cell.checkboxStackView.isHidden = false
        cell.cardsCount = 0
        cell.fixStackViewLayout()
      case .applePay:
        cell.paymentMethodView.isHidden = false
        DispatchQueue.main.async {
          cell.layoutIfNeeded()
          cell.setupApplePay()
          cell.startApplePaySession()
        }
      default:
        break
      }
    }
    
    // Inside cellForRowAt when selectedPaymentMethod == .applePay
    cell.onPaymentCompletion = { [weak self] paymentResponse, invoiceId, error in
      guard let self = self else { return }
      
      if let error = error {
        self.showAlert(msg: "Payment failed: \(error.localizedDescription)")
        return
      }
      
      guard let response = paymentResponse else {
        self.showAlert(msg: "Payment failed: No response")
        return
      }
      
      // Extract transaction details
      let transaction = response.invoiceTransactions?.first
      let transactionID = transaction?.transactionID ?? ""
      let paymentGateway = transaction?.paymentGateway ?? "ApplePay"
      
      // Save for final order placement
      //        self.param["transaction_id"] = transactionID
      //        self.param["payment_gateway"] = paymentGateway
      //        self.param["invoice_id"] = invoiceId
      
      // Now place the actual order
      self.proceedToPay()
    }
    // After layout update table height
    DispatchQueue.main.async {
      self.updatePaymentTableHeight()
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

