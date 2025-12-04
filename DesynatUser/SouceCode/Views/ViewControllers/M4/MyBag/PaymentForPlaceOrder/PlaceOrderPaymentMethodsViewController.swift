//
//  PlaceOrderPaymentMethodsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PlaceOrderPaymentMethodsViewController: UIViewController {

  @IBOutlet weak var giftCardLabel: UILabel!
  @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var paymnetTableView: UITableView! {
        didSet {
            paymnetTableView.registerCellFromNib(cellID: "PlaceOrderPaymentMethodsTableViewCell")
        }
    }
    @IBOutlet weak var paymentTableHeightConstraint: NSLayoutConstraint!

    var slecetedPaymentId: Int? = 0
    var giftIsChecked: Bool = false

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
    let nextVC = OrderPlacedViewController.instantiate(fromAppStoryboard: .MyBag)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func giftcheckmarkAction(_ sender: Any) {
      let nextVC = UseGiftCardsViewController.instantiate(fromAppStoryboard: .MyBag)
      nextVC.onRedeem = { [weak self] cardNumber, pin in
              guard let self = self else { return }
              print("Card Number: \(cardNumber), PIN: \(pin)")
        giftCardLabel.text = cardNumber
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
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PlaceOrderPaymentMethodsTableViewCell",
            for: indexPath
        ) as! PlaceOrderPaymentMethodsTableViewCell
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
            
            if slecetedPaymentId == 5 {
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
            else if slecetedPaymentId == 6 {
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
