//
//  UseGiftCardsViewController.swift
//  DesynatUser
//
//  Created by fluper on 04/12/25.
//

import UIKit

class UseGiftCardsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var pinTF: UITextField!
    
    // MARK: - Property Decalaration
    var onRedeem: ((_ cardNumber: String, _ pin: String, _ giftCard: UseGiftCardDataModel) -> Void)?
    private lazy var viewModel = UseGiftCardViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberTF.delegate = self
        pinTF.delegate = self
    }
    
    // MARK: - Button's Action
    @IBAction func redeemDidTapped(_ sender: Any) {
        guard let cardNumber = cardNumberTF.text, !cardNumber.isEmpty else {
            showAlert(msg: "Please enter 16 Digit gift card number")
            return
        }
        guard let pin = pinTF.text, !pin.isEmpty else {
            showAlert(msg: "Please enter PIN")
            return
        }
        viewModel.addGiftCardApi(cardNumber: cardNumber, giftCardPin: pin)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UseGiftCardsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.contains(" ") { return false }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let isNumeric = updatedText.allSatisfy { $0.isNumber }
        if !isNumeric { return false }
        if textField == cardNumberTF {
            return updatedText.count <= 16
        } else if textField == pinTF {
            return updatedText.count <= 4
        }
        return true
    }
}
