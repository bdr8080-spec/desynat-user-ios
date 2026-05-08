//
//  CategoriesCollectionViewCell.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: SubCategoriesDataModel?) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data?.nameArabic
        } else {
            titleLabel.text = data?.nameEnglish
        }
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
