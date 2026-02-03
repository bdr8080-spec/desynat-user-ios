//
//  CustomOrderDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/02/26.
//

import UIKit

class CustomOrderDetailsViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var customDetailLabel: UILabel!
    
    var customDetails: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customDetailLabel.text = customDetails
        initialSetup()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func initialSetup() {
      titleView.clipsToBounds = true
      titleView.layer.cornerRadius = 32
      titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
