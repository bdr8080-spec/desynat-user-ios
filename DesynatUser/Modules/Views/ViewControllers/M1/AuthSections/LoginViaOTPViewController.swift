//
//  LoginViaOTPViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LoginViaOTPViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signupDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
               let signupVC = navController.viewControllers.first(where: { $0 is SignupViewController }) {
                navController.popToViewController(signupVC, animated: true)
            } else {
                let vc = SignupViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .loginViaOTP
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginViaPasswordDidTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: LoginViewController.self, animated: false)
    }
    
    @IBAction func continueAsGuestDidTapped(_ sender: Any) {
        kSharedSceneDelegate.navigateToUserHomeVc()
    }
    
    
    @IBAction func facebookDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func appleDidTapped(_ sender: Any) {
    }
    
    @IBAction func googleDidTapped(_ sender: Any) {
    }
}
