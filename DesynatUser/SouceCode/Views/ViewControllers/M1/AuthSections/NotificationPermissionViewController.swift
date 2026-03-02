//
//  NotificationPermissionViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class NotificationPermissionViewController: UIViewController {
    
    // MARK: - Property Decalaration
    var onPermissionCompletion: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Button's Action
    @IBAction func allowDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
    @IBAction func denyDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
}
