//
//  BecomeAnAffiliatedUserViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class BecomeAnAffiliatedUserViewController: UIViewController {
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func existingUserDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func newUserDidTapped(_ sender: Any) {
    }
}
