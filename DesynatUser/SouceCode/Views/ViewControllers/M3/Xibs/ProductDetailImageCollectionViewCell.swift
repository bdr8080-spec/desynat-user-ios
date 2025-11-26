//
//  ProductDetailImageCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit
import SDWebImage

class ProductDetailImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: String?) {
        if let imageUrlString = data,
               let url = URL(string: imageUrlString) {

            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            
            
            } else {
                mainImageView.image = UIImage(named: "")
            }
    }

}
