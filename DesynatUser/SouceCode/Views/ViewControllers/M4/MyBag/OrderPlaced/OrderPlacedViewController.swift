//
//  OrderPlacedViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class OrderPlacedViewController: UIViewController {

  @IBOutlet weak var deliveryDateView: UIView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    deliveryDateView.layer.cornerRadius = 10
    deliveryDateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    deliveryDateView.layer.masksToBounds = true
    }

  @IBAction func continueDidTapped(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  

}
