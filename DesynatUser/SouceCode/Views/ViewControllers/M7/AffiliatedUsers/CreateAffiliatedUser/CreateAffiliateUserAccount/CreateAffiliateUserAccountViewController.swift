//
//  CreateAffiliateUserAccountViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit
import SDWebImage

class CreateAffiliateUserAccountViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var uploadDocumentSecondImageView: CustomImageView!
    @IBOutlet weak var uplaodDocumentOneImageView: CustomImageView!
    @IBOutlet weak var profilePicImageView: CustomImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var txtCreatePassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var termsAndConditionsButton: CustomButton!
    @IBOutlet weak var policiesButton: CustomButton!
    
    // MARK: - Property Decalaration
    var isTermsAccepted: Bool = false
    var selectedImage: UIImage?
    var selectedImageDoc1: UIImage?
    var selectedImageDoc2: UIImage?
    lazy private var viewModel = CreateAffiliateUserAccountViewModel(hostVC: self)
    var profileImage = ""
    var uplaodDocuOneImage = ""
    var uploadDocTwoImage = ""
    var countryCode: String = "+965"
    var iscomingAfterDocumnetReject: Bool = false
    var affiliatedUserDetails: AffiliateCreateAccountDataModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCountryCode.text = countryCode
        mobileTextField.delegate = self
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        viewModel.countryListApi()
        if iscomingAfterDocumnetReject {
            getUserData()
        }else {
            emailTextField.isUserInteractionEnabled = true
            txtCountryCode.isUserInteractionEnabled = true
            mobileTextField.isUserInteractionEnabled = true
            countryCodeButton.isUserInteractionEnabled = true
        }
        termsAndConditionsButton.setTitle("Terms & Conditions".localiz(), for: .normal)
        policiesButton.setTitle("Policies".localiz(), for: .normal)
    }
    
    // MARK: - Button's Action
    @IBAction func conitnueDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            if iscomingAfterDocumnetReject {
                viewModel.documentReupload()
            } else {
                viewModel.signUpApi()
            }
        }
    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
           let loginVC = navController.viewControllers.first(where: { $0 is AffiliatedUserLoginViewController }) {
            navController.popToViewController(loginVC, animated: true)
        } else {
            let vc = AffiliatedUserLoginViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnTapCreatePasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtCreatePassword.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnTapConfirmPasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtConfirmPassword.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func btnTapCountryCode(_ sender: UIButton) {
//        let countryNames = viewModel.countryList.map { country -> String in
//            let name = country.name ?? ""
//            let dialCode = country.dialCode ?? ""
//            let flag = country.flag ?? "🇰🇼"
//            return "\(flag)  \(name) (\(dialCode))"
//        }
        
        let countryNames = viewModel.countryList.map { country -> String in
                    let isArabic = AppLanguageManager.shared.currentLanguage == .ar
                    let name = isArabic ? (country.nameAr ?? country.name ?? "") : (country.name ?? "")
                    let dialCode = country.dialCode ?? ""
                    let flag = country.flag ?? "🇰🇼"
                    return "\(flag)  \(name) (\(dialCode))"
                }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryList[index]
            let code = selectedCountry.dialCode ?? "+965"
            self.txtCountryCode.text = code
            self.countryCode = code
        }
    }
    
    @IBAction func uploadProfilePicDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.profileImage = imageURL.url ?? ""
                    self.selectedImage = image
                    if let url = URL(string: imageURL.url ?? "") {
                        self.profilePicImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.profilePicImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
    @IBAction func uplaoddocOneDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.uplaodDocuOneImage = imageURL.url ?? ""
                    self.selectedImageDoc1 = image
                    if let url = URL(string: imageURL.url ?? "") {
                        self.uplaodDocumentOneImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.uplaodDocumentOneImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
    @IBAction func uploadDocTwoDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.uploadDocTwoImage = imageURL.url ?? ""
                    self.selectedImageDoc2 = image
                    if let url = URL(string: imageURL.url ?? "") {
                        self.uploadDocumentSecondImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.uploadDocumentSecondImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
    @IBAction func agreeToTerms(_ sender: UIButton) {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? "selectedCheckBox" : "unslectedCheckbox"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func policiesAction(_ sender: Any) {
        let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
        vc.comingReason = .termsAndConditions
        vc.comingUserRole = .affilaiteUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termsAndConditionAction(_ sender: Any) {
        let vc = CMSViewController.instantiate(fromAppStoryboard: .DashBoard)
        vc.comingReason = .termsAndConditions
        vc.comingUserRole = .affilaiteUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Function's declaration
    func getUserData() {
        fullNameTextField.text = affiliatedUserDetails?.fullName
        mobileTextField.text = affiliatedUserDetails?.mobile
        countryCode = affiliatedUserDetails?.countryCode ?? "+965"
        txtCountryCode.text = affiliatedUserDetails?.countryCode
        emailTextField.text = affiliatedUserDetails?.email
        emailTextField.isUserInteractionEnabled = false
        txtCountryCode.isUserInteractionEnabled = false
        mobileTextField.isUserInteractionEnabled = false
        countryCodeButton.isUserInteractionEnabled = false
        if let imageUrl = affiliatedUserDetails?.profileImage,
           let url = URL(string: imageUrl) {
            profileImage = affiliatedUserDetails?.profileImage ?? ""
            profilePicImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profilePicImageView.sd_imageIndicator?.startAnimatingIndicator()
            profilePicImageView.sd_setImage(with: url, placeholderImage: nil) { [weak self] image, _, _, _ in
                guard let self = self else { return }
                self.selectedImage = image
            }
        } else {
            profilePicImageView.image = UIImage(named: "profilePic")
            selectedImage = nil
        }
        
        if let imageUrl = affiliatedUserDetails?.document1,
           let url = URL(string: imageUrl) {
            uplaodDocuOneImage = affiliatedUserDetails?.document1 ?? ""
            uplaodDocumentOneImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            uplaodDocumentOneImageView.sd_imageIndicator?.startAnimatingIndicator()
            uplaodDocumentOneImageView.sd_setImage(with: url, placeholderImage: nil) { [weak self] image, _, _, _ in
                guard let self = self else { return }
                self.selectedImageDoc1 = image
            }
        } else {
            uplaodDocumentOneImageView.image = UIImage(named: "uploadDoc1")
            selectedImageDoc1 = nil
        }
        
        if let imageUrl = affiliatedUserDetails?.document2,
           let url = URL(string: imageUrl) {
            uploadDocTwoImage = affiliatedUserDetails?.document2 ?? ""
            uploadDocumentSecondImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            uploadDocumentSecondImageView.sd_imageIndicator?.startAnimatingIndicator()
            uploadDocumentSecondImageView.sd_setImage(with: url, placeholderImage: nil) { [weak self] image, _, _, _ in
                guard let self = self else { return }
                self.selectedImageDoc2 = image
            }
        } else {
            uploadDocumentSecondImageView.image = UIImage(named: "uploaddoc2")
            selectedImageDoc2 = nil
        }
        txtCreatePassword.text = affiliatedUserDetails?.passwordOld
        txtConfirmPassword.text = affiliatedUserDetails?.passwordOld
    }
    
}

//MARK: UITextFieldDelegate Methods
extension CreateAffiliateUserAccountViewController: UITextFieldDelegate {
    
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
        
        if textField == fullNameTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
