//
//  LoginViewController.swift
//  DesynatUser
//  Created by Rakhi Kumari on 23/10/25.


import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailMobileImageView: UIImageView!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewCountryCode: UIView!
    
    private lazy var viewModel = LoginViewModel(loginHostVC: self)
    var countryCode: String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.getALlUserCountryListApi()
        countryCodeLabel.text = countryCode
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        emailTextField.delegate = self
        viewCountryCode.isHidden = true
        self.txtFieldLeading.constant = -65
        emailMobileImageView.image = UIImage(named: "email")
    }
    

    @IBAction func loginDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.loginApi()
        }
    }
    
    @IBAction func forgotPasswordDidTapped(_ sender: Any) {
        let vc = ForgotPasswordViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingUserRole = .normalUser
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func loginViaOTPDidTapped(_ sender: Any) {
        let vc = LoginViaOTPViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func continueAsGuestDidTapped(_ sender: Any) {
        UserDefaults.standard.setValue("true", forKey:"isGuestLogin")
        kSharedSceneDelegate.navigateToUserHomeVc()
    }
    
    @IBAction func facebookDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func appleDidTapped(_ sender: Any) {
    }
    
    @IBAction func googleDidTapped(_ sender: Any) {
    }
    
    @IBAction func btnTapEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
      let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
          let name = country.name ?? ""
          let dialCode = country.dialCode ?? ""
          let flag = country.flag1 ?? "🇰🇼"
          return "\(flag)  \(name) (\(dialCode))"
      }

      kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
          let selectedCountry = self.viewModel.getAllUSerCountryList[index]
          let code = selectedCountry.dialCode ?? "+965"
         
        self.setUpCountryCode(code: code)
          self.countryCode = code
      }
    }
    
    func setUpCountryCode(code: String) {
        self.countryCodeLabel.text = code
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if currentText.hasPrefix(" ") {
            return false
        }
        
        var validation: StringValidation?
        
        if textField == self.emailTextField {
            if currentText.hasPrefix(" ") {
                return false
            }
            
            if !currentText.isNumber() {
                self.viewCountryCode.isHidden = true
                emailMobileImageView.image = UIImage(named: "email")
                self.txtFieldLeading.constant = -65
                validation = StringValidation(string: currentText, characterCount: 65, validation: .emailId)
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
        }else if textField == passwordTextField{
            validation = StringValidation(string: currentText, characterCount:30, validation: .password)
        }
        return true
    }
}
