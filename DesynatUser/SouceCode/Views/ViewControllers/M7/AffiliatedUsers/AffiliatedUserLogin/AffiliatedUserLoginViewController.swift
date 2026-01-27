//
//  AffiliatedUserLoginViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class AffiliatedUserLoginViewController: UIViewController {

    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailMobileImageView: UIImageView!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewCountryCode: UIView!
    
    private lazy var viewModel = AffiliatedUserLoginViewModel(loginHostVC: self)
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
        vc.comingUserRole = .affiliateUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
               let signupVC = navController.viewControllers.first(where: { $0 is CreateAffiliateUserAccountViewController }) {
                navController.popToViewController(signupVC, animated: true)
            } else {
                let vc = CreateAffiliateUserAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func loginViaOTPDidTapped(_ sender: Any) {
        let vc = LoginViaOTPAffilatedUserViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func switchToUserDidTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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

