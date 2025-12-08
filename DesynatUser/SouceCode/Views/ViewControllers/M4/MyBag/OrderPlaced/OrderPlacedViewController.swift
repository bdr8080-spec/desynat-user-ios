//
//  OrderPlacedViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class OrderPlacedViewController: UIViewController {
  
  @IBOutlet weak var addressDescriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var amountPaidLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateView: UIView!
  
  var orderId: String? = ""
  lazy var viewModel = OrderPlacedViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getOrderSummary()
    deliveryDateView.layer.cornerRadius = 10
    deliveryDateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    deliveryDateView.layer.masksToBounds = true
  }
  
  @IBAction func continueDidTapped(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  func configData(data: OrderSummaryDataModel?) {
    deliveryDateLabel.text = data?.createdAt
    amountPaidLabel.text = "\(data?.totalAmount ?? "") KD"
    locationLabel.text = data?.deliveryDetails?.name
    let selectedAddress = data?.deliveryDetails
    let addressLine = "\(selectedAddress?.houseNo ?? ""), \(selectedAddress?.streetNo ?? ""), \(selectedAddress?.city ?? ""), \(selectedAddress?.state ?? ""), \(selectedAddress?.countryName ?? "")-\(selectedAddress?.postalCode ?? "")"
    addressDescriptionLabel.text = addressLine
  }
  
}
