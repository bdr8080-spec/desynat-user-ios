//
//  AddCardViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class AddCardViewController: UIViewController {
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
