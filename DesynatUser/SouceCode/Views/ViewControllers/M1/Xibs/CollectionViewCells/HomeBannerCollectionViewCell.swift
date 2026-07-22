//
//  HomeBannerCollectionViewCell.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addTitleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configData(data: HomescreenBannersList?) {
        if let imageUrl = data?.uploadBanner, let url = URL(string: imageUrl) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        addTitleLabel.text = "Ad".localiz()
    }
    
    func configDealData(data: HomeBottomBannerForDeals?) {
        
        if let imageUrl = data?.image, let url = URL(string: imageUrl) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        addTitleLabel.text = "Ad".localiz()
    }
    
}
