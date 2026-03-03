//
//  AffiliatedUserHomeViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation
import SDWebImage

class AffiliatedUserHomeViewModel {
    
    private var hostVC: AffiliatedUserHomeViewController
    
    init(hostVC: AffiliatedUserHomeViewController) {
        self.hostVC = hostVC
    }
    
    func getUserData() {
        if let userDetails: AffiliateCreateAccountDataModel = kSharedUserDefaults.retrieveModelFor(key: .affiliatedUserDeatils, model: AffiliateCreateAccountDataModel.self) {
            hostVC.usernameLabel.text = "Hi \(userDetails.fullName ?? "")"
            
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
}
