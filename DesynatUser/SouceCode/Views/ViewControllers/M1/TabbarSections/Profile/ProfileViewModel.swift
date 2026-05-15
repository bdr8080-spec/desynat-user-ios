//
//  ProfileViewModel.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import Foundation
import UIKit
import SDWebImage

class ProfileViewModel {
    
    private var hostVC: ProfileViewController
    var savedUserProfile: UserModel?
    
    init(hostVC: ProfileViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        WebService.sharedInstance.logoutService() { (response) in
            kSharedSceneDelegate.logoutUser()
            kSharedSceneDelegate.navigateToLoginVc()
            UserDefaults.standard.setValue("No", forKey:"isLogin")
        }
    }
    
    //Mark->:GetProfileDetailsApi
    func getUserData(){
        WebService.sharedInstance.getProfileService { savedUser in
            self.savedUserProfile = savedUser
            kSharedUserDefaults.saveStringFor(Key: .savedUserCurrency, value: String.getString(savedUser.userCurrency?.currencyCode))
            kSharedUserDefaults.saveStringFor(Key: .exchangeRateOfCurrency, value: String.getString(savedUser.userCurrency?.exchangeRate))
            let fullName = savedUser.fullName?.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.hostVC.usernameLabel.text = (fullName?.isEmpty == false && fullName != "null") ? fullName : "Hello".localiz()
            let email = savedUser.email?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let email = email, !email.isEmpty, email.lowercased() != "null" {
                self.hostVC.emailLabel.isHidden = false
                self.hostVC.emailLabel.text = email
            } else {
                self.hostVC.emailLabel.isHidden = true
            }
            self.hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            (self.hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
            if let imageUrlString = savedUser.profileImage, !imageUrlString.isEmpty, imageUrlString.lowercased() != "null",
               let url = URL(string: imageUrlString) {
                self.hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile")) { [weak self] image, error, _, _ in
                    guard let self = self else { return }
                    self.hostVC.userProfileImageView.sd_imageIndicator?.stopAnimatingIndicator()
                    if error != nil || image == nil {
                        self.hostVC.userProfileImageView.image = UIImage(named: "userProfile")
                    }
                }
            } else {
                self.hostVC.userProfileImageView.sd_imageIndicator?.stopAnimatingIndicator()
                self.hostVC.userProfileImageView.image = UIImage(named: "userProfile")
            }
        }
    }
}
