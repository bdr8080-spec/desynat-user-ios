//
//  MyProductsSubCategoryCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit
import SDWebImage

class MyProductsSubCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: CustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: SubCategoriesDataModel?) {
        titleLabel.text = data?.nameEnglish
        if let imageUrlString = data?.image,
           let url = URL(string: imageUrlString) {
          mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
          mainImageView.sd_imageIndicator?.startAnimatingIndicator()
          mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
          mainImageView.image = UIImage(named: "")
        }
    }

}
