//
//  FullScreenBannersCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 16/01/26.
//

import UIKit
import SDWebImage

class FullScreenBannersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: HomescreenBannersList?) {
      if let imageUrl = data?.uploadBanner, let url = URL(string: imageUrl) {
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()
        mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
      } else {
        mainImageView.image = UIImage(named: "")
      }
    }


}
