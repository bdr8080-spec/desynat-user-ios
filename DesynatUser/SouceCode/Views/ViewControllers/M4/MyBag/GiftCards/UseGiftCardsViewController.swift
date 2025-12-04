//
//  UseGiftCardsViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class UseGiftCardsViewController: UIViewController {

  @IBOutlet weak var cardNumberTF: UITextField!
  @IBOutlet weak var pinTF: UITextField!
  
  var onRedeem: ((_ cardNumber: String, _ pin: String) -> Void)?
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  @IBAction func redeemDidTapped(_ sender: Any) {
    guard let cardNumber = cardNumberTF.text, !cardNumber.isEmpty else {
                showAlert(msg: "Please enter 16 Digit card number")
                return
            }
            
            guard let pin = pinTF.text, !pin.isEmpty else {
                showAlert(msg: "Please enter PIN")
                return
            }
            
            // Pass data back via closure
            onRedeem?(cardNumber, pin)
            
            // Go back
            navigationController?.popViewController(animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
