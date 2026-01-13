//
//  CustomOrderDetailsPopupViewController.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import UIKit

class CustomOrderDetailsPopupViewController: UIViewController {
    
    @IBOutlet weak var customDetailsLabel: UILabel!
    @IBOutlet weak var addressLAbel: UILabel!
    @IBOutlet weak var tottalQuantityLAbel: UILabel!
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
    }
    
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}
