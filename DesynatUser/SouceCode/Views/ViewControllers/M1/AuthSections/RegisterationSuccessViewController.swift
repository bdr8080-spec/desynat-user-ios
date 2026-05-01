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
    
    //MARK: Function's declaration
    func initialSetup() {
        switch comingReason {
        case .passwordUpdated:
            descriptionLabel.text = "Password Reset\nsuccessfully!".localiz()
        case .accountCreated:
            descriptionLabel.text = "Thank you for sinning up\nwith DESYNAT".localiz()
        case .changePassword:
            descriptionLabel.text = "Password changed successfully!".localiz()
        case .changeMobileNumber:
            descriptionLabel.text = "Mobile Number Changed\nsuccessfully!".localiz()
        case .changeEmailAddress:
            descriptionLabel.text = "Email Address Changed\nsuccessfully!".localiz()
        case .giftCardPurchased:
            descriptionLabel.text = "Gift card purchased\nsuccessfully!".localiz()
        case .quotationSentForCustomization:
            descriptionLabel.text = "Request sent\nsuccessfully!".localiz()
        case .amountAddeddToWallet:
            descriptionLabel.text = "Amount added\nsuccessfully!".localiz()
        case .giftCardRedeemed:
            descriptionLabel.text = "Gift Card Redeemed\nsuccessfully!".localiz()
        case .changePasswordForAffiliatedUser:
            descriptionLabel.text = "Password changed successfully!".localiz()
        case .amountAddedIntoWalletForAffiliatedUser:
            descriptionLabel.text = "Request sent successfully!".localiz()
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
