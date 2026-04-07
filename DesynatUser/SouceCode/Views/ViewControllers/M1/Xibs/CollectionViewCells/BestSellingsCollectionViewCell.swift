//
//  BestSellingsCollectionViewCell.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage
import Cosmos

class BestSellingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var wishlistButtonTapped: (() -> Void)?
    var shareButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        wishlistButtonTapped?()
    }
    
    @IBAction func shareButtonOutket(_ sender: Any) {
        shareButtonTapped?()
    }
    
    private func setupUI() {
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainImageView.clipsToBounds = true
    }
    
    func configData(data: BestSellingProductsDataModel?) {
        titleLabel.text = data?.productNameEn
        ratingView.rating = Double(data?.reviewRating ?? "") ?? 0
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
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
    }
    
    func configDataForTopRatedProducts(data: TopRatedDataModel?) {
        titleLabel.text = data?.productNameEn
        ratingView.rating = Double(data?.reviewRating ?? "") ?? 0
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
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
    }
    
}
