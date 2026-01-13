//
//  CustomOrderPopupViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 13/01/26.
//

import UIKit

class CustomOrderPopupViewController: UIViewController {

    @IBOutlet weak var customDetailsTextView: UITextView!
    @IBOutlet weak var deliveryAddressTF: UILabel!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleUISetup()
      }
      
    @IBAction func changeDidTapped(_ sender: Any) {
    }
    
      @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
      }
    
    @IBAction func sendRequestDidTapped(_ sender: Any) {
    }
    
      private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
      }

}
