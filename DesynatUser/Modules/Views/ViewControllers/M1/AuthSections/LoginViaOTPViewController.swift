//
//  LoginViaOTPViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LoginViaOTPViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailMobileImageView: UIImageView!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewCountryCode: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    private lazy var viewModel = LoginViaOTPViewModel(loginHostVC: self)
    var countryCode: String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeLabel.text = countryCode
        phoneTextField.delegate = self
        viewCountryCode.isHidden = true
        self.txtFieldLeading.constant = -52
        emailMobileImageView.image = UIImage(named: "email")
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
        if viewModel.validFields() {
            viewModel.loginViaOTPApi()
        }
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
    
    @IBAction func countryDidTapped(_ sender: Any) {
        CommonUtils.openPicker(controller: self) { code, name, callingCode in
            self.setUpCountryCode(code: callingCode)
            self.countryCode = callingCode
        }
    }
    
    func setUpCountryCode(code: String) {
        self.countryCodeLabel.text = code
    }
}

extension LoginViaOTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if textField == self.phoneTextField {
            if currentText.hasPrefix(" ") {
                return false
            }
            
            if !currentText.isNumber() {
                self.viewCountryCode.isHidden = true
                emailMobileImageView.image = UIImage(named: "email")
                self.txtFieldLeading.constant = -52
                validation = StringValidation(string: currentText, characterCount: 52, validation: .emailId)
            } else {
                self.viewCountryCode.isHidden = false
                emailMobileImageView.image = UIImage(named: "phone")
                self.txtFieldLeading.constant = 12
                validation = StringValidation(string: currentText, characterCount: 15, validation: .mobileNo)
            }
    
            if let data = validation {
                return data.validate()
            } else {
                return true
            }
        }
        return true
    }
}
