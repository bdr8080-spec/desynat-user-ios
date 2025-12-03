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
  var selectedCardID: Int? = 0
  var selectedPaymentMethodID: Int? = nil
  
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
    let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
    vc.comingReason = .giftCardPurchased
    vc.callBackDismiss = { [weak self] in
        self?.navigationController?.popToViewController(ofType: GiftCardsListViewController.self)
    }
    self.navigationController?.present(vc, animated: true)
  }
  
  @IBAction func cardButtonAction(_ sender: Any) {
    
  }
  
}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == cardsTableiew {
      return 2
    }
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if tableView == cardsTableiew {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
      cell.selectedRadioImageView.image =
          (indexPath.row == selectedCardID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
    return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsTableViewCell", for: indexPath) as! PaymentMethodsTableViewCell
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
