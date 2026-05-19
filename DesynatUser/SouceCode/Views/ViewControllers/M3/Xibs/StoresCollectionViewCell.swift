//
//  StoresCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage

class StoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var statusView: CustomView!
    @IBOutlet weak var storyView: CustomView!
    
    var onProfileTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func configData(data: StoreListDataModel) {
        titleLabel.text = data.storeName
        if let imageUrlString = data.storeImage,
           let url = URL(string: imageUrlString) {
            
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        
        if data.storeAvailability == 1 {
            statusView.isHidden = true
        } else {
            statusView.isHidden = false
        }
        
        if let profilePics = data.sellerInformation?.profilePic,
           let url = URL(string: profilePics) {
            
            profilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profilePic.sd_imageIndicator?.startAnimatingIndicator()
            profilePic.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            profilePic.image = UIImage(named: "")
        }
        let storyCount = data.sellerHighlightsModel?.count ?? 0
        if storyCount > 0 {
            storyView.borderWidth = 1
            storyButton.isUserInteractionEnabled = true
        } else {
            storyView.borderWidth = 0
            storyButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func profileDidTapped(_ sender: Any) {
        onProfileTapped?()
    }
    
}
