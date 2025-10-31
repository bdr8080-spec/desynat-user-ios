//
//  SignupViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var isTermsAccepted: Bool = false
    var selectedImage: UIImage?
    lazy private var viewModel = SignupViewModel(hostVC: self)
    var countryCode: String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    var selectedProfileImageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTextField.delegate = self
        emailTextField.delegate = self
    }
    
    @IBAction func conitnueDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.signupApi()
        }
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
    
    @IBAction func acceptTermsDidTapped(_ sender: UIButton) {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? "selectedCheckBox" : "unslectedCheckbox"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func termsDidTapped(_ sender: Any) {
    }
    
    @IBAction func policiesDidTapped(_ sender: Any) {
    }
    
    @IBAction func uploadProfilePicDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.selectedImage = image
            }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedProfileImageUrl = uploadedUrl
                }
            }
        }
    }
    
    @IBAction func createPasswordDidTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        createPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func confirmPasswordEyeDidTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func countryCodeDidTapped(_ sender: Any) {
        CommonUtils.openPicker(controller: self) { code, name, callingCode in
            self.setUpCountryCode(code: callingCode)
            self.countryCode = callingCode
        }
    }
    
    func setUpCountryCode(code: String) {
        self.countryCodeTextField.text = code
    }
    
}


extension SignupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Safely unwrap the current text
        guard let currentText = textField.text else { return true }
        
        // Construct the updated text after the change
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Prevent leading space
        if updatedText.hasPrefix(" ") {
            return false
        }
        
        var validation: StringValidation?
        
        // Validate email
        if textField == emailTextField {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        // Validate mobile number
        else if textField == mobileTextField {
            validation = StringValidation(string: updatedText, characterCount: 15, validation: .mobileNo)
        }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
