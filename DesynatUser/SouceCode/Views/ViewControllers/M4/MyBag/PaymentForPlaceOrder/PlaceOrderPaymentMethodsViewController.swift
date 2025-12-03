//
//  PlaceOrderPaymentMethodsViewController.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class PlaceOrderPaymentMethodsViewController: UIViewController {

    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var paymnetTableView: UITableView! {
        didSet {
            paymnetTableView.registerCellFromNib(cellID: "PlaceOrderPaymentMethodsTableViewCell")
        }
    }

    var slecetedPaymentId: Int? = 0
    var giftIsChecked: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable dynamic row height
        paymnetTableView.rowHeight = UITableView.automaticDimension
        paymnetTableView.estimatedRowHeight = 150
        paymnetTableView.delegate = self
        paymnetTableView.dataSource = self
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func giftcheckmarkAction(_ sender: Any) {
        giftIsChecked.toggle()
        checkMarkImageView.isHidden = !giftIsChecked
    }
}

extension PlaceOrderPaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceOrderPaymentMethodsTableViewCell", for: indexPath) as! PlaceOrderPaymentMethodsTableViewCell
        
        // Set radio button
        cell.selecetdPaymentMethodButtonOutlet.setImage(
            (indexPath.row == slecetedPaymentId) ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected"),
            for: .normal
        )
        
        // Show/hide extra views only for the selected cell
        if indexPath.row == slecetedPaymentId {
            if slecetedPaymentId == 5 || slecetedPaymentId == 6 {
                cell.descriptionStackView.isHidden = false
                cell.checkboxStackView.isHidden = false
                
                if slecetedPaymentId == 5 {
                    cell.descriptionCheckbox.isHidden = false
                    cell.cardsTableView.isHidden = false
                    cell.addNewCardView.isHidden = false
                    
                    // Set number of cards and update nested table height
                    cell.cardsCount = 2 // Replace with your dynamic card count
                    cell.cardsTableView.reloadData()
                    
                } else { // slecetedPaymentId == 6
                    cell.descriptionCheckbox.isHidden = true
                    cell.cardsTableView.isHidden = true
                    cell.addNewCardView.isHidden = true
                    cell.cardsCount = 0
                    cell.cardsTableView.reloadData()
                }
            }
        } else {
            // Hide all extra views for unselected cells
            cell.descriptionStackView.isHidden = true
            cell.checkboxStackView.isHidden = true
            cell.descriptionCheckbox.isHidden = true
            cell.cardsTableView.isHidden = true
            cell.addNewCardView.isHidden = true
            cell.cardsCount = 0
            cell.cardsTableView.reloadData()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slecetedPaymentId = indexPath.row
        paymnetTableView.reloadData()
    }
}
