//
//  ChangeEmailMobileViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import UIKit

class ChangeEmailMobileViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ChangeEmailMobileViewModel(hostVC: self)
    var comingToUpdateMobile: Bool = false
    var countryCode:String = "+965"
    var changesAreDone: (() -> Void)?
    var affiliatedUserProfile: AffiliateCreateAccountDataModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        if comingToUpdateMobile {
            viewModel.countryListApi()
            countryCode = affiliatedUserProfile?.countryCode ?? "+965"
            txtCountryCode.text = affiliatedUserProfile?.countryCode ?? "+965"
            txtMobileNumber.text = affiliatedUserProfile?.mobile ?? ""
        } else {
            txtEmail.text = affiliatedUserProfile?.email ?? ""
        }
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.changeMobileNumberAndEmailApi()
        }
    }
    
    @IBAction func btnTapCountryCode(_ sender: UIButton) {
        let countryNames = viewModel.countryList.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }
        
        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryList[index]
            let code = selectedCountry.dialCode ?? "+965"
            self.setUpCountryCode(code: code)
            self.countryCode = code
        }
    }
    
    //MARK: Function's declaration
     private func setUpCountryCode(code: String) {
        self.txtCountryCode.text = code
    }
    
    func initialSetup() {
        if comingToUpdateMobile {
            titleLabel.text = "Enter New Mobile Number"
            descriptionLabel.text = "Great! now enter the mobile number that you\nwant to continue with"
            emailView.isHidden = true
            mobileView.isHidden = false
        } else {
            titleLabel.text = "Enter New Email "
            descriptionLabel.text = "Great! now enter the email address that you\nwant to continue with"
            emailView.isHidden = false
            mobileView.isHidden = true
        }
    }
}

//MARK: UITextFieldDelegate Methods
extension ChangeEmailMobileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if updatedText.hasPrefix(" ") {
            return false
        }
        var validation: StringValidation?
        if textField == txtEmail {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        else if textField == txtMobileNumber {
            validation = StringValidation(string: updatedText, characterCount: 15, validation: .mobileNo)
        }
        if let validation = validation {
            return validation.validate()
        }
        return true
    }
}

