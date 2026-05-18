//
//  LoginViaOTPAffilatedUserViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class LoginViaOTPAffilatedUserViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailMobileImageView: UIImageView!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewCountryCode: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var switchUserButton: CustomButton!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = LoginViaOTPAffiliatedUserViewModel(loginHostVC: self)
    var countryCode: String = "+965"
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeLabel.text = countryCode
        phoneTextField.delegate = self
        viewCountryCode.isHidden = true
        self.txtFieldLeading.constant = -65
        emailMobileImageView.image = UIImage(named: "email")
        viewModel.getALlUserCountryListApi()
        switchUserButton.setTitle("Switch to User".localiz(), for: .normal)
    }
    
    // MARK: - Button's Action
    @IBAction func signupDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
           let signupVC = navController.viewControllers.first(where: { $0 is CreateAffiliateUserAccountViewController }) {
            navController.popToViewController(signupVC, animated: true)
        } else {
            let vc = CreateAffiliateUserAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.loginViaOTPApi()
        }
    }
    
    @IBAction func loginViaPasswordDidTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: AffiliatedUserLoginViewController.self, animated: false)
    }
    
    @IBAction func swithToUserDidTapped(_ sender: Any) {
        kSharedSceneDelegate.navigateToUserHomeVc(selectedIndex: 4)
    }
    
    @IBAction func countryDidTapped(_ sender: UIButton) {
        let countryNames = viewModel.getAllUSerCountryList.map { country -> String in
                    let isArabic = AppLanguageManager.shared.currentLanguage == .ar
                    let name = isArabic ? (country.nameAr ?? country.name ?? "") : (country.name ?? "")
                    let dialCode = country.dialCode ?? ""
                    let flag = country.flag ?? "🇰🇼"
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
extension LoginViaOTPAffilatedUserViewController: UITextFieldDelegate {
    
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
