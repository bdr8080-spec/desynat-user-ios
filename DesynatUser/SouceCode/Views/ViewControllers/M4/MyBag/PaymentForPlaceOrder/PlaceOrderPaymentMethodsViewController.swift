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
  var slecetedPaymentId: Int? = 0
  var giftCardDetails: UseGiftCardDataModel?
  var giftIsChecked: Bool = false
  var param: [String: Any] = [:]
  var paymentMethods: [PaymentMethodForPlaceOrder] = [PaymentMethodForPlaceOrder(paymentMethodImage: "paymentMethods", paymentMethodTitle: "Pay by KNET", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "applePay", paymentMethodTitle: "Apple Pay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "vispay", paymentMethodTitle: "Visapay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "samsungPay", paymentMethodTitle: "Samsung Pay", showDescription: true, description: ""),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "inAppWallet", paymentMethodTitle: "Credit/ Debit Card", showDescription: true, description: "Set as default payment method"),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "inAppWallet", paymentMethodTitle: "In -App Wallet", showDescription: false, description: "Available Balance : 349 KD"),
                                                      PaymentMethodForPlaceOrder(paymentMethodImage: "cashOnDeliveryMethod", paymentMethodTitle: "Cash On Delivery", showDescription: true, description: "")]
  
  
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
    guard let slecetedPaymentId else { return }
    if slecetedPaymentId < 5 { //1 myfatoorah 2 wallet 3 Cod
      param["Payment_method"] = 1
    } else if slecetedPaymentId == 5 {
      param["Payment_method"] = 2
    } else if slecetedPaymentId == 6{
      param["Payment_method"] = 3
    }
    param["giftcard_amount"] = giftCardDetails?.giftCardAmount
    param["giftcard_id"] = giftCardDetails?.id
    viewModel.placeOrderApi(param: param)
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
  
  func updatePaymentTableHeight() {
    self.paymnetTableView.layoutIfNeeded()
    self.paymentTableHeightConstraint.constant = self.paymnetTableView.contentSize.height
    self.view.layoutIfNeeded()
  }
}


extension PlaceOrderPaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return paymentMethods.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "PlaceOrderPaymentMethodsTableViewCell",
      for: indexPath
    ) as! PlaceOrderPaymentMethodsTableViewCell
    let data = paymentMethods[indexPath.row]
    cell.titleLabel.text = data.paymentMethodTitle
    cell.paymentMethdImageView.image = UIImage(named: data.paymentMethodImage)
    cell.descriptionLabel.text = data.description
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
    
    // Set radio button
    cell.selecetdPaymentMethodButtonOutlet.setImage(
      (indexPath.row == slecetedPaymentId) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
      for: .normal
    )
    
    // Only show for index 5 & 6
    if indexPath.row == slecetedPaymentId {
      
      if slecetedPaymentId == 4 {
        // Show description + cards
        cell.descriptionStackView.isHidden = false
        cell.checkboxStackView.isHidden = false
        cell.descriptionCheckbox.isHidden = false
        
        cell.cardsTableView.isHidden = false
        cell.addNewCardView.isHidden = false
        
        cell.cardsCount = 2
        cell.cardsTableView.reloadData()
        cell.updateCardsTableViewHeight()
        cell.fixStackViewLayout()
      }
      else if slecetedPaymentId == 5 {
        // Show description only
        cell.descriptionStackView.isHidden = false
        cell.checkboxStackView.isHidden = false
        
        cell.cardsCount = 0
        cell.fixStackViewLayout()
      }
    }
    
    // After layout update table height
    DispatchQueue.main.async {
      self.updatePaymentTableHeight()
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if slecetedPaymentId == indexPath.row {
      return
    }
    
    // Otherwise update selection
    slecetedPaymentId = indexPath.row
    paymnetTableView.reloadData()
    
    DispatchQueue.main.async {
      self.updatePaymentTableHeight()
    }
  }
}

struct PaymentMethodForPlaceOrder {
  let paymentMethodImage: String
  let paymentMethodTitle: String
  let showDescription: Bool
  let description: String
}
