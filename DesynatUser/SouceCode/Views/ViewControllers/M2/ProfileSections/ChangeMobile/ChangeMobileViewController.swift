//
//  ChangeMobileViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ChangeMobileViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    // MARK: - Property Decalaration
    var comingToUpdateMobile: Bool = false
    var countryCode:String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    private lazy var viewModel = ChangeMobileViewModel(hostVC:self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        viewModel.getALlUserCountryListApi()
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
    
    //MARK: Function's declaration
    func setUpCountryCode(code: String) {
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
extension ChangeMobileViewController: UITextFieldDelegate {
    
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
        if textField == txtEmail {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        // Validate mobile number
        else if textField == txtMobileNumber {
            validation = StringValidation(string: updatedText, characterCount: 15, validation: .mobileNo)
        }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
