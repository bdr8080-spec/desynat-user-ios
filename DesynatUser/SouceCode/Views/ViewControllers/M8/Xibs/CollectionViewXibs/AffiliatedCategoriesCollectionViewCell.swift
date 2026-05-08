//
//  AffiliatedCategoriesCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit
import SDWebImage

class AffiliatedCategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var mainBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configDataForCategory(data: CategoriesDataModel?) {
        titleLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data?.nameAr : data?.name
        if let imageUrlString = data?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        mainBackgroundView.backgroundColor = UIColor(hexString: data?.colorCode ?? "")
    }
}
