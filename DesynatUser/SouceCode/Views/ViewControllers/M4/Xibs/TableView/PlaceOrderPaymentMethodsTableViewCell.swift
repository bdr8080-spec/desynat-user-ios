//
//  PlaceOrderPaymentMethodsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PlaceOrderPaymentMethodsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTableViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var addNewCardView: CustomView!
    @IBOutlet weak var checkboxStackView: UIStackView!
    @IBOutlet weak var selecetdPaymentMethodButtonOutlet: UIButton!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionCheckbox: UIButton!
    @IBOutlet weak var cardsTableView: UITableView! {
        didSet {
            cardsTableView.registerCellFromNib(cellID: "CreditCardTableViewCell")
        }
    }
    
    var selectedCardID: Int? = 0
    
    // Number of cards in the nested table view
    var cardsCount: Int = 0 {
        didSet {
            updateCardsTableViewHeight()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
    }

    @IBAction func addNewCardDidTapped(_ sender: Any) {
        // Handle add new card action
    }

    // Update height of nested table view
    func updateCardsTableViewHeight() {
        let rowHeight: CGFloat = 60 // Replace with your actual row height
        cardTableViewHeightConstarint.constant = rowHeight * CGFloat(cardsCount)
        layoutIfNeeded()
    }
}

extension PlaceOrderPaymentMethodsTableViewCell: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cardsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as! CreditCardTableViewCell
    cell.selectedRadioImageView.image = (indexPath.row == selectedCardID) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCardID = indexPath.row
    cardsTableView.reloadData()
  }
}
