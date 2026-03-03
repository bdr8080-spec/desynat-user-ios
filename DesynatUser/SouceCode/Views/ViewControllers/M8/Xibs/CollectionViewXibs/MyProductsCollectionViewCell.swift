//
//  MyProductsCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit
import SDWebImage

class MyProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var commissionPercentageLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var onTrackPerformanceTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
    }

    @IBAction func trackPerformanceDidTapped(_ sender: Any) {
        onTrackPerformanceTapped?()
    }
    
    func configData(data: AffiliatedProductsList?) {
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
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        commissionPercentageLabel.text = "\(data?.affiliatedCommission ?? "0")% Commission"
    }
}
