//
//  FilteredStoreCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage

class FilteredStoreCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var iscountPriceLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: CustomLabelFont!
  @IBOutlet weak var finalPriceLabel: UILabel!
  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configData(data: ProductList?) {
    titleLabel.text = data?.productNameEn
    if let imageUrlString = data?.productVariants?.first?.variantImage?.first,
             let url = URL(string: imageUrlString) {

        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()
        mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
          } else {
            mainImageView.image = UIImage(named: "")
          }
    finalPriceLabel.text = "\(data?.productVariants?.first?.finalPrice ?? "") KD"
    CommonUtils.setStrikethrough(label: actualPriceLabel, text: "\(data?.productVariants?.first?.actualPrice ?? "") KD")
    iscountPriceLabel.text = "\(data?.productVariants?.first?.discountValue ?? "") KD"
  }

}
