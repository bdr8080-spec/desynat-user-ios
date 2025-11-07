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
            case .changeOldMobileNumber:
                print("api called")
            case .changeOldEmail:
                print("api called")
            case .setNewMobileNumber:
                print("api called")
            case .setNewEmail:
                print("api called")
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
    
    func userVerifyOtpApi(){
        let param:[String:Any] = [
            "id":self.hostVC.id,
            "otp":self.hostVC.otpDigits
        ]
        WebService.sharedInstance.userVerifyOtpService(withParams:param) { user in
            if self.hostVC.comingReason == .changeOldMobileNumber{
                let vc = ChangeMobileViewController.instantiate(fromAppStoryboard: .Profile)
                vc.countryCode = user.countryCode ?? ""
                vc.comingToUpdateMobile = true
                self.hostVC.navigationController?.pushViewController(vc, animated: false)
            }else if self.hostVC.comingReason == .changeOldEmail{
                let vc = ChangeMobileViewController.instantiate(fromAppStoryboard: .Profile)
                vc.comingToUpdateMobile = false
                self.hostVC.navigationController?.pushViewController(vc, animated: false)
            }else if self.hostVC.comingReason == .setNewMobileNumber{
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .changeMobileNumber
                vc.callBackDismiss = {
//                    self.hostVC.callBackForProfileDetails?(user.mobile ?? "",user.countryCode ?? "","")
//                    print("user.mobile:\(user.mobile ?? "")")
//                    print("user.countryCode:\(user.countryCode ?? "")")
//                    self.hostVC.navigationController?.popToViewController(ofClass: ProfileDetailsViewController.self, animated: true)
                    if let navController = self.hostVC.navigationController {
                        for controller in navController.viewControllers {
                            if let profileVC = controller as? ProfileDetailsViewController {
                                profileVC.mobile = user.mobile
                                profileVC.countryCode = user.countryCode ?? ""
                                profileVC.comingAfterUpdate = true
                                navController.popToViewController(profileVC, animated: true)
                                break
                            }
                        }
                    }

                  //  self.hostVC.callBackForProfileDetails?(user.mobile ?? "",user.countryCode ?? "","")
                    

                    
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }else if self.hostVC.comingReason == .setNewEmail{
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .changeEmailAddress
                vc.callBackDismiss = {
                    if let navController = self.hostVC.navigationController {
                        for controller in navController.viewControllers {
                            if let profileVC = controller as? ProfileDetailsViewController {
                                profileVC.email = user.email
                                profileVC.comingAfterUpdate = true
                                navController.popToViewController(profileVC, animated: true)
                                break
                            }
                        }
                    }
                    
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }
        }
    }
    
    
}
