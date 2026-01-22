//
//  ChangePassowrdViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ChangePassowrdViewController: UIViewController {
    private lazy var viewModel = ChangePassowrdViewModel(hostVC:self)
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
//        if txtOldPassword.text == ""{
//            showAlert(msg:"Please enter old password")
//        }else if txtNewPass.text == ""{
//            showAlert(msg:"Please enter new password")
//        }else if txtConfirmPass.text == ""{
//            showAlert(msg:"Please enter confirm password")
//        }else{
//            viewModel.changePasswordApi()
//        }
        
        guard let oldPassword = txtOldPassword.text, !oldPassword.isEmpty else {
                showAlert(msg: "Please enter old password")
                return
            }

            guard let newPassword = txtNewPass.text, !newPassword.isEmpty else {
                showAlert(msg: "Please enter new password")
                return
            }
        
        // Password format validation
        if !newPassword.isValidPassword() {
            showAlert(msg: "Password must be at least 8 characters long and contain letters and digits")
            return
        }

            guard let confirmPassword = txtConfirmPass.text, !confirmPassword.isEmpty else {
                showAlert(msg: "Please enter confirm password")
                return
            }

            // Match new & confirm password
            if newPassword != confirmPassword {
                showAlert(msg: "Passwords do not match")
                return
            }

            viewModel.changePasswordApi()
    }
    
    @IBAction func btnTapEyeOldPass(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtOldPassword.isSecureTextEntry = false
        }else{
            txtOldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnTapEyeNewPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtNewPass.isSecureTextEntry = false
        } else{
            txtNewPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnTapEyeConfirmPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtConfirmPass.isSecureTextEntry = false
        }else{
            txtConfirmPass.isSecureTextEntry = true
        }
    }
    
}
