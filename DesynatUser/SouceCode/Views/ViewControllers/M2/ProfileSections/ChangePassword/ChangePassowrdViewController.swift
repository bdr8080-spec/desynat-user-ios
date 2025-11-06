//
//  ChangePassowrdViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ChangePassowrdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .changePassword
        vc.callBackDismiss = {
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.present(vc, animated: true)
    }
    
}
