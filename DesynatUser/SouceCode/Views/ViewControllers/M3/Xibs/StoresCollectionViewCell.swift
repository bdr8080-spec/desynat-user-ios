//
//  StoresCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage
import Cosmos

class StoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var statusView: CustomView!
    @IBOutlet weak var storyView: CustomView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblRating: UILabel!
    
    var onProfileTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func configData(data: StoreListDataModel) {
        ratingView.rating = data.averageStoreRating ?? 0
        lblRating.text = "(\(Double(data.averageStoreRating ?? 0)))"
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
        updateStoryUI(stories: data.sellerHighlightsModel ?? [])
    }
    
    func updateStoryUI(stories: [SellerHighlightsModel]) {
        guard !stories.isEmpty else {
            storyView.layer.borderWidth = 0
            storyButton.isUserInteractionEnabled = false
            return
        }
        storyButton.isUserInteractionEnabled = true
        storyView.borderWidth = 1
        let hasUnseenStory = stories.contains { $0.isSeen == 0 }
        
        if hasUnseenStory {
            storyView.borderColor = UIColor.accent
        } else {
            storyView.borderColor = UIColor(hexString: "AC7F5E")
        }
    }
    
    @IBAction func profileDidTapped(_ sender: Any) {
        onProfileTapped?()
    }
    
}
