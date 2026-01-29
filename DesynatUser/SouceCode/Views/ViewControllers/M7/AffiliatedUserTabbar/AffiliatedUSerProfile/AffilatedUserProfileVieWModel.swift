//
//  AffilatedUserProfileVieWModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import Foundation
import UIKit
import SDWebImage

class AffilatedUserProfileViewModel {
    
    private var hostVC: AffiliatedUserProfileViewController
    var savedUserProfile: UserModel?
    
    init(hostVC: AffiliatedUserProfileViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        //        WebService.sharedInstance.logoutService() { (response) in
        kSharedSceneDelegate.logoutAfffiliatedUser()
        kSharedSceneDelegate.navigateToUserHomeVc()
        UserDefaults.standard.setValue("No", forKey:"affiliatedAccountIsLoggedIn")
        //        }
    }
    
        func getUserData() {
            if let userDetails: AffiliateCreateAccountDataModel = kSharedUserDefaults.retrieveModelFor(key: .affiliatedUserDeatils, model: AffiliateCreateAccountDataModel.self) {
                hostVC.usernameLabel.text = userDetails.fullName
                hostVC.emailLabel.text = userDetails.email
                hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
                (hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
                if let imageUrlString = userDetails.profileImage,
                   let url = URL(string: imageUrlString) {
                    hostVC.userProfileImageView.sd_setImage(
                        with: url,
                        placeholderImage: UIImage(named: "userProfile")
                    )
                } else {
                    hostVC.userProfileImageView.image = UIImage(named: "userProfile")
                }
            }
        }
    
    //    //Mark->:GetProfileDetailsApi
    //    func getUserData(){
    //        WebService.sharedInstance.getProfileService { savedUser in
    //            self.savedUserProfile = savedUser
    //            self.hostVC.usernameLabel.text = savedUser.fullName
    //            self.hostVC.emailLabel.text = savedUser.email
    //            self.hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
    //            (self.hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
    //            if let imageUrlString = savedUser.profileImage,
    //               let url = URL(string: imageUrlString) {
    //                self.hostVC.userProfileImageView.sd_setImage(
    //                    with: url,
    //                    placeholderImage: UIImage(named: "userProfile")
    //                )
    //            } else {
    //                self.hostVC.userProfileImageView.image = UIImage(named: "userProfile")
    //            }
    //        }
    //    }
    
    
}
