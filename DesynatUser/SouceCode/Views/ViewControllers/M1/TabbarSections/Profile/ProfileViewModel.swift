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
    
//    func getUserData() {
//        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
//            hostVC.usernameLabel.text = savedUser.fullName
//            hostVC.emailLabel.text = savedUser.email
//            hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
//            (hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
//            if let imageUrlString = savedUser.profileImage,
//               let url = URL(string: imageUrlString) {
//                hostVC.userProfileImageView.sd_setImage(
//                    with: url,
//                    placeholderImage: UIImage(named: "userProfile")
//                )
//            } else {
//                hostVC.userProfileImageView.image = UIImage(named: "userProfile")
//            }
//        }
//    }
    
    //Mark->:GetProfileDetailsApi
    func getUserData(){
        WebService.sharedInstance.getProfileService { savedUser in
            self.savedUserProfile = savedUser
            self.hostVC.usernameLabel.text = savedUser.fullName
            self.hostVC.emailLabel.text = savedUser.email
            self.hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            (self.hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
            if let imageUrlString = savedUser.profileImage,
               let url = URL(string: imageUrlString) {
                self.hostVC.userProfileImageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "userProfile")
                )
            } else {
                self.hostVC.userProfileImageView.image = UIImage(named: "userProfile")
            }
        }
    }

    
}
