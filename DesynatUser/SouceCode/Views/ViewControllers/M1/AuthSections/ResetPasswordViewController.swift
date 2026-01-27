//
//  ResetPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    lazy private var viewModel = ResetPasswordViewModel(hostVC: self)
    var userId: String? = ""
    var comingUserRole: UserType = .normalUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordTextField.delegate = self
        createPasswordTextField.delegate = self
    }
    
    @IBAction func doneDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            switch comingUserRole {
            case .normalUser:
                viewModel.resetPasswordOTPApi()
            case .affiliateUser:
                viewModel.resetPasswordOTPApiForAffiliatedUser()
            }
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTapCreatePasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        createPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnTapConfirmPasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
}
