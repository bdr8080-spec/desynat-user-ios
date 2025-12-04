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
            cardsTableView.rowHeight = 60
            cardsTableView.separatorStyle = .none
        }
    }
  var selectedCardID: Int = 0
  var isDefaultSelected: Bool = false
    // count of cards shown in nested tableView
    var cardsCount: Int = 0 {
        didSet { updateCardsTableViewHeight() }
    }
  
  var addCardDidTapped:(() -> Void)?
  var onSetAsDefaultTapped: (() -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
    }

    // MARK: - Update nested table height
    func updateCardsTableViewHeight() {
        DispatchQueue.main.async {
            self.cardsTableView.layoutIfNeeded()
            self.cardTableViewHeightConstarint.constant = self.cardsTableView.contentSize.height
            self.layoutIfNeeded()
        }
    }
  
  
  @IBAction func addCardDidTapped(_ sender: Any) {
    addCardDidTapped?()
  }
  
  @IBAction func setAsDefaultDidTapped(_ sender: Any) {
    isDefaultSelected.toggle()
        
        // Immediately update the button image
        let imageName = isDefaultSelected ? "selectedFilterCheckBox" : "unslectedCheckbox"
        descriptionCheckbox.setImage(UIImage(named: imageName), for: .normal)
        
        // Call API if needed
        onSetAsDefaultTapped?()
  }
  
    // MARK: Fix stackView layout
    func fixStackViewLayout() {
        descriptionStackView.layoutIfNeeded()
        checkboxStackView.layoutIfNeeded()
        addNewCardView.layoutIfNeeded()
        cardsTableView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
}

// MARK: - TableView delegate
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
