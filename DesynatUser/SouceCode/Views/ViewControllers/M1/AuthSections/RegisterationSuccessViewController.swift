//
//  RegisterationSuccessViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class RegisterationSuccessViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var comingReason: ComingReasonAtRegisterationSuccess = .passwordUpdated
    var callBackDismiss: (()->())?
    
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
        }
    }

}

enum ComingReasonAtRegisterationSuccess {
    case passwordUpdated
    case accountCreated
    case changePassword
    case changeMobileNumber
    case changeEmailAddress
}
