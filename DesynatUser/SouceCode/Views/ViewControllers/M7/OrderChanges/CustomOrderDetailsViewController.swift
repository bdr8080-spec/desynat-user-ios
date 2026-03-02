//
//  CustomOrderDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/02/26.
//

import UIKit

class CustomOrderDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var customDetailLabel: UILabel!
    
    // MARK: - Property Decalaration
    var customDetails: String?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        customDetailLabel.text = customDetails
        initialSetup()
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
