//
//  AccountCreationDoneViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class AccountCreationDoneViewController: UIViewController {
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Button's Action
    @IBAction func logoutDidTapped(_ sender: Any) {
        logoutApi()
    }
    
}

extension AccountCreationDoneViewController{
    func logoutApi(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
