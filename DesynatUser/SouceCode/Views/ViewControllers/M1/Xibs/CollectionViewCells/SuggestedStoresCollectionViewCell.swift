//
//  SuggestedStoresCollectionViewCell.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class SuggestedStoresCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configData(data: SuggestedStoresDataModel?) {
        titleLabel.text = data?.storeName ?? ""
        if let imageUrl = data?.storeImage, let url = URL(string: imageUrl) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            mainImageView.image = UIImage(named: "userProfile")
        }
    }

}
