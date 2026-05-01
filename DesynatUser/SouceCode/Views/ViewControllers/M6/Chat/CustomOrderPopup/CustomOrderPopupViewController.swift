//
//  CustomOrderPopupViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 13/01/26.
//

import UIKit

class CustomOrderPopupViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var customDetailsTextView: UITextView!
    @IBOutlet weak var deliveryAddressTF: UILabel!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Property Decalaration
    var uniqueId: String? = ""
    var deliveryAddressId: Int? = 0
    var requestIsSent: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        quantityTF.delegate = self
    }
    
    // MARK: - Button's Action
    @IBAction func changeDidTapped(_ sender: Any) {
        let nextVC = SavedAddressViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.comingFromBag = true
        nextVC.navigationItem.hidesBackButton = true
        nextVC.onAddressSelected = { [weak self] selectedAddress in
            guard let self = self else { return }
            self.deliveryAddressId = selectedAddress.id ?? 0
            let addressLine = [
                selectedAddress.houseNo,
                selectedAddress.streetNo,
                selectedAddress.city,
                selectedAddress.state,
                selectedAddress.countryName,
                selectedAddress.postalCode
            ]
                .compactMap { $0 }
                .joined(separator: ", ")
            self.deliveryAddressTF.text = addressLine
            // Restore navigation bar before coming back
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.popViewController(animated: true)
        }
        // Hide navigation bar to remove top space
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendRequestDidTapped(_ sender: Any) {
        if validateFields() {
            sendCustomOrderRequest()
        }
    }
    
    //MARK: Function's declaration
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    func sendCustomOrderRequest(){
        let param: [String: Any] = ["unique_id": uniqueId ?? "",
                                    "quantity": quantityTF.text?.trimmed() ?? "",
                                    "custom_details": customDetailsTextView.text.trimmed()]//,
        // "delivery_address": deliveryAddressId ?? ""]
        WebService.sharedInstance.sendCustomOrderRequest(param: param) { [self] list in
            DispatchQueue.main.async {
                let successVC = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                successVC.comingReason = .quotationSentForCustomization
                successVC.callBackDismiss = { [weak self] in
                    self?.requestIsSent?()
                    self?.dismiss(animated: true)
                }
                self.present(successVC, animated: true)
            }
        }
    }
    
    func validateFields() -> Bool {
        
        // Quantity
        guard let quantity = quantityTF.text?.trimmingCharacters(in: .whitespaces),
              !quantity.isEmpty else {
            showAlert(msg: "Please enter quantity".localiz())
            quantityTF.becomeFirstResponder()
            return false
        }
        
        // Custom details
        guard let details = customDetailsTextView.text?.trimmingCharacters(in: .whitespaces),
              !details.isEmpty else {
            showAlert(msg: "Please enter custom details".localiz())
            customDetailsTextView.becomeFirstResponder()
            return false
        }
        
        return true
    }
}

//MARK: UITextFieldDelegate Methods
extension CustomOrderPopupViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        // Allow only numbers
        if !string.isEmpty && !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        // Max 7 digits
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return updatedText.count <= 7
    }
}
