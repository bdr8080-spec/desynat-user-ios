//
//  LoginViaOTPViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LoginViaOTPViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailMobileImageView: UIImageView!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewCountryCode: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = LoginViaOTPViewModel(loginHostVC: self)
    var countryCode: String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeLabel.text = countryCode
        phoneTextField.delegate = self
        viewCountryCode.isHidden = true
        self.txtFieldLeading.constant = -65
        emailMobileImageView.image = UIImage(named: "email")
        viewModel.getALlUserCountryListApi()
    }
    
    // MARK: - Button's Action
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
        UserDefaults.standard.setValue("true", forKey:"isGuestLogin")
        kSharedSceneDelegate.navigateToUserHomeVc()
    }
    
    @IBAction func facebookDidTapped(_ sender: Any) {
//        SocialLoginManager.shared.signupWithFacebook(self) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//                self.showAlert(msg: "The user canceled the sign-in flow.".localiz())
//                return
//            }
//            guard let data = data else { return }
//            print(data)
//            let param: [String: Any] = [
//                "full_name": data["name"] as? String ?? "",
//                "device_type": 1, // 0 web 1 ios 2 android
//                "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? "",
//                "lang": AppLanguageManager.shared.currentLanguage.rawValue,
//                "unique_id": data["social_id"] as? String ?? "",
//                "socialType": 2, //1 google 2 facebook 3 apple
//                "profile_image": data["profile_image"] as? String ?? "",
//                "email": data["email"] as? String ?? ""]
//            self.viewModel.socialSignupApi(params: param)
//        }
    }
    
    @IBAction func appleDidTapped(_ sender: Any) {
        SocialLoginManager.shared.appleSignUpStatus = { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                //                    print("Apple Sign-In error: \(error.localizedDescription)")
                self.showAlert(msg: "The user canceled the sign-in flow.".localiz())
            } else if let userInfo = result {
                print("Apple User info: \(userInfo)")
                let param: [String: Any] = [
                    "full_name": userInfo["name"] as? String ?? "",
                    "device_type": 1, // 0 web 1 ios 2 android
                    "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? "",
                    "lang": AppLanguageManager.shared.currentLanguage.rawValue,
                    "unique_id": userInfo["social_id"] as? String ?? "",
                    "socialType": 3, //1 google 2 facebook 3 apple
                    "profile_image": "",
                    "email": userInfo["email"] as? String ?? ""]
                self.viewModel.socialSignupApi(params: param)
            }
        }
        SocialLoginManager.shared.signupWithApple(self)
    }
    
    @IBAction func googleDidTapped(_ sender: Any) {
        SocialLoginManager.shared.signupWithGoogle(self) { result, error in
            if let error = error {
                //                print("Google Sign-In error: \(error.localizedDescription)")
                self.showAlert(msg: error.localizedDescription.localiz())
            } else if let userInfo = result {
                print("Google User info: \(userInfo)")
                //Call api here
                let param: [String: Any] = [
                    "full_name": userInfo["name"] as? String ?? "",
                    "device_type": 1,
                    "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? "",
                    "lang": AppLanguageManager.shared.currentLanguage.rawValue,
                    "unique_id": userInfo["social_id"] as? String ?? "",
                    "socialType": 1, // 1 google 2 facebook 3 apple
                    "profile_image": userInfo["profile_image"] as? String ?? "",
                    "email": userInfo["email"] as? String ?? ""]
                self.viewModel.socialSignupApi(params: param)
            }
        }
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
            let isArabic = AppLanguageManager.shared.currentLanguage == .ar
            let name = isArabic ? (country.nameAr ?? country.name ?? "") : (country.name ?? "")
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
    
    //MARK: Function's declaration
    func setUpCountryCode(code: String) {
        self.countryCodeLabel.text = code
    }
}

//MARK: UITextFieldDelegate Methods
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
        }
        return true
    }
}
