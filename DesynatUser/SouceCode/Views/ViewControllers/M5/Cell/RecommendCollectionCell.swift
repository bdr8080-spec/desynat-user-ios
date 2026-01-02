//
//  RecommendCollectionCell.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit
import SDWebImage

class RecommendCollectionCell: UICollectionViewCell {

  @IBOutlet weak var titleLabel: CustomLabelFont!
  @IBOutlet weak var mainImageView: CustomImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configData(data: RecommenedeSearch?) {
    if let returnImg = data?.image, let returnImgUrl = URL(string: returnImg) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: returnImgUrl, placeholderImage: UIImage(named: ""))
    } else {
      mainImageView.image = UIImage(named: "")
    }
    
    titleLabel.text = data?.nameEnglish
  }

}
