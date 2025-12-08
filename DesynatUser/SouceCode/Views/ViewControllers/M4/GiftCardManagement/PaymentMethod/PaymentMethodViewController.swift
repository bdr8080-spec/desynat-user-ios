//
//  PaymentMethodViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PaymentMethodViewController: UIViewController {
  
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
  var orderId: String = ""
  var selectedCardID: Int? = 0
  var selectedPaymentMethodID: Int? = nil
  var paymentMethods: [PaymentMethod] = [PaymentMethod(paymentMethodImage: "paymentMethods", paymentMethodTitle: "Pay by KNET", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "applePay", paymentMethodTitle: "Apple Pay", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "vispay", paymentMethodTitle: "Visapay", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "samsungPay", paymentMethodTitle: "Samsung Pay", showDescription: true),
                                         PaymentMethod(paymentMethodImage: "inAppWallet", paymentMethodTitle: "In -App Wallet", showDescription: false),
                                         PaymentMethod(paymentMethodImage: "cashOnDeliveryMethod", paymentMethodTitle: "Cash On Delivery", showDescription: true)]
  private lazy var viewModel = PaymentMethodViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    if selectedCardID == nil && selectedPaymentMethodID == nil {
           showAlert(msg: "Please select a payment option")
           return
       }
    viewModel.payForAddingCard()
  }
  
  @IBAction func cardButtonAction(_ sender: Any) {
    
  }
  
}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == cardsTableiew {
      return 2
    }
    return paymentMethods.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if tableView == cardsTableiew {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
      cell.selectedRadioImageView.image =
          (indexPath.row == selectedCardID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
    return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsTableViewCell", for: indexPath) as! PaymentMethodsTableViewCell
      let data = paymentMethods[indexPath.row]
      cell.configData(data: data)
        cell.radioButonOutlet.setImage(
            (indexPath.row == selectedPaymentMethodID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
            for: .normal
        )
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if tableView == cardsTableiew {
          selectedCardID = indexPath.row
          selectedPaymentMethodID = nil
          cardButtonOutlet.setImage(UIImage(named: "radioSelected"), for: .normal)
          paymentMethodsTableView.reloadData()
          cardsTableiew.reloadData()
      }else {
          selectedPaymentMethodID = indexPath.row
          selectedCardID = nil
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
