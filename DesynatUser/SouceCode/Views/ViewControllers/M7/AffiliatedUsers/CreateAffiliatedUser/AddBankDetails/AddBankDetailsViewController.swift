//
//  AddBankDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit
import SDWebImage

class AddBankDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var confirmAccountNumberTF: UITextField!
    @IBOutlet weak var accountNumberTF: UITextField!
    @IBOutlet weak var accountHolderImageView: CustomImageView!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var swiftTextField: UITextField!
    @IBOutlet weak var ibanTextField: UITextField!
    @IBOutlet weak var accountHolderTextField: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AddBankDetailsViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ibanTextField.delegate = self
        swiftTextField.delegate = self
        bankNameTextField.delegate = self
        accountHolderTextField.delegate = self
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.uploadDocumentApi()
        }
    }
    
    @IBAction func uploadProofDidTapped(_ sender: Any) {
        //        ImagePickerHelper.shared.showPickerController {  image , imageName in
        //            if let image = image {
        //                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
        //                    self.imageUploadProofDoc = imageURL.url ?? ""
        //                    self.uploadedProofDoc = image
        //                    if let url = URL(string: imageURL.url ?? "") {
        //                        self.accountHolderImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //                        self.accountHolderImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
        //                    }
        //                }
        //            }
        //        }
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AddBankDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true
        }
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == bankNameTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }
        
        if textField == accountHolderTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }
        
        if textField == ibanTextField {
            if string == " " {
                return false
            }
            if newText.count > 20 {
                return false
            }
            return true
        }
        
        if textField == swiftTextField {
            if string == " " {
                return false
            }
            return true
        }
        
        if newText.trimmingCharacters(in: .whitespaces).isEmpty && !newText.isEmpty {
            return false
        }
        
        return true
    }
}
