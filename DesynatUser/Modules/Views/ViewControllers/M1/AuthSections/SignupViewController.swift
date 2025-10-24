//
//  SignupViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func conitnueDidTapped(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .signup
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signInDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
               let loginVC = navController.viewControllers.first(where: { $0 is LoginViewController }) {
                navController.popToViewController(loginVC, animated: true)
            } else {
                let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func continueAsGuestDidTapped(_ sender: Any) {
        kSharedSceneDelegate.navigateToUserHomeVc()
    }
    
}
