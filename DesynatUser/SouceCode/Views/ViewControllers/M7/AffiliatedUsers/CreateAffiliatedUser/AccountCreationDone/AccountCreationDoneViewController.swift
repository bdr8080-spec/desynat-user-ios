//
//  AccountCreationDoneViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class AccountCreationDoneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func logoutDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
            guard let self = self else { return }
            logoutApi()
        }
    }
    
}

extension AccountCreationDoneViewController{
    func logoutApi(){
//        WebService.sharedInstance.logoutService { user in
//            kSharedSceneDelegate.logoutUser()
            self.navigationController?.popToRootViewController(animated: true)
//        }
    }
}
