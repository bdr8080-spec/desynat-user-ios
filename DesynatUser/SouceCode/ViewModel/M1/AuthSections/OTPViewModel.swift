//
//  OTPViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 30/10/25.
//

import Foundation
import UIKit

class OTPViewModel: NSObject {
    private var hostVC: OTPViewController
    
    init(hostVC: OTPViewController) {
        self.hostVC = hostVC
    }
    
    func verifyOtpAPI(type: String) {
        let params: [String: Any] = [
            "user_id": hostVC.userId,
            "otp": hostVC.otpDigits,
            "type": type
        ]
        
        WebService.sharedInstance.verifyOTPService(withParams: params) { otp in
            switch self.hostVC.comingReason {
            case .signup:
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .accountCreated
                vc.callBackDismiss = {
                    kSharedSceneDelegate.navigateToUserHomeVc()
                    UserDefaults.standard.setValue("Yes", forKey:"isLogin")
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            case .loginViaOTP:
                CommonUtils.showToast(message: "Login Successfully")
                kSharedSceneDelegate.navigateToUserHomeVc()
                UserDefaults.standard.setValue("Yes", forKey:"isLogin")
            case .forgotPassword:
                let vc = ResetPasswordViewController.instantiate(fromAppStoryboard: .Main)
                vc.userId = self.hostVC.userId
                self.hostVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func resendOtpAPI() {
        var params: [String: Any] = ["email_mobile": hostVC.phoneNumber ?? ""]
        if hostVC.isEnteredPhoneNumber {
            params["country_code"] = hostVC.countryCode
            params["type"] = "0"
        } else {
            params["type"] = "1"
        }
    
        WebService.sharedInstance.resendOTPService(withParams: params){ otp in
            
        }
    }
}
