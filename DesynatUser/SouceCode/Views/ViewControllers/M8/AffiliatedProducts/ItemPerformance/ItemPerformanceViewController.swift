//
//  ItemPerformanceViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class ItemPerformanceViewController: UIViewController {

    @IBOutlet weak var productImageView: CustomImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var discountPercenteLabel: UILabel!
    @IBOutlet weak var commissionPercentageLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalOrdersLabel: UILabel!
    @IBOutlet weak var conversionRateLabel: UILabel!
    @IBOutlet weak var totalRevenueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
