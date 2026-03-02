//
//  RegisterationSuccessViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class RegisterationSuccessViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Property Decalaration
    var comingReason: ComingReasonAtRegisterationSuccess = .passwordUpdated
    var callBackDismiss: (()->())?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dismiss(animated: true) {
                self.callBackDismiss?()
            }
        }
    }
    
    func initialSetup() {
        switch comingReason {
        case .passwordUpdated:
            descriptionLabel.text = "Password Reset\nsuccessfully!"
        case .accountCreated:
            descriptionLabel.text = "Thank you for sinning up\nwith DESYNAT"
        case .changePassword:
            descriptionLabel.text = "Password changed successfully!"
        case .changeMobileNumber:
            descriptionLabel.text = "Mobile Number Changed\nsuccessfully !"
        case .changeEmailAddress:
            descriptionLabel.text = "Email Address Changed\nsuccessfully !"
        case .giftCardPurchased:
            descriptionLabel.text = "Gift card purchased\nsuccessfully!"
        case .quotationSentForCustomization:
            descriptionLabel.text = "Request sent\nsuccessfully!"
        case .amountAddeddToWallet:
            descriptionLabel.text = "Amount added\nsuccessfully!"
        case .giftCardRedeemed:
            descriptionLabel.text = "Gift Card Redeemed\nsuccessfully!"
        case .changePasswordForAffiliatedUser:
            descriptionLabel.text = "Password changed successfully!"
        case .amountAddedIntoWalletForAffiliatedUser:
            descriptionLabel.text = "Request sent successfully!"
        }
    }
    
}

enum ComingReasonAtRegisterationSuccess {
    case passwordUpdated
    case accountCreated
    case changePassword
    case changeMobileNumber
    case changeEmailAddress
    case giftCardPurchased
    case quotationSentForCustomization
    case amountAddeddToWallet
    case giftCardRedeemed
    case changePasswordForAffiliatedUser
    case amountAddedIntoWalletForAffiliatedUser
}
