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
                    UserDefaults.standard.setValue("Yes", forKey:"isLogin")
                    UserDefaults.standard.setValue("false", forKey:"isGuestLogin")
                    kSharedSceneDelegate.navigateToUserHomeVc()
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            case .loginViaOTP:
                CommonUtils.showToast(message: "Login Successfully")
                UserDefaults.standard.setValue("Yes", forKey:"isLogin")
                UserDefaults.standard.setValue("false", forKey:"isGuestLogin")
                kSharedSceneDelegate.navigateToUserHomeVc()
            case .forgotPassword:
                let vc = ResetPasswordViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingUserRole = .normalUser
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
            case .forgotPasswordForAffiliatedUser:
                print("api called")
            case .accountCreateAffiliateUser:
                print("api called")
            case .loginViaOTPForAffiliatedUser:
                print("api called")
            case .changeOldMobileNumberForAffiliatedUser:
                print("api called")
            case .changeOldEmailNumberForAffiliatedUser:
                print("api called")
            case .setNewMobileNumberForAffiliatedUser:
                print("api called")
            case .setNewEmailForAffiliatedUser:
                print("api called")
            }
        }
    }
    
    
    func verifyAffiliatedAccountService(type: String) {
        let params: [String: Any] = [
            "id": hostVC.userId,
            "otp": hostVC.otpDigits,
            "type": type]
        WebService.sharedInstance.verifyAffiliatedAccountService(param: params) { response in
            kSharedUserDefaults.saveStringFor(Key: .affiliatedAccessToken, value: String.getString(response.affiliatedAccessToken))
            switch self.hostVC.comingReason {
            case .accountCreateAffiliateUser:
                let nextVC = AffiliatedUserAddressAdditionViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
            case .loginViaOTPForAffiliatedUser:
                if response.addressUpdateStatus == "0" {
                    let nextVC = AffiliatedUserAddressAdditionViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                    self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
                } else if response.bankUpdateStatus == "0" {
                    let nextVC = AddBankDetailsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                    self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
                } else if response.adminVerify == "2" {
                    kSharedUserDefaults.saveModelFor(key: .affiliatedUserDeatils, value: response)
                    UserDefaults.standard.setValue("true", forKey: "affiliatedAccountIsLoggedIn")
                    kSharedSceneDelegate.navigateToAffiliatedUserHomeVc()
                } else if response.adminVerify == "4" {
                    //                    self.hostVC.showAlert(msg: "Document Rejected. Please Reupload it.")
                    self.hostVC.showAlert(msg: "\("Document Rejected. Please Reupload it.\n".localiz())\(response.rejectReason ?? "")")
                    let nextVC = CreateAffiliateUserAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                    nextVC.iscomingAfterDocumnetReject = true
                    nextVC.affiliatedUserDetails = response
                    self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
                }else {
                    let nextVC = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                    self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
                }
                
            case .forgotPasswordForAffiliatedUser:
                let vc = ResetPasswordViewController.instantiate(fromAppStoryboard: .Main)
                vc.userId = self.hostVC.userId
                vc.comingUserRole = .affiliateUser
                self.hostVC.navigationController?.pushViewController(vc, animated: true)
            default:
                print("")
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
    
    func resendOtpAPIForAffiliatedUser() {
        var params: [String: Any] = ["email_mobile": hostVC.phoneNumber ?? ""]
        if hostVC.isEnteredPhoneNumber {
            params["country_code"] = hostVC.countryCode
            params["type"] = "0"
        } else {
            params["type"] = "1"
        }
        WebService.sharedInstance.resendOTPServiceForAffiliatedUser(withParams: params){ otp in
            
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
    
    func verifyOtpApiForChangeEmailAndMobileAffiliatedUser(){
        let param:[String:Any] = [
            "id":self.hostVC.id,
            "otp":self.hostVC.otpDigits]
        
        WebService.sharedInstance.userVerifyOtpForAffiliateUserService(withParams:param) { user in
            if self.hostVC.comingReason == .changeOldMobileNumberForAffiliatedUser{
                let vc = ChangeEmailMobileViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                vc.countryCode = user.countryCode ?? ""
                vc.comingToUpdateMobile = true
                self.hostVC.navigationController?.pushViewController(vc, animated: false)
            }else if self.hostVC.comingReason == .changeOldEmailNumberForAffiliatedUser{
                let vc = ChangeEmailMobileViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                vc.comingToUpdateMobile = false
                self.hostVC.navigationController?.pushViewController(vc, animated: false)
            }else if self.hostVC.comingReason == .setNewMobileNumberForAffiliatedUser{
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .changeMobileNumber
                vc.callBackDismiss = {
                    if let navController = self.hostVC.navigationController {
                        for controller in navController.viewControllers {
                            if let profileVC = controller as? AffiliatedProfileDetailsViewController {
                                //                                profileVC.mobile = user.mobile
                                //                                profileVC.countryCode = user. ?? ""
                                profileVC.comingAfterUpdate = true
                                navController.popToViewController(profileVC, animated: true)
                                break
                            }
                        }
                    }
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }else if self.hostVC.comingReason == .setNewEmailForAffiliatedUser{
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .changeEmailAddress
                vc.callBackDismiss = {
                    if let navController = self.hostVC.navigationController {
                        for controller in navController.viewControllers {
                            if let profileVC = controller as? AffiliatedProfileDetailsViewController {
                                //                                profileVC.email = user.email
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
